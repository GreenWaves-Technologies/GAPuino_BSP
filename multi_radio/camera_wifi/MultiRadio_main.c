
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
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
/* Includes ------------------------------------------------------------------*/
#include "rt/rt_api.h"

/* USER CODE BEGIN Includes */
#include "MultiRadio_Library.h"
#include "main.h"
#include "Uart_Debug.h"
#include "Camera_Library.h"

#define TIMEOUT_OP		      (1000)
#define TMEOUT_CON		      (1000)
#define TIME_ELAPSED_MS()   ((uint32_t)(rt_time_get_us () / 1000))
#define DELAY_MS(ms)        rt_time_wait_us (ms * 1000)

#define ENABLE_BLT    (0)

/* Spi clock in Hz */
#define SPI_BAUDRATE  (10000000)

#define UDP_PORT 		  (50007)
//#define UDP_SERVER		"192.168.1.131"
#define UDP_SERVER		"192.168.16.100"
//#define UDP_SERVER		"137.204.213.238"
//#define UDP_SERVER		"192.168.1.101"

#define UDP_SCK 		  (1)

//#define WIFI_SSID     "micrel2.4"
//#define WIFI_PASS     "nonlasopiu"

#define WIFI_SSID     "BL-MP01"
#define WIFI_PASS     "dysp4444"

/*---------- Uncomment to enable Biosignals acquisition with SPI3 ------------*/
//#define BIOSIGNALS_ACQ



/* Private variables ---------------------------------------------------------*/

uint8_t *tx_buff;
uint8_t *rx_buff;
uint8_t ackok_flag = FALSE;
uint8_t ackno_flag = FALSE;
uint8_t wtnup_flag = FALSE;
uint8_t bleup_flag = FALSE;
uint8_t tx_flag = FALSE;
uint8_t half_buffer=0;
typedef enum{
	APPWIFI_RESET,
	APPWIFI_POWERCONFIG,
	APPWIFI_SSID,
	APPWIFI_SCK,
	APPWFI_TXRX,
	APPWFI_TXDT,
  APPBLE_RESET,
  APPBLE_NET_UP,
  APPBLE_NET_DW,
}AppWifi_e;

enum {
	TRANSFER_WAIT,
	TRANSFER_COMPLETE,
	TRANSFER_ERROR
};

static AppWifi_e stato = APPWIFI_RESET;
static uint32_t wait_timer;

uint32_t wTransferState = TRANSFER_WAIT;

uint8_t tx_esempio[1400]={3};
uint8_t tx_esempio_2[1400]={2};
uint16_t tx_esempio_size = sizeof(tx_esempio);
uint8_t rx_complete =0;
uint8_t rx_start =0;
uint8_t ble_esempio[]="Test BLE MultiRadio Interface";


uint16_t count_img = 0;
#define NUM_PKT   (320)
#define SIZE_PKT  (240)

/* spi handlers */
rt_spim_t *spim;
rt_event_t* spi_evnt;

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
void _Error_Handler(char *file, int line);
void Start_Timer(uint32_t timeout);
uint8_t Is_Timer_Elapsed (void);
void HAL_GPIO_EXTI_Callback(void *arg);
static void MX_GPIO_Init( void );
static void MX_DMA_Init( void );
static void MX_SPI_Init(void);
/* Private function prototypes -----------------------------------------------*/



/**
  * @brief  The application entry point.
  *
  * @retval None
  */
int main(void)
{

	uint16_t tx_size;
	uint32_t iphex;
  uint8_t *img;
  uint16_t i;

  /* MCU Configuration----------------------------------------------------------*/

  /* Configure the system clock */
  SystemClock_Config();

  memset(tx_esempio,3,tx_esempio_size);

  /* Initialize all configured peripherals */
  Uart_Debug_Init();
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_SPI_Init();

  if (rt_event_alloc(NULL, 3)) return -1;
  printf("GAP  is configured \n" );

  Init_Camera();


  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (TRUE)
  {
    //rt_event_yield  ( NULL );
	  switch (stato){
	  case APPWIFI_RESET:

		  tx_size = Gen_WPWRC(tx_buff, APPWIFI_LOWPOWERMODE_HTCO);
		  SPI_ExtInterface ( tx_buff, rx_buff, tx_size);
		  Start_Timer(TIMEOUT_OP);

      DEBUG_STR("Command: WPWRC  \n\r" );

#if ENABLE_BLT
      stato = APPBLE_RESET;
#else
      stato = APPWIFI_POWERCONFIG;
#endif
		  break;
	  case APPWIFI_POWERCONFIG:
		  if(ackok_flag){
		    ackok_flag = FALSE;

			  tx_size = Gen_WSSID(tx_buff,WIFI_SSID, WIFI_PASS, "MRadio", TRUE,
					  0, 0, 0, 0, 0,SSID_SECURITY_WPA2);

			  SPI_ExtInterface ( tx_buff, rx_buff, tx_size);

        DEBUG_STR("Command: WSSID  \n\r" );

			  stato = APPWIFI_SSID;
		  }
		  if (ackno_flag){
        ackno_flag = FALSE;
			  //_Error_Handler(__FILE__, __LINE__);
		  }
		  if (Is_Timer_Elapsed ()){
			  stato = APPWIFI_RESET;
		  }
		  break;
	  case APPWIFI_SSID:
		  if((ackok_flag==TRUE) && (wtnup_flag==TRUE)){
			  ackok_flag = FALSE;
			  iphex = ip_to_int (UDP_SERVER);
			  tx_size = Gen_WSOCK(tx_buff, iphex, UDP_PORT, UDP_SCK, SCK_UDP, TRUE);
			  SPI_ExtInterface ( tx_buff, rx_buff, tx_size);

			  stato = APPWIFI_SCK;
		  }
		  if (ackno_flag){
        DEBUG_STR("Error Handler\n\r" );
			  //_Error_Handler(__FILE__, __LINE__);
		  }
		  break;
	  case APPWIFI_SCK:
		  //stato = APPWFI_TXRX;
		  if(ackok_flag){
			  ackok_flag = FALSE;

        DEBUG_STR_K("Press a key to start TX... \n\r");

        Start_Camera();

			  stato = APPWFI_TXRX;
		  }
		  if (ackno_flag){
        DEBUG_STR("Error Handler\n\r" );
			  //_Error_Handler(__FILE__, __LINE__);
		  }
		  break;
	  case APPWFI_TXRX:
		  if(wtnup_flag){
			  //DELAY_MS(1000); 
			  tx_flag=TRUE;

        DEBUG_STR_V1("Command: WTXCM  \n\r" );

			  //tx_size = Gen_WTXCM(tx_buff, UDP_SCK, tx_esempio_size, tx_esempio);
			  //SPI_ExtInterface ( tx_buff, rx_buff, tx_size);

        /* esempio immagine */
        /*memcpy(tx_esempio,(uint8_t *)(&count_img),sizeof(count_img));
        tx_esempio[2] = 1;

        tx_size = Gen_WTXCM(tx_buff, UDP_SCK, SIZE_PKT + 3, tx_esempio);
        SPI_ExtInterface ( tx_buff, rx_buff, tx_size);
        count_img++;
        if (count_img >= NUM_PKT){
          count_img = 0;
        }

        rt_time_wait_us (100); */

        img = (uint8_t *)Get_Camera_Img();
        count_img = 0;
        for (i=0;i<WIDTH;i++){
          // esempio immagine 
          memcpy(tx_esempio,(uint8_t *)(&count_img),sizeof(count_img));
          tx_esempio[2] = 1;

          memcpy(&tx_esempio[3],(img + (i*HEIGHT)) ,HEIGHT);

          tx_size = Gen_WTXCM(tx_buff, UDP_SCK, HEIGHT + 3, tx_esempio);
          SPI_ExtInterface ( tx_buff, rx_buff, tx_size);
          count_img++;

          rt_time_wait_us (100); 
        }

			  ackok_flag = FALSE;
			  Start_Timer(TMEOUT_CON);

			  stato = APPWFI_TXDT;
		  }
		  break;
	  case APPWFI_TXDT:
		  stato = APPWFI_TXRX;
		  if(ackok_flag){

			  //DELAY_MS(1);

			  stato = APPWFI_TXRX;
		  }
		  if (ackno_flag){
 			  ackno_flag = FALSE;

			  DELAY_MS(1);

			  stato = APPWFI_TXRX;
		  }
		  if (Is_Timer_Elapsed ()){

			  stato = APPWFI_TXRX;

		  }
		  break;
    case APPBLE_RESET   :
      if(ackok_flag){
        ackok_flag = FALSE;

        tx_size = Gen_BPWRC( tx_buff, TRUE);
        SPI_ExtInterface ( tx_buff, rx_buff, tx_size);

        stato = APPBLE_NET_DW;
      }
      if (ackno_flag){
        DELAY_MS(TMEOUT_CON);
        stato = APPWIFI_RESET;
      }
      if (Is_Timer_Elapsed ()){
        stato = APPWIFI_RESET;
      }
      break;
    case APPBLE_NET_UP  :
      /* network down */
      if (!bleup_flag){
        stato = APPBLE_NET_DW;
      }
      tx_size = Gen_BTXCM( tx_buff, sizeof(ble_esempio), ble_esempio);
      SPI_ExtInterface ( tx_buff, rx_buff, tx_size);
      DELAY_MS(TMEOUT_CON);
      break;
    case APPBLE_NET_DW  :
      /* network up */
      if (bleup_flag){
        stato = APPBLE_NET_UP;
      }
      break;
	  }

	  /*wait asnwer*/
	  if(Is_DataReady()){
		  /* receive new data and execute callback */
      DEBUG_STR_V2("Event: DataReadyPINClbk  \n\r" );

		  SPI_ExtInterface ( tx_buff, rx_buff, FALSE);


	  }


  }
  /* USER CODE END 3 */

}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{


}

static void MX_GPIO_Init( void ){

  /* Allocate free event */
  if (rt_event_alloc(NULL, 1)) return;

  //GPIO 19 exposed on PAD 33
  hal_apb_soc_pad_set_function(SPI_BUSY_PAD, 1);  
  // GPIO initialization
  rt_gpio_init(0, SPI_BUSY_PIN);
  // Configure GPIO as an input
  rt_gpio_set_dir(0, 1<<SPI_BUSY_PIN, RT_GPIO_IS_IN );

  //GPIO 5 exposed on PAD 17
  hal_apb_soc_pad_set_function(SPI2_DATAREADY_PAD, 1);  
  // GPIO initialization
  rt_gpio_init(0, SPI2_DATAREADY_PIN);
  // Configure GPIO as an input
  rt_gpio_set_dir(0, 1<<SPI2_DATAREADY_PIN, RT_GPIO_IS_IN );
  // Configure the INT edge
  rt_gpio_set_sensitivity (0, SPI2_DATAREADY_PIN, RT_GPIO_SENSITIVITY_RISE);
  // Set the event for the GPIO.
  // Note that we use an IRQ event instead of a normal one so that
  // the callback is called directly from the IRQ handler.
  rt_gpio_set_event(0, SPI2_DATAREADY_PIN, rt_event_irq_get(HAL_GPIO_EXTI_Callback, NULL));

  DEBUG_STR("Configuration of GPIO for WiFi done!\n" );

}

static void MX_DMA_Init( void ){

}


static void MX_SPI_Init(void){
  /* First configure the SPI device */
  rt_spim_conf_t spim_conf;
  /* Get default configuration */
  rt_spim_conf_init(&spim_conf);
  /* Set baudrate. Can actually be lower than
   that depending on the best divider found */
  spim_conf.max_baudrate = SPI_BAUDRATE;
  /* SPI interface identifier as the Pulp chip can have
   several interfaces */
  spim_conf.id = 1; 
  // Chip select
  spim_conf.cs = 0;
  spim_conf.wordsize = RT_SPIM_WORDSIZE_8 ;

  /* Then open the device */
  spim = rt_spim_open(NULL, &spim_conf, NULL);
  if (spim == NULL) return;

  rx_buff = rt_alloc(RT_ALLOC_PERIPH, SPI_BUFF_DIM);
  if (rx_buff == NULL) return;
  tx_buff = rt_alloc(RT_ALLOC_PERIPH, SPI_BUFF_DIM);
  if (tx_buff == NULL) return;

  /* Init the buffer */  
  for (int i=0; i<10; i++)
  {
    tx_buff[i] = i;
  }
  for (int j=0; j<10; j++)
  {
    rx_buff[j] = j;
  }

  DEBUG_STR("Configuration of SPI done!!!\n\r" );   
  DEBUG_STR("SPI at %d Mbps \n\r" , SPI_BAUDRATE);
}


/**
  * @brief  Start wait timer for WiFi answer 
  *
  * @param timeout: number of ms
  * @retval None
  */
void Start_Timer(uint32_t timeout){
  wait_timer = TIME_ELAPSED_MS() + timeout;
}

/**
  * @brief  Check wait timer for WiFi answer 
  *
  * @param None
  * @retval TRUE if elapsed
  */
uint8_t Is_Timer_Elapsed (void){
  if(wait_timer < TIME_ELAPSED_MS()){
    return TRUE;
  }else{
    return FALSE;
  }
}

/**
  * @brief  EXTI line detection callback.
  * @param  GPIO_Pin: Specifies the port pin connected to corresponding EXTI line.
  * @retval None
  */
void HAL_GPIO_EXTI_Callback(void *arg)
{ 

  DataReadyPINClbk();

/*	if (GPIO_Pin == SPI2_DATAREADY_PIN){
		DataReadyPINClbk();
    DEBUG_STR("GPIO_EXT  \n\r" );
	}
	if (GPIO_Pin == SPI_READY_PIN){
		rx_start=1;
	}*/
}


/**
  * @brief  This function is executed in case of error occurrence.
  * @param  file: The file name as string.
  * @param  line: The line in file as a number.
  * @retval None
  */
void _Error_Handler(char *file, int line)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  while(1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}



/**
  * @}
  */

/**
  * @}
  */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
