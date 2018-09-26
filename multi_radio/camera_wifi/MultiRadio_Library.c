/*
 * MultiRadio_Library.c
 *
 *  Created on: 13 Apr 2018
 *      Author: TP
 */


#include "io/string.h"
#include "io/stdio.h"

#include "rt/rt_api.h"
#include "rt/rt_spim.h"
#include "main.h"

#include "MultiRadio_Library.h"
#include "Uart_Debug.h"

/******************************************************
 *                      Macros
 ******************************************************/

#define SET_TX_SIZE(x,size)			do{x[SPI_LEN_POS]=(uint8_t)((size >> 8) & 0xFF);    \
										x[SPI_LEN_POS+1]=(uint8_t)(size & 0xFF);		\
									}while(0)
#define GET_RX_SIZE(x)				((((uint16_t)x[SPI_LEN_POS]) << 8) | ((uint16_t)x[SPI_LEN_POS+1]))
#define QUEUE_IP_BYTES(buf,pos,ip)	do{													\
									buf[pos]   = (uint8_t)((ip >> 24) & 0xFF);			\
									buf[pos+1] = (uint8_t)((ip >> 16) & 0xFF);			\
									buf[pos+2] = (uint8_t)((ip >> 8 ) & 0xFF);			\
									buf[pos+3] = (uint8_t)((ip      ) & 0xFF);			\
									}while(0)
#define QUEUE_PORT_BYTES(buf,pos,ip)	do{												\
									buf[pos  ] = (uint8_t)((ip >> 8 ) & 0xFF);			\
									buf[pos+1] = (uint8_t)((ip      ) & 0xFF);			\
									}while(0)
#define QUEUE_DATA_SIZE(buf,pos,ip)	do{													\
									buf[pos  ] = 0;										\
									buf[pos+1] = 0;										\
									buf[pos+2] = (uint8_t)((ip >> 8 ) & 0xFF);			\
									buf[pos+3] = (uint8_t)((ip      ) & 0xFF);			\
									}while(0)

/* Must be enabled if the SPI_TRANSFER(tx,rx,len) supports the full-duplex communication */
#define SPI_FULL_DUPLEX				(1)

#define SPI_SELECT()				((void)0)
#define SPI_UNSELECT()				((void)0)
#define IS_SLAVE_SPI_BUSY()			(TRUE == rt_gpio_get_pin_value(0,SPI_BUSY_PIN))
#define IS_MASTER_SPI_BUSY()		FALSE
#define IS_SLAVE_DATA_READY()		(rt_gpio_get_pin_value	(0,SPI2_DATAREADY_PIN) == TRUE)
/* Transfer SPI function */
#define SPI_TRANSFER(tx,rx,len,cs)	do{rt_spim_transfer(spim,tx,rx,(len) * 8,cs,NULL);}while(0)
#define SPI_RECEIVE(rx,len,cs)		do{rt_spim_receive(spim,rx,(len) * 8,cs,NULL);}while(0)
#define SPI_TRANSMIT(tx,len,cs)		do{rt_spim_send(spim,tx,(len) * 8,cs,NULL);}while(0)

/* For RTOS */
#define SPI_WAIT_SLEEP()			((void)0)//rt_time_wait_us (100)
/* Error management */
#define SPI_EXE_ERROR()				do{_Error_Handler(__FILE__, __LINE__);}while(0)

/* Function to get the error in SPI driver */
#define SPI_GET_ERR()				((void)0)

/* High speed memcopy */
#define SPI_HS_M2M(src,dest,len)	do{memcpy(dest,src,len);}while(0)

#define SPI_TIMEOUT					(10000)


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
extern size_t strlen(const char *str);
extern int memcmp(const void *m1, const void *m2, size_t n);
extern void rt_spim_transfer(rt_spim_t *handle, void *tx_data, void *rx_data, size_t len, rt_spim_cs_e cs_mode, rt_event_t *event);
/******************************************************
 *               Variable Definitions
 ******************************************************/

static uint8_t	rx_dataready = FALSE;
/* spi handlers */
extern rt_spim_t *spim;
extern rt_event_t* spi_evnt;

/******************************************************
 *               Function Definitions
 ******************************************************/



const Api_callback_t Api_callback_Array[API_ARRAY_SIZE(ENUM_API_SIZE)] = {
		CMD_TABLE(EXPAND_AS_API_INIT_STR)
		{NULL,"NULL",FALSE}
};

const uint8_t API_CMD_STR_SIZE = API_ARRAY_SIZE(ENUM_API_SIZE);

CMD_TABLE(EXPAND_AS_API_WEAK_FUN)


/* INSERT HERE -----------------------------------------------------------------*/
/* INSERT HERE -----------------------------------------------------------------*/
/* INSERT HERE -----------------------------------------------------------------*/
/* INSERT HERE -----------------------------------------------------------------*/
/* INSERT HERE -----------------------------------------------------------------*/
/* INSERT HERE -----------------------------------------------------------------*/

#if SPI_FULL_DUPLEX

/**
  * @brief  Full Duplex Transfer Data
  * @param  tx: pointer to a tx buffer, rx: pointer to rx buffer,
  * tx_size: tx payload lenght (command and data)
  * @retval rx_size: rx payload received (command and data)
  */
uint16_t SPI_ExtInterface ( uint8_t* tx , uint8_t* rx, uint16_t tx_size ){
	uint16_t rx_data_size = FALSE;
	uint16_t tx_data_size = FALSE;
	uint8_t* rx_p = rx;

	/* parameter not correct */
	if(tx_size > (PACKET_MAX_SIZE_WIFIAPP + API_CMD_LEN)){
		return rx_data_size;
	}

	/* reset TX len */
	if(tx_size == FALSE){
		memset(tx,FALSE,SPI_PAYLOAD_POS);
	}

	/* wait SPI ready */
	while(IS_MASTER_SPI_BUSY()){
		SPI_WAIT_SLEEP();
	}

	/* Start SPI */
	while(IS_SLAVE_SPI_BUSY()){
		SPI_WAIT_SLEEP();
	}

	SPI_SELECT();	

	DEBUG_STR_V2("SP1\n\r" ); 

	if((rx_dataready == TRUE) || IS_SLAVE_DATA_READY()){

		rx_dataready = FALSE;

		/* Get the RX length */
		SPI_TRANSFER(tx, rx, PACKET_MAX_SIZE_WIFIAPP - 2, RT_SPIM_CS_AUTO); 
		//SPI_TRANSFER(tx, rx, SPI_PAYLOAD_POS + 2, RT_SPIM_CS_KEEP ); 
		/* wait SPI ready */
		rt_time_wait_us (200);
		while(IS_MASTER_SPI_BUSY()){
			SPI_WAIT_SLEEP();
		}

		DEBUG_STR_V2("SPRXRAW: %d_%d_%d\n\r", 
			rx[0], rx[1], rx[2] );

		/* check RX length */
		rx++;
		rx_data_size = GET_RX_SIZE(rx);
		DEBUG_STR_V2("DATASIZE: %d \n\r", rx_data_size);

		if (rx_data_size >= PACKET_MAX_SIZE_WIFIAPP){
			rx_data_size = FALSE;
		}
		/* transfer payload */
		rx = rx + SPI_PAYLOAD_POS;

		DEBUG_STR_V2("DATASIZE: %d \n\r", rx_data_size);

#if __UNUSED__

		if (rx_data_size > tx_size){
			/* SPI size must be multiple of 4 */
			rx_data_size = rx_data_size + ((sizeof(uint32_t) - (rx_data_size & 0x03)));
			SPI_TRANSFER(&tx[SPI_PAYLOAD_POS + 2], rx, rx_data_size, RT_SPIM_CS_AUTO);
			/* wait SPI ready */
			while(IS_MASTER_SPI_BUSY()){
				SPI_WAIT_SLEEP();
			}
		}else if (tx_size > FALSE){
			tx_size = tx_size + ((sizeof(uint32_t) - (tx_size & 0x03)));
			SPI_TRANSFER(&tx[SPI_PAYLOAD_POS + 2], rx, tx_size, RT_SPIM_CS_AUTO);
			/* wait SPI ready */
			while(IS_MASTER_SPI_BUSY()){
				SPI_WAIT_SLEEP();
			}
		}else{
			/* fake transfer to set the CS high */
			SPI_TRANSFER(&tx[SPI_PAYLOAD_POS + 2], rx, SPI_PAYLOAD_POS + 2, RT_SPIM_CS_AUTO);
			/* wait SPI ready */
			while(IS_MASTER_SPI_BUSY()){
				SPI_WAIT_SLEEP();
			}
		}

#endif

		DEBUG_STR_V2("SPRXRAW: %d_%d_%d_%c_%c_%c_%c_%c\n\r", 
			rx_p[0], rx_p[1], rx_p[2], rx_p[3], rx_p[4], rx_p[5], rx_p[6], rx_p[7] );

		DEBUG_STR_V2("SPRXRAW: %c_%c_%c_%c_%c\n\r", 
			rx[0], rx[1], rx[2], rx[3], rx[4] );


	}else{
		tx_data_size = tx_size + SPI_PAYLOAD_POS;
		tx_data_size = tx_data_size + ((sizeof(uint32_t) - (tx_data_size & 0x03)));
		/* only TX */
		SPI_TRANSFER(tx , rx, tx_data_size , RT_SPIM_CS_AUTO);
		//SPI_TRANSMIT(tx,tx_data_size,RT_SPIM_CS_AUTO);	
		/* wait SPI ready */
		rt_time_wait_us (200);
		while(IS_MASTER_SPI_BUSY()){
			SPI_WAIT_SLEEP();
		}
	}

	SPI_UNSELECT();

	if (rx_data_size > FALSE){
		/* execute command callback */
		ExecuteCommandClbk( rx, rx_data_size);
	}

	DEBUG_STR_V2("SP2\n\r" );

	return rx_data_size;

}

#else

/**
  * @brief  Full Duplex Transfer Data
  * @param  tx: pointer to a tx buffer, rx: pointer to rx buffer,
  * tx_size: tx payload lenght (command and data)
  * @retval rx_size: rx payload received (command and data)
  */
uint16_t SPI_ExtInterface ( uint8_t* tx , uint8_t* rx, uint16_t tx_size){
	uint16_t rx_data_size = FALSE;
	uint8_t* rx_p = rx;

	/* parameter not correct */
	if(tx_size > (PACKET_MAX_SIZE_WIFIAPP + API_CMD_LEN)){
		return rx_data_size;
	}
	/* reset TX len */
	if(tx_size == FALSE){
		memset(tx,FALSE,SPI_PAYLOAD_POS);
	}

	/* HARDWARE DEPENDENT */

	/* END HARDWARE DEPENDENT */

	/* wait SPI ready */
	while(IS_MASTER_SPI_BUSY()){
		SPI_WAIT_SLEEP();
	}

	/* Start SPI */
	while(IS_SLAVE_SPI_BUSY()){
		SPI_WAIT_SLEEP();
	}

	if((rx_dataready == TRUE) || IS_SLAVE_DATA_READY()){

		DEBUG_STR_V2("SP1\n\r" );   

		do{
			rx_p = rx;

			SPI_SELECT();

			/* Get the RX length */
			SPI_RECEIVE(rx_p, /*SPI_PAYLOAD_POS + 1*/SPI_BUFF_DIM - 1, /*RT_SPIM_CS_KEEP*/RT_SPIM_CS_AUTO);
			DEBUG_STR_V2("SPRXRAW: %d %d %d %d %d \n\r", rx_p[0], rx_p[1], rx_p[2], rx_p[3], rx_p[4] ); 
			/* wait SPI ready */
			while(IS_MASTER_SPI_BUSY()){
				SPI_WAIT_SLEEP();
			}
			/* first byte always zero */
			//rx_p++;
			/* check RX length */
			rx_data_size = GET_RX_SIZE(rx_p);
			/* transfer payload */
			rx_p = rx_p + SPI_PAYLOAD_POS;

#if __UNUSED__
			if ((rx_data_size > FALSE) && (rx_data_size < SPI_BUFF_DIM)){
				DEBUG_STR_V2("SP2 - X size\n\r" ); 
				SPI_RECEIVE(rx_p, rx_data_size, RT_SPIM_CS_AUTO );
				/* wait SPI ready */
				while(IS_MASTER_SPI_BUSY()){
					SPI_WAIT_SLEEP();
				}

			}else{
				DEBUG_STR_V2("SP2 - 0 size\n\r" ); 
				/* CS high - fake RX */
				SPI_RECEIVE(rx_p, 1, RT_SPIM_CS_AUTO );
				/* wait SPI ready */
				while(IS_MASTER_SPI_BUSY()){
					SPI_WAIT_SLEEP();
				}
				rx_data_size = FALSE;
			}
#endif

			DEBUG_STR_V2("SP2\n\r" ); 

			rx_dataready = FALSE;

			SPI_UNSELECT();

			if (rx_data_size > FALSE){
				DEBUG_STR_V2("SPRX: %d \n\r", rx_data_size ); 
				DEBUG_STR_V2("SPRX: %c %c %c %c %c \n\r", rx_p[0], 
				rx_p[1], rx_p[2], rx_p[3], rx_p[4] ); 
				/* execute command callback */
				ExecuteCommandClbk( rx_p, rx_data_size);
			}

			/* Used to fix issues related to full-duplex SPI */
			SPI_WAIT_SLEEP();

			/* wait SPI ready */
			while(IS_MASTER_SPI_BUSY()){
				SPI_WAIT_SLEEP();
			}

			/* Start SPI */
			while(IS_SLAVE_SPI_BUSY()){
				SPI_WAIT_SLEEP();
			}

		}while((rx_dataready == TRUE) || IS_SLAVE_DATA_READY());

		DEBUG_STR_V2("SP3\n\r" ); 

		if(tx_size > FALSE){

			SPI_SELECT();

			SPI_TRANSMIT(tx,tx_size + SPI_PAYLOAD_POS, RT_SPIM_CS_AUTO);
			/* wait SPI ready */
			while(IS_MASTER_SPI_BUSY()){
				SPI_WAIT_SLEEP();
			}

			SPI_UNSELECT();
			// DI TEST !!
			SPI_WAIT_SLEEP();

		}

		DEBUG_STR_V2("SP4\n\r" ); 

	}else{

		SPI_SELECT();

		/* only TX */
		SPI_TRANSMIT(tx , tx_size + SPI_PAYLOAD_POS, RT_SPIM_CS_AUTO);
		/* wait SPI ready */
		while(IS_MASTER_SPI_BUSY()){
			SPI_WAIT_SLEEP();
		}

		SPI_UNSELECT();

		// DI TEST !!
		SPI_WAIT_SLEEP();

		DEBUG_STR_V2("SPT\n\r" );

	}

	return rx_data_size;

}

#endif

/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/
/* PRIVATE FUNCTIONS -----------------------------------------------------------------*/

/**
  * @brief  Decode the received command and execute associated callback
  * @param  rx: pointer to a rx buffer,
  * rx_data_size: rx payload lenght (command and data)
  * @retval None
  */
void ExecuteCommandClbk(uint8_t* rx, int16_t rx_data_size){
	int a;

	/* Search command */
    for (a = 0; a < API_CMD_STR_SIZE; a++){
        if (memcmp(Api_callback_Array[a].cmd,rx,API_CMD_LEN) == 0){
            /* received data and function call */
           	Api_callback_Array[a].Api_Callback(&rx[API_CMD_LEN]);
           	break;
        }
    }
}


/**
  * @brief  Make the WPWRC data buffer
  * @param  buff: pointer to TX buffer, pwrmode: power setting
  * @retval buffer_size
  */
uint16_t Gen_WPWRC(uint8_t* buff, AppWiFi_LowPowerMode_e pwrmode){

	SET_TX_SIZE(buff,(Api_callback_Array[ENUM_WPWRC].cmd_len + API_CMD_LEN));
	memcpy(&buff[SPI_PAYLOAD_POS],Api_callback_Array[ENUM_WPWRC].cmd,API_CMD_LEN);
	buff[SPI_PAYLOAD_POS+API_CMD_LEN + WSSID_PWR_POS] = (uint8_t)pwrmode;

	return Api_callback_Array[ENUM_WPWRC].cmd_len + API_CMD_LEN;

}


/**
  * @brief  Make the WSSID data buffer
  * @param  buff: pointer to TX buffer
  * @retval buffer_size
  */
uint16_t Gen_WSSID(uint8_t* buff, char* AppWiFiName, char* AppWiFiPassword, char* DeviceName, uint8_t DHCP,
		uint32_t IP, uint32_t subnetmask, uint32_t DefaultGateway, uint32_t DNS1, uint32_t DNS2,
		AppWiFi_SSID_security_e security){

	/* check input values */
	if ((strlen(AppWiFiName) >= WSSID_APN_LEN) || (strlen(AppWiFiPassword) >= WSSID_APP_LEN)
			|| (strlen(DeviceName) >= WSSID_DNA_LEN)){
		/* input string wrong */
		SPI_EXE_ERROR();
	}
	if (!WSSID_DHCP_ASSERT(DHCP)){
		/* dhcp command wrong */
		SPI_EXE_ERROR();
	}

	SET_TX_SIZE(buff,(Api_callback_Array[ENUM_WSSID].cmd_len + API_CMD_LEN));

	memcpy(&buff[SPI_PAYLOAD_POS],Api_callback_Array[ENUM_WSSID].cmd,API_CMD_LEN);
	memcpy(&buff[SPI_PAYLOAD_POS + API_CMD_LEN + WSSID_APN_POS],AppWiFiName,strlen(AppWiFiName)+1);
	memcpy(&buff[SPI_PAYLOAD_POS + API_CMD_LEN + WSSID_APP_POS],AppWiFiPassword,strlen(AppWiFiPassword)+1);
	memcpy(&buff[SPI_PAYLOAD_POS + API_CMD_LEN + WSSID_DNA_POS],DeviceName,strlen(DeviceName)+1);
	buff[SPI_PAYLOAD_POS + API_CMD_LEN + WSSID_DHC_POS] = DHCP;
	QUEUE_IP_BYTES(buff,SPI_PAYLOAD_POS + API_CMD_LEN + WSSID_IPM_POS,IP);
	QUEUE_IP_BYTES(buff,SPI_PAYLOAD_POS + API_CMD_LEN + WSSID_SBM_POS,subnetmask);
	QUEUE_IP_BYTES(buff,SPI_PAYLOAD_POS + API_CMD_LEN + WSSID_GAT_POS,DefaultGateway);
	QUEUE_IP_BYTES(buff,SPI_PAYLOAD_POS + API_CMD_LEN + WSSID_DN1_POS,DNS1);
	QUEUE_IP_BYTES(buff,SPI_PAYLOAD_POS + API_CMD_LEN + WSSID_DN2_POS,DNS2);
	buff[SPI_PAYLOAD_POS + API_CMD_LEN + WSSID_SEC_POS] = (uint8_t)security;

	return Api_callback_Array[ENUM_WSSID].cmd_len + API_CMD_LEN;
}

/**
  * @brief  Make the WSSIU data buffer
  * @param  buff: pointer to TX buffer
  * @retval buffer_size
  */
uint16_t Gen_WSSIU( uint8_t* buff ){

	SET_TX_SIZE(buff,(Api_callback_Array[ENUM_WSSIU].cmd_len + API_CMD_LEN));
	memcpy(&buff[SPI_PAYLOAD_POS],Api_callback_Array[ENUM_WSSIU].cmd,API_CMD_LEN);

	return Api_callback_Array[ENUM_WSSIU].cmd_len + API_CMD_LEN;
}

/**
  * @brief  Make the WSOCK data buffer
  * @param  buff: pointer to TX buffer
  * @retval buffer_size
  */
uint16_t Gen_WSOCK( uint8_t* buff, uint32_t ServerIP, uint16_t ServerPort,
		uint8_t socketNumber, Socket_flag_e Socket_flag, uint8_t conf){


	if (!WSOCK_SKN_ASSERT(socketNumber)){
		/* socketNumber command wrong */
		SPI_EXE_ERROR();
	}
	if (!WSOCK_TIP_ASSERT(Socket_flag)){
		/* Socket_flag command wrong */
		SPI_EXE_ERROR();
	}
	if (!WSOCK_CON_ASSERT(conf)){
		/* conf command wrong */
		SPI_EXE_ERROR();
	}
	SET_TX_SIZE(buff,(Api_callback_Array[ENUM_WSOCK].cmd_len + API_CMD_LEN));

	memcpy(&buff[SPI_PAYLOAD_POS],Api_callback_Array[ENUM_WSOCK].cmd,API_CMD_LEN);
	QUEUE_IP_BYTES(buff,SPI_PAYLOAD_POS + API_CMD_LEN + WSOCK_SIP_POS,ServerIP);
	QUEUE_PORT_BYTES(buff,SPI_PAYLOAD_POS + API_CMD_LEN + WSOCK_SPO_POS,ServerPort);
	buff[SPI_PAYLOAD_POS + API_CMD_LEN + WSOCK_SKN_POS] = socketNumber;
	buff[SPI_PAYLOAD_POS + API_CMD_LEN + WSOCK_TIP_POS] = (uint8_t)Socket_flag;
	buff[SPI_PAYLOAD_POS + API_CMD_LEN + WSOCK_CON_POS] = conf;

	return Api_callback_Array[ENUM_WSOCK].cmd_len + API_CMD_LEN;
}


/**
  * @brief  Make the WTXCM data buffer
  * @param  buff: pointer to TX buffer
  * @retval buffer_size
  */
uint16_t Gen_WTXCM( uint8_t* buff, uint8_t socketNumber, uint16_t datasize, uint8_t* data){

	if (!WSOCK_SKN_ASSERT(socketNumber)){
		/* socketNumber command wrong */
		SPI_EXE_ERROR();
	}
	if (!WTXCM_DTS_ASSERT(datasize)){
		/* conf command wrong */
		SPI_EXE_ERROR();
	}
	SET_TX_SIZE(buff,(Api_callback_Array[ENUM_WTXCM].cmd_len + API_CMD_LEN + datasize));

	memcpy(&buff[SPI_PAYLOAD_POS],Api_callback_Array[ENUM_WTXCM].cmd,API_CMD_LEN);
	buff[SPI_PAYLOAD_POS + API_CMD_LEN + WTXCM_SKN_POS] = socketNumber;
	QUEUE_DATA_SIZE(buff,SPI_PAYLOAD_POS + API_CMD_LEN + WTXCM_DTS_POS,datasize);

	/* Mem copy - mem 2 mem */
	SPI_HS_M2M((uint8_t *)&data[0], (uint8_t *)&buff[SPI_PAYLOAD_POS + API_CMD_LEN + WTXCM_DAT_POS], datasize);

	return Api_callback_Array[ENUM_WTXCM].cmd_len + API_CMD_LEN + datasize;
}

/**
  * @brief  Return the pointer to WTXCM data
  * @param  buff: pointer to TX buffer
  * @retval buffer_size
  */
uint16_t Gen_WTXCM_Pointer( uint8_t* buff, uint8_t socketNumber, uint16_t datasize, uint8_t** data){

	if (!WSOCK_SKN_ASSERT(socketNumber)){
		/* socketNumber command wrong */
		SPI_EXE_ERROR();
	}
	if (!WTXCM_DTS_ASSERT(datasize)){
		/* conf command wrong */
		SPI_EXE_ERROR();
	}
	SET_TX_SIZE(buff,(Api_callback_Array[ENUM_WTXCM].cmd_len + API_CMD_LEN + datasize));

	memcpy(&buff[SPI_PAYLOAD_POS],Api_callback_Array[ENUM_WTXCM].cmd,API_CMD_LEN);
	buff[SPI_PAYLOAD_POS + API_CMD_LEN + WTXCM_SKN_POS] = socketNumber;
	QUEUE_DATA_SIZE(buff,SPI_PAYLOAD_POS + API_CMD_LEN + WTXCM_DTS_POS,datasize);

	/* pointer to packet payload */
	*data = (buff + SPI_PAYLOAD_POS + API_CMD_LEN + WTXCM_DAT_POS);

	return Api_callback_Array[ENUM_WTXCM].cmd_len + API_CMD_LEN + datasize;
}

/**
  * @brief  Make the WTXDT data buffer
  * @param  buff: pointer to TX buffer
  * @retval buffer_size
  */
uint16_t Gen_WTXDT( uint8_t* buff, uint8_t* data, uint16_t datasize){

	if (!WTXCM_DTS_ASSERT(datasize)){
		/* conf command wrong */
		SPI_EXE_ERROR();
	}

	memcpy(buff,Api_callback_Array[ENUM_WTXDT].cmd,API_CMD_LEN);
	memcpy(&buff[API_CMD_LEN],data,datasize);

	return datasize + API_CMD_LEN;
}

/**
  * @brief  Return the pointer to BPWRC data
  * @param  buff: pointer to TX buffer, pwrmode: 1 Bluetooth ON, 0 Bluetooth OFF
  * @retval buffer_size
  */
uint16_t Gen_BPWRC( uint8_t* buff, uint8_t pwrmode){

	if (!BPWRC_PWR_ASSERT(pwrmode)){
		/* socketNumber command wrong */
		SPI_EXE_ERROR();
	}

	SET_TX_SIZE(buff,(Api_callback_Array[ENUM_BPWRC].cmd_len + API_CMD_LEN));

	memcpy(&buff[SPI_PAYLOAD_POS],Api_callback_Array[ENUM_BPWRC].cmd,API_CMD_LEN);
	buff[SPI_PAYLOAD_POS + API_CMD_LEN + BPWRC_PWR_POS] = pwrmode;

	return Api_callback_Array[ENUM_BPWRC].cmd_len + API_CMD_LEN;
}

/**
  * @brief  Return the pointer to BTXCM data
  * @param  buff: pointer to TX buffer, pwrmode: 1 Bluetooth ON, 0 Bluetooth OFF
  * @retval buffer_size
  */
uint16_t Gen_BTXCM( uint8_t* buff, uint8_t datasize, uint8_t* data){

	if (!BTXCM_DTS_ASSERT(datasize)){
		/* socketNumber command wrong */
		SPI_EXE_ERROR();
	}

	SET_TX_SIZE(buff,(Api_callback_Array[ENUM_BTXCM].cmd_len + API_CMD_LEN + datasize));

	memcpy(&buff[SPI_PAYLOAD_POS],Api_callback_Array[ENUM_BTXCM].cmd,API_CMD_LEN);
	buff[SPI_PAYLOAD_POS + API_CMD_LEN + BTXCM_DTS_POS] = datasize;
	/* Mem copy - mem 2 mem */
	memcpy(&buff[SPI_PAYLOAD_POS + API_CMD_LEN + BTXCM_PAY_POS],data,datasize);


	return Api_callback_Array[ENUM_BTXCM].cmd_len + API_CMD_LEN + datasize;
}


/**
  * @brief  DataReadyCallback, must be used in GPIO Interrupt callback
  * @param  None
  * @retval None
  */
void DataReadyPINClbk( void ){
	rx_dataready = TRUE;
}

/**
  * @brief  Data ready read
  * @param  None
  * @retval None
  */
uint8_t Is_DataReady( void ){
	return rx_dataready | IS_SLAVE_DATA_READY();
}




/**
  * @brief   Convert the character string in "ip" into an unsigned integer.
  * '0.0.0.0' is not a valid IP address, so this uses the value 0 to indicate an invalid IP address.
  * @param  IP string
  * @retval None
  */
uint32_t ip_to_int (const char * ip)
{
    /* The return value. */
    unsigned v = 0;
    /* The count of the number of bytes processed. */
    int i;
    /* A pointer to the next digit to process. */
    const char * start;

    start = ip;
    for (i = 0; i < 4; i++) {
        /* The digit being processed. */
        char c;
        /* The value of this byte. */
        int n = 0;
        while (1) {
            c = * start;
            start++;
            if (c >= '0' && c <= '9') {
                n *= 10;
                n += c - '0';
            }
            /* We insist on stopping at "." if we are still parsing
               the first, second, or third numbers. If we have reached
               the end of the numbers, we will allow any character. */
            else if ((i < 3 && c == '.') || i == 3) {
                break;
            }
            else {
                return FALSE;
            }
        }
        if (n >= 256) {
            return FALSE;
        }
        v *= 256;
        v += n;
    }
    return v;
}



