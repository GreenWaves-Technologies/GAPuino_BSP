/*
 * mbt.h
 *
 *  Created on: Dec 22, 2016
 *      Author: jgui
 */

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_MSC_VER)
#include "tchar.h"
#endif

/******************************************************
 *          External Function Declarations
 ******************************************************/
extern void print_usage_reset(void);
extern void print_usage_download(void);
extern void print_usage_write_bd_addr(void);
extern void print_usage_read_bd_addr(void);
extern void print_usage_le_receiver_test(void);
extern void print_usage_le_test_end(void);
extern void print_usage_le_transmitter_test(void);
extern void print_usage_set_tx_frequency_arm(void);
extern void print_usage_receive_only_test(void);
static void print_usage_connectionless_dut_loopback_mode(void);
extern void print_usage(void);

#if defined(_MSC_VER)
extern int parse_input_command_args(int argc, _TCHAR* argv[]);
#else
extern int parse_input_command_args(int argc, char **argv);
#endif

/******************************************************
 *                     Macros
 ******************************************************/
#if defined(_MSC_VER)
#define COMPARE_STRING(x,y)     _stricmp(x,y)
#else
#define COMPARE_STRING(x,y)     strcmp(x,y)
#endif

#define CONNECTIONLESS_DUT_LOOPBACK_COMMAND_LENGTH 108
#define MAX_BD_ADDRESS_LENGTH                      6

#define RESET                       0
#define DOWNLOAD                    1
#define WRITE_BD_ADDR               2
#define READ_BD_ADDR                3
#define LE_RECEIVER_TEST            4
#define LE_TEST_END                 5
#define LE_TRANSMITTER_TEST         6
#define SET_TX_FREQUENCY_ARM        7
#define RECEIVE_ONLY                8
#define CONNECTOINLESS_DUT_LOOPBACK 9
#define COMMAND_ARGS_ERROR          100
#define NO_COMMAND_MATCH            101

typedef unsigned char uchar;
typedef unsigned int  uint;

#ifdef __cplusplus
}
#endif
