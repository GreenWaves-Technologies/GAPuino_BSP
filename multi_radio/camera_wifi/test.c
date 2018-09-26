/* 
 * Authors: Germain Haugou, ETH (germain.haugou@iis.ee.ethz.ch)
 */

/*
 * This example shows how to capture an image from the camera and flush it
 * to the external bridge framebuffer.
 */


#include "rt/rt_api.h"

#define TX_LEN                  (5)
#define BYTE_BIT                (8)
#define CS_MODE                 RT_SPIM_CS_AUTO
#define LCD_DC_GPIO             19

#define TRUE                    (1)
#define FALSE                   (0)

#define BUFFER_SIZE             20

//#define EN_WAIT_EVT            
#define TRANSFER 

#define SPI_RECEIVE(rx,len,cs)    do{rt_spim_receive(spim,rx,(len) * 8,cs,NULL);}while(0)

/* send bytes */
static uint8_t txbuff[TX_LEN] = "HELLO";
static uint8_t rxbuff[TX_LEN];

rt_spim_t *spim;

int main()
{
  printf("Entering main controller\n");

  // Allocate a buffer from the periph memory, we'll use
  // it to store the SPI data which will be received
  char *rx_buffer = rt_alloc(RT_ALLOC_PERIPH, TX_LEN);
  if (rx_buffer == NULL) return -1;

// Allocate a buffer from the periph memory, we'll use
  // it to store the SPI data which will be received
  char *tx_buffer = rt_alloc(RT_ALLOC_PERIPH, BUFFER_SIZE);
  if (tx_buffer == NULL) return -1;

  printf("This is the demo sw!!\n");


  /* New code for the LCD screen */

  //GPIO 19 exposed on PAD 33
  hal_apb_soc_pad_set_function(33, 1);  
  // GPIO initialization
  rt_gpio_init(0, LCD_DC_GPIO);
  // Configure GPIO as an outpout
  rt_gpio_set_dir(0, 1<<LCD_DC_GPIO, RT_GPIO_IS_OUT);

  printf("Configuration of GPIO for LCD done!\n" );



  // First configure the SPI device
  rt_spim_conf_t spim_conf;
  // Get default configuration
  rt_spim_conf_init(&spim_conf);
  // Set maximum baudrate. Can actually be lower than
  // that depending on the best divider found
  spim_conf.max_baudrate = 1000000;
  // SPI interface identifier as the Pulp chip can have
  // several interfaces
  spim_conf.id = 1; 
  // Chip select
  spim_conf.cs = 0;
  //spim_conf.wordsize = RT_SPIM_WORDSIZE_8 ;


  for (int i=0; i<BUFFER_SIZE; i++)
  {
    tx_buffer[i] = i;
  }

  // Then open the device
  spim = rt_spim_open(NULL, &spim_conf, NULL);
  if (spim == NULL) return -1;

  // Finally send the buffer to SPI.
  // This is using basic synchronous mode.
  rt_spim_send(
    spim, tx_buffer, BUFFER_SIZE*8, RT_SPIM_CS_AUTO, NULL
  );

  //rt_event_t* spi_evnt = rt_event_get_blocking   (  NULL );

  printf("Configuration of SPI done!!!\n" );   
  rt_gpio_set_pin_value (0, LCD_DC_GPIO, 1);
  printf("Send Hello over SPI at 5 Mbps \n" );

  while(TRUE){

#ifdef TRANSFER

    rt_gpio_set_pin_value (0, LCD_DC_GPIO, FALSE);
    rt_spim_transfer  (spim, tx_buffer, rx_buffer, 2 * BYTE_BIT, RT_SPIM_CS_KEEP, NULL);
    rt_gpio_set_pin_value (0, LCD_DC_GPIO, TRUE);
    rt_spim_transfer  (spim, tx_buffer, rx_buffer, TX_LEN * BYTE_BIT, RT_SPIM_CS_AUTO, NULL);
    rt_gpio_set_pin_value (0, LCD_DC_GPIO, FALSE);

 #else

    #ifdef EN_WAIT_EVT
    rt_gpio_set_pin_value (0, LCD_DC_GPIO, FALSE);
    rt_spim_send(spim, txbuff, TX_LEN * BYTE_BIT,  RT_SPIM_CS_AUTO  , spi_evnt );
    rt_event_wait(spi_evnt) ;
    rt_gpio_set_pin_value (0, LCD_DC_GPIO, TRUE);
    rt_spim_send(spim, txbuff, TX_LEN * BYTE_BIT,  RT_SPIM_CS_AUTO  , spi_evnt );
    rt_event_wait(spi_evnt) ;
    rt_gpio_set_pin_value (0, LCD_DC_GPIO, FALSE);
    rt_spim_send(spim, txbuff, TX_LEN * BYTE_BIT,  RT_SPIM_CS_AUTO  , spi_evnt );
    rt_event_wait(spi_evnt) ;
    rt_gpio_set_pin_value (0, LCD_DC_GPIO, TRUE);
    printf("Send WAIT EVT \n" );
    #else
    rt_spim_receive(spim,txbuff,3 * 8,RT_SPIM_CS_KEEP,NULL);
    rt_time_wait_us(10); 
    rt_spim_receive(spim,txbuff,1 * 8,RT_SPIM_CS_AUTO,NULL);
/*    printf("Send Done \n" );
    rt_gpio_set_pin_value (0, LCD_DC_GPIO, FALSE);
    rt_spim_send(spim, tx_buffer, TX_LEN * BYTE_BIT,  RT_SPIM_CS_AUTO  , NULL );
    printf("Send Done1 \n" );
    rt_gpio_set_pin_value (0, LCD_DC_GPIO, TRUE);
    rt_spim_send(spim, tx_buffer, TX_LEN * BYTE_BIT,  RT_SPIM_CS_AUTO  , NULL );
    rt_gpio_set_pin_value (0, LCD_DC_GPIO, FALSE);
    printf("Send Done2 \n" );
    rt_spim_send(spim, tx_buffer, TX_LEN * BYTE_BIT,  RT_SPIM_CS_AUTO  , NULL );
    rt_gpio_set_pin_value (0, LCD_DC_GPIO, TRUE);
    printf("Send Done \n" );*/
    #endif
#endif
    rt_time_wait_us(1000); 
    
}


  return 0;
}
