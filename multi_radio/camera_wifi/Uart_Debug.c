/**
  ******************************************************************************
  * @file           : Uart_Debug.c
  * @brief          : Debug Utility Tool
  ******************************************************************************
  ** This notice applies to any and all portions of this file
  * that are not between comment pairs USER CODE BEGIN and
  * USER CODE END. Other portions of this file, whether 
  * inserted by the user or by software development tools
  * are owned by their respective copyright owners.
  *
  * COPYRIGHT(c) 2018 Univerità degli studi di Bologna - Tommaso Polonelli
  *
  * Redistribution and use in source and binary forms, with or without modification,
  * are permitted provided that the following conditions are met:
  *   1. Redistributions of source code must retain the above copyright notice,
  *      this list of conditions and the following disclaimer.
  *   2. Redistributions in binary form must reproduce the above copyright notice,
  *      this list of conditions and the following disclaimer in the documentation
  *      and/or other materials provided with the distribution.
  *   3. Neither the name of STMicroelectronics nor the names of its contributors
  *      may be used to endorse or promote products derived from this software
  *      without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  */

#include "rt/rt_api.h"
#include "Uart_Debug.h"

/******************************************************
 *                      Macros
 ******************************************************/
#define BAUDRATE              (115200)
#define UART_DEBUG_BUFF_SIZE  (256)

/******************************************************
 *                 Type Definitions
 ******************************************************/

/******************************************************
 *                    Constants
 ******************************************************/

/******************************************************
 *                   Enumerations
 ******************************************************/

/******************************************************
 *                    Structures
 ******************************************************/

/******************************************************
 *               Static Function Declarations
 ******************************************************/

 /******************************************************
 *               Variable Definitions
 ******************************************************/

rt_uart_t *uart_handler;
uint8_t *uart_debug_buff;
int uart_debug_str_size;
uint8_t uart_debug_rx_buff;

/******************************************************
 *               Function Definitions
 ******************************************************/

void Uart_Debug_Init ( void ){

    /*Init uart*/
    rt_uart_conf_t conf_uart;
    rt_uart_conf_init(&conf_uart);
    conf_uart.itf = 0;
    conf_uart.baudrate = BAUDRATE;
    uart_handler = rt_uart_open(NULL, &conf_uart, NULL);
    if (uart_handler == NULL) return;

    uart_debug_buff = rt_alloc(RT_ALLOC_PERIPH, UART_DEBUG_BUFF_SIZE);
    if (uart_debug_buff == NULL) return;

    printf("Debug Conf \n" );

    rt_time_wait_us (100);
    DEBUG_STR("Start Debug \n\r");
    DEBUG_STR_K("Press a key to continue... \n\r");
}