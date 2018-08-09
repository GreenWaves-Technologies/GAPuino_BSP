/* 
 * Authors: Manuele Rusci (manuele.rusci@unibo.it)
 */

/*
 * This example shows how to capture an image from the camera himax and 
 * and displying it to the ILI9341 lcd (spi interface)
 */


#include "rt/rt_api.h"

#include "lcd.h"

// This strange resolution comes from the himax camera
#define WIDTH     324
#define HEIGHT    244


// The following structure is used to describe an image
typedef struct buffer_s buffer_t;

typedef struct buffer_s {
  void *image;
  buffer_t *next;
} buffer_t;


// Camera descriptor
static rt_camera_t *camera;




int main()
{
  printf("Entering main controller\n");

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
  spim_conf.max_baudrate = 10000000;
  // SPI interface identifier as the Pulp chip can have
  // several interfaces
  spim_conf.id = 1; 
  // Chip select
  spim_conf.cs = 0;
  spim_conf.wordsize = RT_SPIM_WORDSIZE_8 ;
  printf("Configuration of SPI for LCD done!!!\n" );


  // Then open the device
  rt_spim_t *spim = rt_spim_open(NULL, &spim_conf, NULL);
  if (spim == NULL) return -1;


  //init SPI 
  lcd_init(spim);
  printf("LCD intitilized!!!\n" );


  // We'll need one event per SPI and one for camera!!
  if (rt_event_alloc(NULL, 3)) return -1;


  //fill screen! - Testing!
  lcd_fillScreen(spim, ILI9341_ORANGE);
  lcd_fillScreen(spim, ILI9341_PURPLE);

  /*******************************************/


  //camera acquisition
  printf("Start Camera acquisition!!!");

  // Buffer structure is manipulated by the FC
  buffer_t *buffer = rt_alloc(RT_ALLOC_FC_DATA, sizeof(buffer_t));
  if (buffer == NULL) return -1;

  // While buffer image is manipulated by the periph DMA
  buffer->image = rt_alloc(RT_ALLOC_PERIPH, WIDTH*HEIGHT);
  if (buffer->image == NULL) return -1;

  // Open the camera
  rt_cam_conf_t cam_conf;
  rt_camera_conf_init(&cam_conf);
  camera = rt_camera_open("camera", &cam_conf, 0);
  if (camera == NULL) return -1;
  // Start it
  rt_cam_control(camera, CMD_START, 0);
    // acquire
  rt_event_t* cam_evnt ;
  char * t = (char * )buffer->image;

  while(1){
      cam_evnt = rt_event_get_blocking   (  NULL );   
      rt_camera_capture (camera, buffer->image, WIDTH*HEIGHT, cam_evnt );

      rt_event_wait(cam_evnt) ;
      rt_time_wait_us(10);  


      lcd_printImage(spim, t, WIDTH*HEIGHT);
  }




  //close drivers
  rt_camera_close(camera, 0);
  rt_spim_close(spim, NULL);


  return 0;

}
