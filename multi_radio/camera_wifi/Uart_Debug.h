/**
  ******************************************************************************
  * @file           : Uart_Debug.h
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

#ifndef UART_DEBUG_H_
#define UART_DEBUG_H_

/* 1: Enable VERBOSE LOG, 2: Disable VERBOSE LOG */
#define VERBOSE_LEV1              1
#define VERBOSE_LEV2              0
#define VERBOSE_KEY1              1



/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/


extern uint8_t *uart_debug_buff;
extern int uart_debug_str_size;
extern rt_uart_t *uart_handler;
extern uint8_t uart_debug_rx_buff;

extern int sprintf(char *str, const char *format, ...);

void Uart_Debug_Init ( void );

#define DEBUG_STR(f_, ...)        do{uart_debug_str_size = sprintf((char *)uart_debug_buff, (f_), ##__VA_ARGS__ );if(uart_debug_str_size>0){rt_uart_write(uart_handler, uart_debug_buff, (size_t)uart_debug_str_size, NULL);}}while(0)

#if VERBOSE_LEV1
#define DEBUG_STR_V1(f_, ...)       do{uart_debug_str_size = sprintf((char *)uart_debug_buff, (f_), ##__VA_ARGS__ );if(uart_debug_str_size>0){rt_uart_write(uart_handler, uart_debug_buff, (size_t)uart_debug_str_size, NULL);}}while(0)
#else
#define DEBUG_STR_V1(f_, ...)       ((void)0)
#endif

#if VERBOSE_LEV2
#define DEBUG_STR_V2(f_, ...)       do{uart_debug_str_size = sprintf((char *)uart_debug_buff, (f_), ##__VA_ARGS__ );if(uart_debug_str_size>0){rt_uart_write(uart_handler, uart_debug_buff, (size_t)uart_debug_str_size, NULL);}}while(0)
#else
#define DEBUG_STR_V2(f_, ...)       ((void)0)
#endif

#if VERBOSE_KEY1
#define DEBUG_STR_K(f_, ...)       do{uart_debug_str_size = sprintf((char *)uart_debug_buff, (f_), ##__VA_ARGS__ );if(uart_debug_str_size>0){rt_uart_write(uart_handler, uart_debug_buff, (size_t)uart_debug_str_size, NULL);}rt_uart_read(uart_handler, &uart_debug_rx_buff, 1, NULL);}while(0)
#else
#define DEBUG_STR_K(f_, ...)       ((void)0)
#endif


/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/

#endif