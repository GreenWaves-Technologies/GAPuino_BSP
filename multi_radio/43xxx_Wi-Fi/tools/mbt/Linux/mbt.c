/*
 * $ Copyright Broadcom Corporation $
 */


/*****************************************************************************
 *
 *  Name:          mbt.c
 *
 *  Description:   The manufacturing Bluetooth test tool (MBT) is used to test and verify the RF
 *                 performance of the Cypress family of SoC Bluetooth BR/EDR/BLE standalone and
 *                 combo devices. Each test sends an HCI command to the device and then waits
 *                 for an HCI Command Complete event from the device.
 *
 *                 For usage description, execute:
 *
 *                 ./mbt help
 *
 *****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/termios.h>
#include <pthread.h>

#include "mbt.h"

/******************************************************
*                    Constants
******************************************************/
#define ERROR    1
#define SUCCESS  0

/******************************************************
 *               Function Declarations
 ******************************************************/
static void execute_reset(void);
static void execute_le_receiver_test(uint rx_frequency);
static void execute_le_test_end(void);
static void execute_le_transmitter_test(uint tx_frequency, uchar length, uchar pattern);
static void execute_set_tx_frequency_arm(uchar carrier_on, uint tx_frequency, int tx_power);
static void execute_receive_only(uint rx_frequency);

/******************************************************
 *               Variables Definitions
 ******************************************************/
struct termios termios;

int uart_fd          = -1;
int hcdfile_fd       = -1;
int debug            = 1;
int rx_radio_disable = 0;

uchar buffer[1024];

uchar hci_reset[] = { 0x01, 0x03, 0x0c, 0x00 };

/******************************************************
 *               Function Definitions
 ******************************************************/
int parse_patchram(char *optarg)
{
    char *p;

    if (!(p = strrchr(optarg, '.'))) {
        fprintf(stderr, "file %s not an HCD file\n", optarg);
        exit(3);
    }

    p++;

    if (strcasecmp("hcd", p) != 0) {
        fprintf(stderr, "file %s not an HCD file\n", optarg);
        exit(4);
    }

    if ((hcdfile_fd = open(optarg, O_RDONLY)) == -1) {
        fprintf(stderr, "file %s could not be opened, error %d\n", optarg, errno);
        exit(5);
    }

    return(0);
}

void init_uart(void)
{
    tcflush(uart_fd, TCIOFLUSH);
    tcgetattr(uart_fd, &termios);

    termios.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP
                | INLCR | IGNCR | ICRNL | IXON);
    termios.c_oflag &= ~OPOST;
    termios.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
    termios.c_cflag &= ~(CSIZE | PARENB);
    termios.c_cflag |= CS8;
    termios.c_cflag &= ~CRTSCTS;

    tcsetattr(uart_fd, TCSANOW, &termios);
    tcflush(uart_fd, TCIOFLUSH);
    tcsetattr(uart_fd, TCSANOW, &termios);
    tcflush(uart_fd, TCIOFLUSH);
    tcflush(uart_fd, TCIOFLUSH);
    cfsetospeed(&termios, B115200);
    cfsetispeed(&termios, B115200);
    tcsetattr(uart_fd, TCSANOW, &termios);
}

void dump(uchar *out, int len)
{
    int i;

    for (i = 0; i < len; i++)
    {
        if (i && !(i % 16))
        {
            fprintf(stderr, "\n");
        }

        fprintf(stderr, "%02x ", out[i]);
    }
    fprintf(stderr, "\n");
}

int read_event(int fd, uchar *buffer)
{
    int i = 0;
    int len = 3;
    int count;

    while ((count = read(fd, &buffer[i], len)) < len)
    {
        i += count;
        len -= count;
    }

    i += count;
    len = buffer[2];

    while ((count = read(fd, &buffer[i], len)) < len)
    {
        i += count;
        len -= count;
    }

    count += i;

    if(debug)
    {
        fprintf(stderr, "received %d\n", count);
        dump(buffer, count);
    }

    return count;
}

void hci_send_cmd(uchar *buf, int len)
{
    fprintf(stderr, "writing\n");
    dump(buf, len);

    write(uart_fd, buf, len);
}

void proc_patchram(void)
{
    int len;
    uchar hci_download_minidriver[] = { 0x01, 0x2e, 0xfc, 0x00 };

    hci_send_cmd(hci_download_minidriver, sizeof(hci_download_minidriver));

    read_event(uart_fd, buffer);

    while( read(hcdfile_fd, &buffer[1], 3) )
    {
        buffer[0] = 0x01;

        len = buffer[3];

        read(hcdfile_fd, &buffer[4], len);

        hci_send_cmd(buffer, len + 4);

        read_event(uart_fd, buffer);
    }

    execute_reset();
}

void execute_download(char* file_name)
{
    char* pathname = file_name;

    execute_reset();

    parse_patchram(pathname);

    proc_patchram();
}

static int process_user_hex_input(uchar *params, int max_length)
{
    int len;

    fgets(params, max_length+1, stdin);
    len = (int)strlen(params);

    if( (len <= max_length) && (len >= 4) )
    {
        return SUCCESS;
    }
    else
    {
        printf("Please be sure to input hex format including leading 0x\n");
        return ERROR;
    }
}
/******************************************************
 *            HCI Function Definitions
 ******************************************************/
void expired(int sig)
{
    hci_send_cmd(hci_reset, sizeof(hci_reset));
    alarm(4);
}

static void execute_reset(void)
{
    signal(SIGALRM, expired);

    hci_send_cmd(hci_reset, sizeof(hci_reset));

    alarm(4);

    read_event(uart_fd, buffer);

    alarm(0);
}

static void execute_write_bd_addr(char *bdaddr)
{
    int   params[6];
    int   i;
    uchar hci_write_bd_addr[] = { 0x01, 0x01, 0xFC, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

    sscanf(bdaddr, "%02x%02x%02x%02x%02x%02x", &params[0], &params[1], &params[2], &params[3], &params[4], &params[5]);

    for( i = 0; i < 6; i++ )
    {
        hci_write_bd_addr[i + 4] = params[5 - i];    //bd address
    }

    hci_send_cmd(hci_write_bd_addr, sizeof(hci_write_bd_addr));

    read_event(uart_fd, buffer);
}

static void execute_read_bd_addr(void)
{
    uchar hci_read_bd_addr[] = { 0x01, 0x09, 0x10, 0x00 };

    hci_send_cmd(hci_read_bd_addr, sizeof(hci_read_bd_addr));

    read_event(uart_fd, buffer);
}

static void execute_le_receiver_test(uint rx_channel)
{
    uchar hci_le_receiver_test[] = { 0x01, 0x01D, 0x20, 0x01, 0x00 };

    hci_le_receiver_test[4] = rx_channel;

    hci_send_cmd(hci_le_receiver_test, sizeof(hci_le_receiver_test));

    read_event(uart_fd, buffer);
}

static void execute_le_test_end(void)
{
    uchar hci_le_test_end[] = { 0x01, 0x1f, 0x20, 0x00 };

    hci_send_cmd(hci_le_test_end, sizeof(hci_le_test_end));

    read_event(uart_fd, buffer);

    if( (buffer[4]==0x1F) && (buffer[5]==0x20) )
    {
        printf("Success num_packets_received %d\n", buffer[7] + (buffer[8]<<8) );
    }
}

static void execute_le_transmitter_test(uint tx_channel, uchar length, uchar pattern)
{
    uchar hci_le_transmitter_test[] = { 0x01, 0x01E, 0x20, 0x03, 0x00, 0x00, 0x00 };

    hci_le_transmitter_test[4] = tx_channel;
    hci_le_transmitter_test[5] = length;
    hci_le_transmitter_test[6] = pattern;

    hci_send_cmd(hci_le_transmitter_test, sizeof(hci_le_transmitter_test));

    read_event(uart_fd, buffer);
}

static void execute_set_tx_frequency_arm(uchar carrier_on, uint tx_frequency, int tx_power)
{
    uchar hci_set_tx_frequency_arm[] = { 0x01, 0x014, 0xfc, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

    hci_set_tx_frequency_arm[4] = (carrier_on == 0) ? 1 : 0;
    hci_set_tx_frequency_arm[5] = (carrier_on == 1) ? (tx_frequency - 2400) : 2;
    hci_set_tx_frequency_arm[6] = 0;                // unmodulated
    hci_set_tx_frequency_arm[7] = 0;                // modulation type
    hci_set_tx_frequency_arm[8] = (carrier_on == 1) ? 8 : 0;
    hci_set_tx_frequency_arm[9] = tx_power;

    hci_send_cmd(hci_set_tx_frequency_arm, sizeof(hci_set_tx_frequency_arm));

    read_event(uart_fd, buffer);
}

static void execute_receive_only(uint rx_frequency)
{
    uchar chan_num = rx_frequency - 2400;
    uchar hci_write_receive_only[] = { 0x01, 0x02b, 0xfc, 0x01, 0x00 };

    hci_write_receive_only[4] = chan_num;

    hci_send_cmd(hci_write_receive_only, sizeof(hci_write_receive_only));

    read_event(uart_fd, buffer);
}

static void execute_connectionless_dut_loopback_mode(void)
{
    uchar hci_lp[CONNECTIONLESS_DUT_LOOPBACK_COMMAND_LENGTH];
    uchar hci_lp_cmd_complete_event[] = {0x04, 0x0e, 0x06, 0x01, 0x54, 0xfc, 0x00, 0x00, 0x00};
    uchar params[12];
    uint value = 0;
    int i, j, x, y;
    int bd[MAX_BD_ADDRESS_LENGTH], lt_addr;
    int no_of_tests, retry_offset, no_of_packets;
    int pkt_type, ret_time, test, count = 0;
    int len = 0;
    int tx, rx;


    /* opcode */
    hci_lp[0] = 0x01;
    hci_lp[1] = 0x54;
    hci_lp[2] = 0xfc;

    /* length */
    hci_lp[3] = 0x00;

    printf("Enter the following parameters in hexadecimal [0xXX]\n");
    printf("Enter BD address[6 bytes of length]:\n");

    fgets(params, 31, stdin);
    len = (int)strlen(params);

    if( len != 30 )
    {
        printf("BD Address format should be: 0x00 0x11 0x22 0x33 0x44 0x55\n");
        return;
    }
    sscanf(params, "0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x", &bd[0], &bd[1], &bd[2], &bd[3], &bd[4], &bd[5]);

    /* copy bd address to hci_lp in reversed way */
    for (i = 4, j = 5; j >= 0; i++, j--)
    {
        hci_lp[i] = bd[j];
    }

    printf("enter Lt address [0x01-0x07]:\n");
    if( process_user_hex_input(params, 5) == ERROR)
        return;
    sscanf(params, "0x%02x", &lt_addr);

    printf("enter the number of tests[0x01-0x10]:\n");
    if( process_user_hex_input(params, 5) == ERROR)
        return;
    sscanf(params, "0x%02x", &no_of_tests);

    /* copy lt address and no of tests to hci_lp */
    hci_lp[10] = lt_addr;
    hci_lp[11] = no_of_tests;

    /* loop for the number of tests */
    for (j = 0, i = 12; j < no_of_tests; j++, i+=6)
    {
        printf("enter the retry offset[%d]-[0x01-0x3f]:\n",j+1);
        if( process_user_hex_input(params, 5) == ERROR)
            return;
        sscanf(params, "0x%02x", &retry_offset);

        printf("enter no of packets[%d]-[0x01-0x7fff]:\n",j+1);
        if( process_user_hex_input(params, 7) == ERROR)
            return;
        sscanf(params, "0x%04x", &no_of_packets);

        printf("Enter the TX power[%d]-[0x00-0x07]\n",j+1);
        if( process_user_hex_input(params, 5) == ERROR)
            return;
        sscanf(params, "0x%02x", &tx);

        printf("Enter the RX power[%d]-[0x00-0x7f]\n",j+1);
        if( process_user_hex_input(params, 5) == ERROR)
            return;
        sscanf(params, "0x%02x", &rx);

        printf("enter the packet table type[%d][0-Basic][1-enhanced]:\n",j+1);
        fgets(params, 3, stdin);
        sscanf(params, "%d", &pkt_type);

        value |= ( ( ( retry_offset & 0x3f ) << 26 ) | ( ( no_of_packets & 0x7fff ) << 11 ) | ( ( tx & 0x07 ) << 8 ) | ( ( rx & 0x7f ) << 1 ) | ( ( pkt_type & 0x01 ) << 0 ) );
        hci_lp[i]     = ( value & 0x000000ff );
        hci_lp[i + 1] = ( ( value & 0x0000ff00 ) >> 8 );
        hci_lp[i + 2] = ( ( value & 0x00ff0000 ) >> 16 );
        hci_lp[i + 3] = ( ( value & 0xff000000 ) >> 24 );

        printf("enter retry time out[%d]-[0x01-0xff]:\n",j+1);
        if( process_user_hex_input(params, 5) == ERROR)
            return;
        sscanf(params, "0x%02x", &ret_time);
        hci_lp[i + 4] = ret_time;

        printf("enter test_scenarios[%d]-[0x00-0xff]:\n",j+1);
        if( process_user_hex_input(params, 5) == ERROR)
            return;
        sscanf(params, "0x%02x", &test);
        hci_lp[i + 5] = test;

        count++;
    }

    /* length added here */
    hci_lp[3] = (count * 6) + 8;
    len = hci_lp[3] + 4;

    hci_send_cmd(hci_lp, hci_lp[3] + 4);

    read_event(uart_fd, buffer);
}

/******************************************************
 *                        main
 ******************************************************/
int main (int argc, char **argv)
{
    int command, carrier_on;;

    if( argc >= 3 )
    {
        if( (uart_fd = open(argv[2], O_RDWR | O_NOCTTY)) == -1 )
        {
            printf("port %s could not be opened, error %d\n", argv[2], errno);
            exit(EXIT_FAILURE);
        }
        else
        {
            printf( "Opened port %s\n", argv[2] );
        }
    }
    else
    {
        print_usage();
        exit(EXIT_SUCCESS);
    }

    // Initialize the uart interface
    init_uart();

    command = parse_input_command_args(argc, argv);

    switch( command )
    {
    case RESET:
        execute_reset();
        break;

    case DOWNLOAD:
        execute_download(argv[3]);
        break;

    case WRITE_BD_ADDR:
        execute_write_bd_addr(argv[3]);
        break;

    case READ_BD_ADDR:
        execute_read_bd_addr();
        break;

    case LE_RECEIVER_TEST:
        execute_le_receiver_test(atoi(argv[3]));
        break;

    case LE_TEST_END:
        execute_le_test_end();
        break;

    case LE_TRANSMITTER_TEST:
        execute_le_transmitter_test(atoi(argv[3]), atoi(argv[4]), atoi(argv[5]));
        break;

    case SET_TX_FREQUENCY_ARM:
        carrier_on = atoi(argv[3]);

        if(carrier_on == 0)
            execute_set_tx_frequency_arm(carrier_on, 2402, 0);
        else
            execute_set_tx_frequency_arm(carrier_on, atoi(argv[4]), atoi(argv[5]));
        break;

    case RECEIVE_ONLY:
        execute_receive_only(atoi(argv[3]));
        break;

    case CONNECTOINLESS_DUT_LOOPBACK:
        execute_connectionless_dut_loopback_mode();
        break;

    case NO_COMMAND_MATCH:
        print_usage();
        break;

    default:
        break;
    }

    printf( "exiting.\n" );

    close(uart_fd);

    exit(EXIT_SUCCESS);
}
