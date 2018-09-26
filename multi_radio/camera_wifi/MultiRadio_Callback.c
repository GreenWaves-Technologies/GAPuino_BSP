/*
 * MultiRadio_Callback.c
 *
 *  Created on: 13 Apr 2018
 *      Author: TP
 */


#include "main.h"

#include <string.h>
#include <stdio.h>

#include "MultiRadio_Library.h"
#include "Uart_Debug.h"

/******************************************************
 *                      Macros
 ******************************************************/

#define BYTE_TO_INT(HMSB, MSB , HLSB , LSB) 		(LSB)|((HLSB)<<8)|((MSB)<<16)|((MSB)<<24)

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

extern uint8_t ackok_flag;
extern uint8_t ackno_flag;
extern uint8_t wtnup_flag;
extern uint8_t bleup_flag;

/******************************************************
 *               Function Definitions
 ******************************************************/

/**
  * @brief  ACKOK Command Callback
  * @param  Data received
  * @retval None
  */
void clbk_ACKOK  (uint8_t * buff) {

  DEBUG_STR("ACKOK\n\r"); 

	ackok_flag = TRUE;

};

/**
  * @brief  ACKOK Command Callback
  * @param  Data received
  * @retval None
  */
void clbk_ACKNO  (uint8_t * buff) {

  DEBUG_STR("ACKNO\n\r"); 

	ackno_flag = TRUE;

};

/**
  * @brief  WNTUP Command Callback
  * @param  Data received
  * @retval None
  */
void clbk_WNTUP  (uint8_t * buff) {

  DEBUG_STR("WNTUP\n\r");

	wtnup_flag = TRUE;

};


/**
  * @brief  WNTDW Command Callback
  * @param  Data received
  * @retval None
  */
void clbk_WNTDW  (uint8_t * buff) {

  DEBUG_STR("WNTDW\n\r");

	wtnup_flag = FALSE;

};


/**
  * @brief  WTXOK Command Callback
  * @param  Data received
  * @retval None
  */
void clbk_WTXOK  (uint8_t * buff) {



};


/**
  * @brief  WTXNO Command Callback
  * @param  Data received
  * @retval None
  */
void clbk_WTXNO  (uint8_t * buff) {



};

/**
  * @brief  WRXCM Command Callback
  * @param  Data received
  * @retval None
  */
void clbk_WRXCM  (uint8_t * buff) {
	uint32_t len;

	/* packet len*/
	len = BYTE_TO_INT(buff[WRXCM_DTS_POS], buff[WRXCM_DTS_POS + 1] ,
			buff[WRXCM_DTS_POS + 2 ] , buff[WRXCM_DTS_POS + 3]);

	if (WTXCM_DTS_ASSERT(len)){
		//HAL_GPIO_TogglePin(LD2_GPIO_Port, LD2_Pin);
	}

  DEBUG_STR("PACKET RX - LEN : %d \n\r", (int)len); 

}

/**
  * @brief  BNTUP Command Callback
  * @param  Data received
  * @retval None
  */
void clbk_BNTUP  (uint8_t * buff) {
  bleup_flag = TRUE;
};

/**
  * @brief  BNTDW Command Callback
  * @param  Data received
  * @retval None
  */
void clbk_BNTDW  (uint8_t * buff) {
  bleup_flag = FALSE;
};

/**
  * @brief  BRXCM Command Callback
  * @param  Data received
  * @retval None
  */
void clbk_BRXCM  (uint8_t * buff) {
  uint8_t len;

  len = buff[BRXCM_DTS_POS];

  if (BRXCM_DTS_ASSERT(len)){
    DEBUG_STR("BLE PACKET RX - LEN : %d \n\r", (int)len);
  }

};
