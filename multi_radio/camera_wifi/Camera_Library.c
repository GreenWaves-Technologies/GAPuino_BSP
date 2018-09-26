/* 
 * Authors: Manuele Rusci (manuele.rusci@unibo.it)
 */

/*
 * This example shows how to capture an image from the camera himax and 
 * and displying it to the ILI9341 lcd (spi interface)
 */

/* Includes ------------------------------------------------------------------*/

#include "rt/rt_api.h"
#include "Uart_Debug.h"
#include "Camera_Library.h"
#include "MultiRadio_Library.h"
#include "rt/data/rt_data_camera.h"


/* Private variables ---------------------------------------------------------*/

// The following structure is used to describe an image
typedef struct buffer_s buffer_t;

typedef struct buffer_s {
  void *image;
  buffer_t *next;
} buffer_t;


// Camera descriptor
static rt_camera_t *camera;
// buffer structure
static buffer_t *buffer;
// acquire event 
static rt_event_t* cam_evnt;


/* Private function prototypes -----------------------------------------------*/

int Init_Camera( void )
{

  DEBUG_STR("This is the CAMERA+WIFI demo!!\n\r");

  // We'll need one event per SPI and one for camera!!
  //if (rt_event_alloc(NULL, 3)) return -1;

  //camera acquisition
  DEBUG_STR("Camera Configuration!\n\r");

  // Buffer structure is manipulated by the FC
  buffer = rt_alloc(RT_ALLOC_FC_DATA, sizeof(buffer_t));
  if (buffer == NULL) return -1;

  // While buffer image is manipulated by the periph DMA
  buffer->image = rt_alloc(RT_ALLOC_PERIPH, WIDTH*HEIGHT);
  if (buffer->image == NULL) return -1;

  // Open the camera
  rt_cam_conf_t cam_conf;
  rt_camera_conf_init(&cam_conf);
  camera = rt_camera_open("camera", &cam_conf, 0);
  if (camera == NULL) return -1;

  return 0;
}

int Start_Camera( void )
{
	DEBUG_STR("Start Camera\n\r");
	// Start it
	rt_cam_control(camera, CMD_INIT, 0);
  	rt_cam_control(camera, CMD_START, 0);

  	return 0;
    
}

int Stop_Camera( void )
{
	DEBUG_STR("Stop Camera\n\r");
	//close drivers
  	rt_camera_close(camera, 0);

  	return 0;  
}

char * Get_Camera_Img( void )
{

	DEBUG_STR_V1("Start New image\n\r");
	cam_evnt = rt_event_get_blocking   (  NULL );   
    rt_camera_capture (camera, buffer->image, WIDTH*HEIGHT, cam_evnt );

	DEBUG_STR_V1("Start New image2\n\r");
    rt_event_wait(cam_evnt) ;
    rt_time_wait_us(10);  


    char * t = (char * )buffer->image;  // image bytes = WIDTH*HEIGHT starting from pointer t

    DEBUG_STR_V1("New image\n\r");

    return t;
}

int SendWiFi_Camera(uint8_t * img, uint8_t * tx_buff, uint8_t * rx_buff){
/*	uint16_t count_img=0;
	uint16_t i;
	uint8_t tx_esempio[1400];
	uint16_t tx_size;

	for (i=0;i<WIDTH;i++){
		// esempio immagine 
        memcpy(tx_esempio,(uint8_t *)(&count_img),sizeof(count_img));
        tx_esempio[2] = 1;

        memcpy(&tx_esempio[3],(img + (i*HEIGHT)) ,HEIGHT);

        tx_size = Gen_WTXCM(tx_buff, UDP_SCK, HEIGHT + 3, tx_esempio);
        SPI_ExtInterface ( tx_buff, rx_buff, tx_size);
        count_img++;

        rt_time_wait_us (100); 
    }*/

    return 0;

}
