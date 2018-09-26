/*
 * $ Copyright Broadcom Corporation $
 */

/* mbt.cpp : Defines the entry point for the console application. */
#include "tchar.h"
#include "../common/mbt.h"
#include "mbt_com.h"


/* The connectionless_dut_loopback_mode takes the following parameters:
 * opcode - 3 bytes
 * length - 1 byte
 * bd_address - 6 bytes
 * lt_addr - 1 byte
 * no_of_tests - 1 byte
 * accepts 16 tests. each test would take 7 parameters of total 6 bytes length.- 96 bytes.
 * total[sum of all the parameters] - 108 bytes.
*/
#define CONNECTIONLESS_DUT_LOOPBACK_COMMAND_LENGTH 108
#define MAX_BD_ADDRESS_LENGTH 6

typedef unsigned char UINT8;

UINT8 in_buffer[1024];

//
// print hexadecimal digits of an array of bytes formatted as:
// 0000 < 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F >
// 0010 < 10 11 12 13 14 15 16 1718 19 1A 1B 1C 1D 1E 1F >
//
void HexDump(LPBYTE p, DWORD dwLen)
{
    for (DWORD i = 0; i < dwLen; ++i)
    {
        if (i % 16 == 0)
            printf("%04X <", i);
        printf(" %02X", p[i]);
        if ((i + 1) % 16 == 0)
            printf(" >\n");
    }
    printf(" >\n");
}

static BOOL send_hci_command(ComHelper *p_port, LPBYTE cmd, DWORD cmd_len, LPBYTE expected_evt, DWORD evt_len)
{
    /* write HCI response */
    printf("Sending HCI Command:\n");
    HexDump(cmd, cmd_len);

    p_port->Write(cmd, cmd_len);

    /* read HCI response header */
    DWORD dwRead = p_port->Read((LPBYTE)&in_buffer[0], 3);

    /* read HCI response payload */
    if (dwRead == 3 && in_buffer[2] > 0)
        dwRead += p_port->Read((LPBYTE)&in_buffer[3], in_buffer[2]);

    printf("Received HCI Event:\n");
    HexDump(in_buffer, dwRead);

    if (dwRead == evt_len)
    {
        if (memcmp(in_buffer, expected_evt, evt_len) == 0)
        {
            printf("Success\n");
            return TRUE;
        }
    }
    return FALSE;
}

static int execute_reset(char *szPort)
{
    ComHelper SerialPort;
    BOOL res;

    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }

    UINT8 hci_reset[] = {0x01, 0x03, 0x0c, 0x00};
    UINT8 hci_reset_cmd_complete_event[] = {0x04, 0x0e, 0x04, 0x01, 0x03, 0x0c, 0x00};

    res = send_hci_command(&SerialPort, hci_reset, sizeof(hci_reset), hci_reset_cmd_complete_event, sizeof(hci_reset_cmd_complete_event));
    if (!res)
        printf("\n failure");
    return res;
}

static int execute_write_bd_addr(char *szPort, char *bdaddr)
{
    ComHelper SerialPort;
    BOOL res;

    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }

    UINT8 params[6];

    sscanf_s(bdaddr, "%02x%02x%02x%02x%02x%02x", &params[0], &params[1], &params[2], &params[3], &params[4], &params[5]);

    UINT8 hci_write_bd_addr[] = { 0x01, 0x01, 0xFC, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
    UINT8 hci_write_bd_addr_cmd_complete_event[] = { 0x04, 0xe, 0x04, 0x01, 0x01, 0xFC, 0x00 };

    for( char i = 0; i < 6; i++ )
    {
        hci_write_bd_addr[i+4] = params[5-i];
    }

    res = send_hci_command(&SerialPort, hci_write_bd_addr, sizeof(hci_write_bd_addr), hci_write_bd_addr_cmd_complete_event, sizeof(hci_write_bd_addr_cmd_complete_event));
    if (!res)
        printf("\n failure");
    return res;
}

static void print_usage_read_bd_addr(void)
{
    printf("Usage: mbt read_bd_addr COMx\n");
}

static int execute_read_bd_addr(char *szPort)
{
    ComHelper SerialPort;
    BOOL res;

    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }

    UINT8 hci_read_bd_addr[] = { 0x01, 0x09, 0x10, 0x00 };
    UINT8 hci_read_bd_addr_cmd_complete_event[] = { 0x04, 0xe, 0x0A, 0x01, 0x09, 0x10, 0x00 };


    res = send_hci_command(&SerialPort, hci_read_bd_addr, sizeof(hci_read_bd_addr), hci_read_bd_addr_cmd_complete_event, sizeof(hci_read_bd_addr_cmd_complete_event));
    if (!res)
        printf("\n failure");
    return res;
}

static int execute_le_receiver_test(char *szPort, UINT8 chan_number)
{
    ComHelper SerialPort;
    BOOL res;

    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }

    UINT8 hci_le_receiver_test[] = {0x01, 0x01D, 0x20, 0x01, 0x00};
    UINT8 hci_le_receiver_test_cmd_complete_event[] = {0x04, 0x0e, 0x04, 0x01, 0x01D, 0x20, 0x00};
    hci_le_receiver_test[4] = chan_number;

    res = send_hci_command(&SerialPort, hci_le_receiver_test, sizeof(hci_le_receiver_test), hci_le_receiver_test_cmd_complete_event, sizeof(hci_le_receiver_test_cmd_complete_event));
    if (!res)
        printf("\n failure");
    return res;
}

static int execute_le_transmitter_test(char *szPort, UINT8 chan_number, UINT8 length, UINT8 pattern)
{
    ComHelper SerialPort;
    BOOL res;

    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }

    UINT8 hci_le_transmitter_test[] = {0x01, 0x01E, 0x20, 0x03, 0x00, 0x00, 0x00};
    UINT8 hci_le_transmitter_test_cmd_complete_event[] = {0x04, 0x0e, 0x04, 0x01, 0x01E, 0x20, 0x00};
    hci_le_transmitter_test[4] = chan_number;
    hci_le_transmitter_test[5] = length;
    hci_le_transmitter_test[6] = pattern;

    res = send_hci_command(&SerialPort, hci_le_transmitter_test, sizeof(hci_le_transmitter_test), hci_le_transmitter_test_cmd_complete_event, sizeof(hci_le_transmitter_test_cmd_complete_event));
    if (!res)
        printf("\n failure");
    return res;
}

static int execute_le_test_end(char *szPort)
{
    ComHelper SerialPort;

    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }

    UINT8 hci_le_test_end[] = {0x01, 0x1f, 0x20, 0x00};
    UINT8 hci_le_test_end_cmd_complete_event[] = {0x04, 0x0e, 0x06, 0x01, 0x1f, 0x20, 0x00};

    printf ("Sending HCI Command:\n");
    HexDump(hci_le_test_end, sizeof(hci_le_test_end));

    /* write HCI response */
    SerialPort.Write(hci_le_test_end, sizeof(hci_le_test_end));

    /* read HCI response header */
    DWORD dwRead = SerialPort.Read((LPBYTE)&in_buffer[0], 3);

    /* read HCI response payload */
    if (dwRead == 3 && in_buffer[2] > 0)
        dwRead += SerialPort.Read((LPBYTE)&in_buffer[3], in_buffer[2]);

    printf ("Received HCI Event:\n");
    HexDump(in_buffer, dwRead);
    if ((dwRead > sizeof(hci_le_test_end_cmd_complete_event))
     && (memcmp(in_buffer, hci_le_test_end_cmd_complete_event, sizeof(hci_le_test_end_cmd_complete_event)) == 0))
    {
        printf("Success num_packets_received %d\n", in_buffer[7] + (in_buffer[8] << 8));
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

static int execute_set_tx_frequency_arm(char *szPort, UINT8 carrier_on, UINT16 tx_frequency, int tx_power)
{
    ComHelper SerialPort;
    BOOL res;

    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }
    int chan_num = tx_frequency - 2400;
    UINT8 hci_set_tx_frequency_arm[] = {0x01, 0x014, 0xfc, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    UINT8 hci_set_tx_frequency_arm_cmd_complete_event[] = {0x04, 0x0e, 0x04, 0x01, 0x014, 0xfc, 0x00};
    hci_set_tx_frequency_arm[4] = (carrier_on == 0) ? 1 : 0;
    hci_set_tx_frequency_arm[5] = (carrier_on == 1) ? chan_num : 2;
    hci_set_tx_frequency_arm[6] = 0;                // unmodulated
    hci_set_tx_frequency_arm[7] = 0;                // modulation type
    hci_set_tx_frequency_arm[8] = (carrier_on == 1) ? 8 : 0;
    hci_set_tx_frequency_arm[9] = tx_power;

    res = send_hci_command(&SerialPort, hci_set_tx_frequency_arm, sizeof(hci_set_tx_frequency_arm), hci_set_tx_frequency_arm_cmd_complete_event, sizeof(hci_set_tx_frequency_arm_cmd_complete_event));
    if (!res)
        printf("\n failure");
    return res;
}

static int execute_receive_only(char *szPort, UINT16 tx_frequency)
{
    ComHelper SerialPort;
    BOOL res;

    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }
    int chan_num = tx_frequency - 2400;
    UINT8 hci_write_receive_only[] = {0x01, 0x02b, 0xfc, 0x01, 0x00};
    UINT8 hci_write_receive_only_cmd_complete_event[] = {0x04, 0x0e, 0x04, 0x01, 0x02b, 0xfc, 0x00};
    hci_write_receive_only[4] = chan_num;

    res = send_hci_command(&SerialPort, hci_write_receive_only, sizeof(hci_write_receive_only), hci_write_receive_only_cmd_complete_event, sizeof(hci_write_receive_only_cmd_complete_event));
    if (!res)
        printf("\n failure");
    return res;
}

static void print_usage_connectionless_dut_loopback_mode(bool full)
{
    printf("Usage: mbt connectionless_dut_loopback_mode COMx\n");
}

static int execute_connectionless_dut_loopback_mode(char *szPort)
{
    ComHelper SerialPort;
    BOOL res;

    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }
    UINT8 hci_lp[CONNECTIONLESS_DUT_LOOPBACK_COMMAND_LENGTH];
    UINT8 hci_lp_cmd_complete_event[] = {0x04, 0x0e, 0x06, 0x01, 0x54, 0xfc, 0x00, 0x00, 0x00};
    UINT32 value = 0;
    int i, j;
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
    for (j = 0; j < 6; j++)
    {
        scanf_s("%x",&bd[j]);
    }
    /* copy bd address to hci_lp in reversed way */
    for (i = 4, j = 5; j >= 0; i++, j--)
    {
        hci_lp[i] = bd[j];
    }
    printf("enter Lt address [0x01-0x07]:\n");
    scanf_s("%x", &lt_addr);
    printf("enter the number of tests[0x01-0x10]:\n");
    scanf_s("%x", &no_of_tests);

    /* copy lt address and no of tests to hci_lp */
    hci_lp[10] = lt_addr;
    hci_lp[11] = no_of_tests;

    /* loop for the number of tests */
    for (j = 0, i = 12; j < no_of_tests; j++, i+=6)
    {
        printf("enter the retry offset[%d]-[0x01-0x3f]:\n",j+1);
        scanf_s("%x", &retry_offset);

        printf("enter no of packets[%d]-[0x01-0x7fff]:\n",j+1);
        scanf_s("%x", &no_of_packets);

        printf("Enter the TX power[%d]-[0x00-0x07]\n",j+1);
        scanf_s("%x", &tx);

        printf("Enter the RX power[%d]-[0x00-0x7f]\n",j+1);
        scanf_s("%x", &rx);

        printf("enter the packet table type[%d][0-Basic][1-enhanced]:\n",j+1);
        scanf_s("%x",&pkt_type);

        value |= ( ( ( retry_offset & 0x3f ) << 26 ) | ( ( no_of_packets & 0x7fff ) << 11 ) | ( ( tx & 0x07 ) << 8 ) | ( ( rx & 0x7f ) << 1 ) | ( ( pkt_type & 0x01 ) << 0 ) );
        hci_lp[i]     = ( value & 0x000000ff );
        hci_lp[i + 1] = ( ( value & 0x0000ff00 ) >> 8 );
        hci_lp[i + 2] = ( ( value & 0x00ff0000 ) >> 16 );
        hci_lp[i + 3] = ( ( value & 0xff000000 ) >> 24 );

        printf("enter retry time out[%d]-[0x01-0xff]:\n",j+1);
        scanf_s("%x",&ret_time);
        hci_lp[i + 4] = ret_time;

        printf("enter test_scenarios[%d]:\n",j+1);
        scanf_s("%x",&test);
        hci_lp[i + 5] = test;
        count++;
    }

    /* length added here */
    hci_lp[3] = (count * 6) + 8;
    len = hci_lp[3] + 4;

    res = send_hci_command(&SerialPort, hci_lp, len, hci_lp_cmd_complete_event, sizeof(hci_lp_cmd_complete_event));
    if (!res)
        printf("\n failure");
    return res;
}

static int SendDownloadMinidriver(char *szPort)
{
    ComHelper SerialPort;
    BOOL res;
    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }
    BYTE arHciCommandTx[] = { 0x01, 0x2E, 0xFC, 0x00 };
    BYTE arBytesExpectedRx[] = { 0x04, 0x0E, 0x04, 0x01, 0x2E, 0xFC, 0x00 };

    res = send_hci_command(&SerialPort, arHciCommandTx, sizeof(arHciCommandTx), arBytesExpectedRx, sizeof(arBytesExpectedRx));
    if (!res)
        printf("\n failure");
    return res;
}

static int SendHcdRecord(char *szPort, ULONG nAddr, ULONG nHCDRecSize, BYTE * arHCDDataBuffer)
{
    ComHelper SerialPort;
    BOOL res;
    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }
    BYTE arHciCommandTx[261] = { 0x01, 0x4C, 0xFC, 0x00 };
    BYTE arBytesExpectedRx[] = { 0x04, 0x0E, 0x04, 0x01, 0x4C, 0xFC, 0x00 };

    arHciCommandTx[3] = (BYTE)(4 + nHCDRecSize);
    arHciCommandTx[4] = (nAddr & 0xff);
    arHciCommandTx[5] = (nAddr >> 8) & 0xff;
    arHciCommandTx[6] = (nAddr >> 16) & 0xff;
    arHciCommandTx[7] = (nAddr >> 24) & 0xff;
    memcpy(&arHciCommandTx[8], arHCDDataBuffer, nHCDRecSize);

    printf("sending record at:0x%x\n", nAddr);
    res = send_hci_command(&SerialPort, arHciCommandTx, 4 + 4 + nHCDRecSize, arBytesExpectedRx, sizeof(arBytesExpectedRx));
    if (!res)
        printf("\n failure");
    return res;
}

BOOL ReadNextHCDRecord(FILE * fHCD, ULONG * nAddr, ULONG * nHCDRecSize, UINT8 * arHCDDataBuffer, BOOL * bIsLaunch)
{
    const   int HCD_LAUNCH_COMMAND = 0x4E;
    const   int HCD_WRITE_COMMAND = 0x4C;
    const   int HCD_COMMAND_BYTE2 = 0xFC;

    BYTE     arRecHeader[3];
    BYTE     byRecLen;
    BYTE     arAddress[4];

    *bIsLaunch = FALSE;

    if (fread(arRecHeader, 1, 3, fHCD) != 3)               // Unexpected EOF
        return false;

    byRecLen = arRecHeader[2];

    if ((byRecLen < 4) || (arRecHeader[1] != HCD_COMMAND_BYTE2) ||
        ((arRecHeader[0] != HCD_WRITE_COMMAND) && (arRecHeader[0] != HCD_LAUNCH_COMMAND)))
    {
        printf("Wrong HCD file format trying to read the command information\n");
        return FALSE;
    }

    if (fread(arAddress, sizeof(arAddress), 1, fHCD) != 1)      // Unexpected EOF
    {
        printf("Wrong HCD file format trying to read 32-bit address\n");
        return FALSE;
    }

    *nAddr = arAddress[0] + (arAddress[1] << 8) + (arAddress[2] << 16) + (arAddress[3] << 24);

    *bIsLaunch = (arRecHeader[0] == HCD_LAUNCH_COMMAND);

    *nHCDRecSize = byRecLen - 4;

    if (*nHCDRecSize > 0)
    {
        if (fread(arHCDDataBuffer, 1, *nHCDRecSize, fHCD) != *nHCDRecSize)   // Unexpected EOF
        {
            printf("Not enough HCD data bytes in record\n");
            return FALSE;
        }
    }

    return TRUE;
}

static int SendLaunchRam(char *szPort)
{
    ComHelper SerialPort;
    BOOL res;
    if (!SerialPort.OpenPort(szPort))
    {
        printf("Open %s port Failed\n", szPort);
        return 0;
    }
    BYTE arHciCommandTx[] = { 0x01, 0x4E, 0xFC, 0x04, 0xFF, 0xFF, 0xFF, 0xFF };
    BYTE arBytesExpectedRx[] = { 0x04, 0x0E, 0x04, 0x01, 0x4E, 0xFC, 0x00 };

    res = send_hci_command(&SerialPort, arHciCommandTx, sizeof(arHciCommandTx), arBytesExpectedRx, sizeof(arBytesExpectedRx));
}

static int execute_download(char *szPort, char *pathname)
{
    ComHelper SerialPort;

    FILE *          fHCD = NULL;
    LONG            nVeryFirstAddress = 0;

    fopen_s(&fHCD, pathname, "rb");
    if (!fHCD)
    {
        printf("Failed to open HCD file %s", pathname);
        return 0;
    }
    if (!execute_reset(szPort))
    {
        if (!execute_reset(szPort))
        {
            printf("Failed to HCI Reset\n");
            fclose(fHCD);
            return 0;
        }
    }
    printf("HCI Reset success\n");
    if (!SendDownloadMinidriver(szPort))
    {
        printf("Failed to send download minidriver\n");
        fclose(fHCD);
        return 0;
    }
    printf("Download minidriver success, downloading configuration...\n");
    ULONG   nAddr, nHCDRecSize;
    BYTE    arHCDDataBuffer[256];
    BOOL    bIsLaunch = FALSE;
    while (ReadNextHCDRecord(fHCD, &nAddr, &nHCDRecSize, arHCDDataBuffer, &bIsLaunch))
    {
        if (!SendHcdRecord(szPort, nAddr, nHCDRecSize, arHCDDataBuffer))
        {
            printf("Failed to send hcd portion at %x\n", nAddr);
            if (fHCD)
                fclose(fHCD);
            return 0;
        }
        if (bIsLaunch)
            break;
    }
    printf("Download configuration success\n");

    if (!SendLaunchRam(szPort))
    {
        printf("Failed to send launch RAM\n");
    }
    printf("Launch RAM success\n");
    fclose(fHCD);
    return 1;
}

int _tmain(int argc, _TCHAR* argv[])
{
    int command;
    UINT8 carrier_on;

    command = parse_input_command_args(argc, argv);

    switch (command)
    {
    case RESET:
        execute_reset(argv[2]);
        break;

    case DOWNLOAD:
        execute_download(argv[2], argv[3]);
        break;

    case WRITE_BD_ADDR:
        execute_write_bd_addr(argv[2], argv[3]);
        break;

    case READ_BD_ADDR:
        execute_read_bd_addr(argv[2]);
        break;

    case LE_RECEIVER_TEST:
        execute_le_receiver_test(argv[2], atoi(argv[3]));
        break;

    case LE_TEST_END:
        execute_le_test_end(argv[2]);
        break;

    case LE_TRANSMITTER_TEST:
        execute_le_transmitter_test(argv[2], atoi(argv[3]), atoi(argv[4]), atoi(argv[5]));
        break;

    case SET_TX_FREQUENCY_ARM:
        carrier_on = atoi(argv[3]);
        if (carrier_on == 0)
            execute_set_tx_frequency_arm(argv[2], carrier_on, 2402, 0);
        else
            execute_set_tx_frequency_arm(argv[2], carrier_on, atoi(argv[4]), atoi(argv[5]));
        break;

    case RECEIVE_ONLY:
        execute_receive_only(argv[2], atoi(argv[3]));
        break;

    case CONNECTOINLESS_DUT_LOOPBACK:
        execute_connectionless_dut_loopback_mode(argv[2]);
        break;

    case NO_COMMAND_MATCH:
        print_usage();
        break;

    default:
        break;
    }

    return 0;
}

