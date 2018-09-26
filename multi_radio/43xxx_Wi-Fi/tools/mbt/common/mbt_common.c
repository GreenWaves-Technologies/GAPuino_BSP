#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mbt.h"

#if defined(_MSC_VER)
#include "tchar.h"

#define TRANSPORT "COMx"
#else
#define TRANSPORT "/dev/ttyUSBx"
#endif

/******************************************************
 *             Function Definitions
 ******************************************************/
void print_usage_reset(void)
{
    printf("Usage: mbt reset %s\n", TRANSPORT);
    printf("       NOTE: Sends HCI_RESET at 115200\n");
}

void print_usage_write_bd_addr(void)
{
    printf("Usage: mbt write_bd_addr %s bdaddr\n", TRANSPORT);
    printf("       EX: mbt write_bd_addr COM12 20703A123456\n");
}

void print_usage_read_bd_addr(void)
{
    printf("Usage: mbt read_bd_addr %s\n", TRANSPORT);
}

 void print_usage_download(void)
{
    printf("Usage: mbt download %s <hcd_pathname>\n", TRANSPORT);
}

void print_usage_le_receiver_test(void)
{
    printf ("Usage: mbt le_receiver_test %s <rx_channel>\n", TRANSPORT);
    printf ("                rx_channel = (F - 2402) / 2\n");
    printf ("                    Range: 0 - 39. Frequency Range : 2402 MHz to 2480 MHz\n");
}

void print_usage_le_test_end(void)
{
    printf ("Usage: mbt le_test_end %s\n", TRANSPORT);
}

void print_usage_le_transmitter_test(void)
{
    printf ("Usage: mbt le_transmitter_test %s <tx_channel> <data_length> <data_pattern>\n", TRANSPORT);
    printf ("                tx_channel = (F - 2402) / 2\n");
    printf ("                   Range: 0 - 39. Frequency Range : 2402 MHz to 2480 MHz\n");
    printf ("                data_length:  (0 - 37)\n");
    printf ("                data_pattern: (0 - 7)\n");
    printf ("                    0 - Pseudo-Random bit sequence 9\n");
    printf ("                    1 Pattern of alternating bits '11110000'\n");
    printf ("                    2 Pattern of alternating bits '10101010'\n");
    printf ("                    3 Pseudo-Random bit sequence 15\n");
    printf ("                    4 Pattern of All '1' bits\n");
    printf ("                    5 Pattern of All '0' bits\n");
    printf ("                    6 Pattern of alternating bits '00001111'\n");
    printf ("                    7 Pattern of alternating bits '0101'\n");
}

void print_usage_set_tx_frequency_arm(void)
{
    printf ("Usage: mbt set_tx_frequency_arm %s <carrier on/off> <tx_frequency> <tx_power>\n", TRANSPORT);
    printf ("                carrier on/off: 1 - carrier on, 0 - carrier_off\n");
    printf ("                tx_frequency: (2402 - 2480) transmit frequency, in MHz\n");
    printf ("                tx_power = (-25 - 13) transmit power in dbm\n");
}

void print_usage_receive_only_test(void)
{
    printf ("Usage: mbt write_receive_only %s <rx_frequency>\n", TRANSPORT);
    printf ("                rx_frequency = (2402 - 2480) receiver frequency, in MHz\n");
}

void print_usage_connectionless_dut_loopback_mode(void)
{
    printf("Usage: mbt connectionless_dut_loopback_mode %s\n", TRANSPORT);
}

void print_usage(void)
{
        printf("Usage: mbt help\n");
        print_usage_reset();
        print_usage_download();
        print_usage_write_bd_addr();
        print_usage_read_bd_addr();
        print_usage_le_receiver_test();
        print_usage_le_transmitter_test();
        print_usage_le_test_end();
        print_usage_set_tx_frequency_arm();
        print_usage_receive_only_test();
        print_usage_connectionless_dut_loopback_mode();
        printf("\nCheck Bluetooth Core 4.1 spec vol. 2 Sections 7.8.28-7.2.30\nfor details of LE Transmitter and Receiver tests\n");
}

#if defined(_MSC_VER)
int parse_input_command_args(int argc, _TCHAR* argv[])
#else
int parse_input_command_args(int argc, char **argv)
#endif
{
    uint  rx_frequency = 0;
    uint  tx_frequency = 0;
    uint  channel   = 0;
    uchar length       = 0;
    uchar pattern      = 0;

    if( (argc >= 2) && (COMPARE_STRING(argv[1],"reset")==0) )
    {
        if( argc == 3 )
        {
            return RESET;
        }
        else
        {
            print_usage_reset();
            return COMMAND_ARGS_ERROR;
        }
    }
    else if( (argc >= 3) && (COMPARE_STRING(argv[1], "download") == 0) )
    {
        if (argc == 4)
        {
            return DOWNLOAD;
        }
        print_usage_download();
    }
    else if ((argc >= 2) && (COMPARE_STRING(argv[1], "write_bd_addr") == 0))
    {
        if ((argc == 4) && (strlen(argv[3])==12))
        {
            return WRITE_BD_ADDR;
        }
        print_usage_write_bd_addr();
    }
    else if ((argc >= 2) && (COMPARE_STRING(argv[1], "read_bd_addr") == 0))
    {
        if (argc == 3)
        {
            return READ_BD_ADDR;
        }
        print_usage_read_bd_addr();
    }
    else if( (argc >= 2) && (COMPARE_STRING(argv[1], "le_receiver_test") == 0) )
    {
        if( argc == 4 )
        {
            channel = atoi(argv[3]);
            if ((channel >= 0) && (channel <= 39))
            {
                return LE_RECEIVER_TEST;
            }
        }
        print_usage_le_receiver_test();
    }
    else if( (argc >= 2) && (COMPARE_STRING(argv[1], "le_test_end") == 0) )
    {
        if (argc == 3)
        {
            return LE_TEST_END;
        }
        print_usage_le_test_end();
    }
    else if( (argc >= 2) && (COMPARE_STRING(argv[1], "le_transmitter_test") == 0) )
    {
        if (argc == 6)
        {
            channel = atoi(argv[3]);
            length  = atoi(argv[4]);
            pattern = atoi(argv[5]);

            if (((channel >= 0) && (channel <= 39)) &&
                ((length > 0) && (length <= 37))                   &&
                ((pattern >= 0) && (pattern < 7))                     )
            {
                return LE_TRANSMITTER_TEST;
            }
        }
        print_usage_le_transmitter_test();
    }
    else if( (argc >= 2) && (COMPARE_STRING(argv[1], "set_tx_frequency_arm") == 0) )
    {
        if (argc >= 5)
        {
            int carrier_on;
            carrier_on = atoi(argv[3]);
            if ((carrier_on == 0) || (carrier_on == 1))
            {
                if (carrier_on == 0)
                {
                    return SET_TX_FREQUENCY_ARM;
                }
                else if (argc == 6)
                {
                    int tx_frequency;
                    tx_frequency = atoi(argv[4]);
                    if ((tx_frequency >= 2402) && (tx_frequency <= 2480))
                    {
                        int tx_power;
                        tx_power = atoi(argv[7]);
                        if ((tx_power >= -25) && (tx_power <= 13))
                        {
                            return SET_TX_FREQUENCY_ARM;
                        }
                    }
                }
            }
        }
        print_usage_set_tx_frequency_arm();
    }
    else if( (argc >= 2) && (COMPARE_STRING(argv[1], "write_receive_only") == 0) )
    {
        if (argc == 4)
        {
            rx_frequency = atoi(argv[3]);
            if ((rx_frequency >= 2402) && (rx_frequency <= 2480))
            {
                return RECEIVE_ONLY;
            }
        }
        print_usage_receive_only_test();
    }
    else if ((argc >= 2) && (COMPARE_STRING(argv[1], "connectionless_dut_loopback_mode") == 0))
    {
        if (argc == 3)
        {
            return CONNECTOINLESS_DUT_LOOPBACK;
        }
        print_usage_connectionless_dut_loopback_mode();
    }
    else
    {
        return NO_COMMAND_MATCH;
    }

    return COMMAND_ARGS_ERROR;
}
