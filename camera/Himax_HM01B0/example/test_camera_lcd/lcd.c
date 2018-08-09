/* 
 * Authors: Manuele Rusci (manuele.rusci@unibo.it)
 */

/*
 * LCD driver. Source code file.
 * Derived from: https://github.com/adafruit/Adafruit_ILI9341
 */

#include "lcd.h"


#define CS_MODE RT_SPIM_CS_AUTO


static char *__tx_buffer;
static char *__lcd_buffer;  //FIXME: move from here!


static void lcd_writecommand(rt_spim_t *lcd_spim, char * buffer, unsigned char data_to_send) 
{
  buffer[0] = data_to_send;

  //LCD_DC low
  rt_gpio_set_pin_value(0, LCD_DC_GPIO, 0);

  //send one byte
  rt_spim_send(lcd_spim, buffer, 8,  CS_MODE , NULL );
  
  rt_time_wait_us(1);  
  
} 

static void lcd_writedata(rt_spim_t *lcd_spim, char * buffer, unsigned char nb_byte_to_send) 
{
  //LCD_DC high
  rt_gpio_set_pin_value(0, LCD_DC_GPIO, 1);
  //printf("sono qua111");
  //send one byte
  rt_spim_send(lcd_spim, buffer, nb_byte_to_send*8, CS_MODE, NULL);
  
  rt_time_wait_us(1);  

} 


void lcd_pushColor(rt_spim_t *lcd_spim,  char * buffer, unsigned char nb_byte_to_send ) //same as 
{
  rt_gpio_set_pin_value(0, LCD_DC_GPIO, 1);
  rt_spim_send(lcd_spim, buffer, nb_byte_to_send*8, CS_MODE, NULL);
  
  //rt_time_wait_us(1);  
}

void lcd_setAddrWindow(rt_spim_t *lcd_spim, unsigned short x0, unsigned short y0, unsigned short x1, unsigned short y1) {

  lcd_writecommand(lcd_spim,  __tx_buffer, ILI9341_CASET); // Column addr set
  __tx_buffer[0] = (x0 & (0xff00)) >> 8;
  __tx_buffer[1] = (x0 & (0xff));
  lcd_pushColor(lcd_spim, __tx_buffer, 2);
  __tx_buffer[0] = (x1 & (0xff00)) >> 8;
  __tx_buffer[1] = (x1 & (0xff));
  lcd_pushColor(lcd_spim,  __tx_buffer, 2);


  lcd_writecommand(lcd_spim,  __tx_buffer, ILI9341_PASET); // Row addr set
  __tx_buffer[0] = (y0 & (0xff00)) >> 8;
  __tx_buffer[1] = (y0 & (0xff));
  lcd_pushColor(lcd_spim,  __tx_buffer, 2);
  __tx_buffer[0] = (y1 & (0xff00)) >> 8;
  __tx_buffer[1] = (y1 & (0xff));
  lcd_pushColor(lcd_spim,  __tx_buffer, 2);  

  lcd_writecommand(lcd_spim,  __tx_buffer, ILI9341_RAMWR); // write to RAM
}

// filcd_ll a rectangle
void lcd_fillRect(rt_spim_t *lcd_spim, unsigned short x, unsigned short y, unsigned short w, unsigned short h, unsigned short color) 
{
  // rudimentary clipping (drawChar w/big text requires this)
  if((x >= LCD_WIDTH) || (y >= LCD_HEIGHT)) return;
  if((x + w - 1) >= LCD_WIDTH)  w = LCD_WIDTH  - x;
  if((y + h - 1) >= LCD_HEIGHT) h = LCD_HEIGHT - y;

  // printf("Is filling! \n");
  lcd_setAddrWindow(lcd_spim, x, y, x+w-1, y+h-1);

  for(int i=0;i<h*2;i++){
    lcd_pushColor(lcd_spim,  &__lcd_buffer[i*(w)], w); 
  }

}

void lcd_fillScreen(rt_spim_t *lcd_spim, unsigned short color) {
 int i,j,idx;

 idx = 0;
 for(i=0;i<LCD_HEIGHT;i++){
  for(j=0;j<LCD_WIDTH;j++){
    __lcd_buffer[idx] = (color & (0xff00)) >> 8;
    __lcd_buffer[idx+1]  = (color & (0xff));
    idx +=2;
  }
 }

 lcd_fillRect(lcd_spim, 0, 0, LCD_WIDTH,  LCD_HEIGHT, color);


}


void  lcd_printImage(rt_spim_t *lcd_spim, char* buffer, unsigned int nb_data) 
{
 int i,j,idx, pix_id;
 unsigned char value;
 unsigned short red, green, blue;
 unsigned short val16;
 int h,w;
 idx = 0;
 pix_id = 0;

 //lcd: h=320, w=240
 char * rr = (char*) buffer;
 for(h=0; h<320; h++){
  for(w=0; w<240; w++){
    value = buffer[w*324+h+1];
    blue  = (value & 0xf8) >> 3;
    red   = ((value & 0xf8) >> 3) << 11;
    green = ((value & 0xf8) >> 2) << 5;
    val16 = blue | red | green;
    __lcd_buffer[2*(h*240+w)]   = (val16 & 0xff00) >> 8;
    __lcd_buffer[2*(h*240+w)+1] = val16 & 0xff;
  }
 }

 lcd_fillRect(lcd_spim, 0, 0, LCD_WIDTH,  LCD_HEIGHT, NULL);
}

void lcd_drawPixel(rt_spim_t *lcd_spim, unsigned short x, unsigned short y, unsigned short color)
{
  if((x < 0) ||(x >= LCD_WIDTH) || (y < 0) || (y >= LCD_HEIGHT)) return;
  __lcd_buffer[0] = (color & (0xff00)) >> 8;
  __lcd_buffer[1]  = (color & (0xff));
  
  lcd_setAddrWindow(lcd_spim, x, y, x+1, y+1);

  lcd_pushColor(lcd_spim,  __lcd_buffer, 2); 

}


void lcd_drawImage(rt_spim_t *lcd_spim, unsigned short x, unsigned short y, unsigned short w, unsigned short h, unsigned short * image) 
{
  // rudimentary clipping (drawChar w/big text requires this)
  if((x >= LCD_WIDTH) || (y >= LCD_HEIGHT)) return;
  if((x + w - 1) >= LCD_WIDTH)  w = LCD_WIDTH  - x;
  if((y + h - 1) >= LCD_HEIGHT) h = LCD_HEIGHT - y;

  char * buffer = (char * ) image;
  // printf("Is filling! \n");
  lcd_setAddrWindow(lcd_spim, x, y, x+w-1, y+h-1);
  
  for(int i=0;i<h*2;i++){
    lcd_pushColor(lcd_spim,  &buffer[i*(w)], w); 
  }

}


void lcd_init(rt_spim_t *lcd_spim)
{
  __tx_buffer = rt_alloc(RT_ALLOC_PERIPH, 16);
  __lcd_buffer = rt_alloc(RT_ALLOC_PERIPH, LCD_WIDTH*LCD_HEIGHT*2);

  lcd_writecommand(lcd_spim,  __tx_buffer, 0xEF);
  __tx_buffer[0] = 0x03;
  __tx_buffer[1] = 0x80;
  __tx_buffer[2] = 0x02;  
  lcd_writedata(lcd_spim, __tx_buffer, 3);

  lcd_writecommand(lcd_spim,  __tx_buffer,0xCF); 
  __tx_buffer[0] = 0x00;
  __tx_buffer[1] = 0XC1;
  __tx_buffer[2] = 0X30;  
  lcd_writedata(lcd_spim, __tx_buffer, 3); 

  lcd_writecommand(lcd_spim,  __tx_buffer,0xED);  
  __tx_buffer[0] = 0x64;
  __tx_buffer[1] = 0x03;
  __tx_buffer[2] = 0X12;  
  __tx_buffer[3] = 0X81;  
  lcd_writedata(lcd_spim, __tx_buffer, 4); 

  lcd_writecommand(lcd_spim,  __tx_buffer,0xE8);  
  __tx_buffer[0] = 0x85;
  __tx_buffer[1] = 0x00;
  __tx_buffer[2] = 0x78;  
  lcd_writedata(lcd_spim, __tx_buffer, 3); 

  lcd_writecommand(lcd_spim,  __tx_buffer,0xCB);
  __tx_buffer[0] = 0x39;
  __tx_buffer[1] = 0x2C;
  __tx_buffer[2] = 0x00;  
  __tx_buffer[3] = 0x34;  
  __tx_buffer[4] = 0x02;  
  lcd_writedata(lcd_spim, __tx_buffer, 5);   

  lcd_writecommand(lcd_spim,  __tx_buffer,0xF7);  
  __tx_buffer[0] = 0x20;
  lcd_writedata(lcd_spim, __tx_buffer, 1); 

  lcd_writecommand(lcd_spim,  __tx_buffer,0xEA);  
  __tx_buffer[0] = 0x00;
  __tx_buffer[1] = 0x00;
  lcd_writedata(lcd_spim, __tx_buffer, 2);    

  lcd_writecommand(lcd_spim,  __tx_buffer, ILI9341_PWCTR1);    //Power control 
  __tx_buffer[0] = 0x23;   //VRH[5:0] 
  lcd_writedata(lcd_spim, __tx_buffer, 1); 

  lcd_writecommand(lcd_spim,  __tx_buffer, ILI9341_PWCTR2);    //Power control 
  __tx_buffer[0] = 0x10;  //SAP[2:0];BT[3:0] 
  lcd_writedata(lcd_spim, __tx_buffer, 1); 

  lcd_writecommand(lcd_spim,  __tx_buffer, ILI9341_VMCTR1);    //VCM control 
  __tx_buffer[0] = 0x3e;
  __tx_buffer[1] = 0x28;
  lcd_writedata(lcd_spim, __tx_buffer, 2); 

  lcd_writecommand(lcd_spim,  __tx_buffer,ILI9341_VMCTR2);    //VCM control2 
  __tx_buffer[0] = 0x86; 
  lcd_writedata(lcd_spim, __tx_buffer, 1); 

  lcd_writecommand(lcd_spim,  __tx_buffer,ILI9341_MADCTL);    // Memory Access Control 
  __tx_buffer[0] = 0x48;
  lcd_writedata(lcd_spim, __tx_buffer, 1); 

  lcd_writecommand(lcd_spim,__tx_buffer, ILI9341_PIXFMT);  
  __tx_buffer[0] = 0x55;
  lcd_writedata(lcd_spim, __tx_buffer, 1);   

  lcd_writecommand(lcd_spim,  __tx_buffer,ILI9341_FRMCTR1); 
    __tx_buffer[0] = 0x00;
  __tx_buffer[1] = 0x18;
  lcd_writedata(lcd_spim, __tx_buffer, 2);    

  lcd_writecommand(lcd_spim,  __tx_buffer,ILI9341_DFUNCTR);    // Display Function Control 
  __tx_buffer[0] = 0x08;
  __tx_buffer[1] = 0x82;
  __tx_buffer[2] = 0x27;  
  lcd_writedata(lcd_spim, __tx_buffer, 3);    

  lcd_writecommand(lcd_spim,  __tx_buffer,0xF2);    // 3Gamma Function Disable 
    __tx_buffer[0] = 0x85;
  __tx_buffer[1] = 0x00;
  __tx_buffer[2] = 0x78;  
  lcd_writedata(lcd_spim, __tx_buffer, 3); 

  lcd_writecommand(lcd_spim,__tx_buffer, ILI9341_GAMMASET);    //Gamma curve selected 
  __tx_buffer[0] = 0x00;
  lcd_writedata(lcd_spim, __tx_buffer, 1); 

  lcd_writecommand(lcd_spim,  __tx_buffer,ILI9341_GMCTRP1);    //Set Gamma 
  __tx_buffer[0]  = 0x0F;
  __tx_buffer[1]  = 0x31;
  __tx_buffer[2]  = 0x2B;  
  __tx_buffer[3]  = 0x0C;
  __tx_buffer[4]  = 0x0E;
  __tx_buffer[5]  = 0x08;  
  __tx_buffer[6]  = 0x4E;
  __tx_buffer[7]  = 0xF1;
  __tx_buffer[8]  = 0x37;  
  __tx_buffer[9]  = 0x07;
  __tx_buffer[10] = 0x03;
  __tx_buffer[11] = 0x0E;  
  __tx_buffer[12] = 0x09;
  __tx_buffer[13] = 0x00;
  lcd_writedata(lcd_spim, __tx_buffer, 14);               

  lcd_writecommand(lcd_spim,  __tx_buffer,ILI9341_GMCTRN1);    //Set Gamma 
  __tx_buffer[0]  = 0x00;
  __tx_buffer[1]  = 0x0E;
  __tx_buffer[2]  = 0x14;  
  __tx_buffer[3]  = 0x03;
  __tx_buffer[4]  = 0x11;
  __tx_buffer[5]  = 0x07;  
  __tx_buffer[6]  = 0x31;
  __tx_buffer[7]  = 0xC1;
  __tx_buffer[8]  = 0x48;  
  __tx_buffer[9]  = 0x08;
  __tx_buffer[10] = 0x0F;
  __tx_buffer[11] = 0x0C;  
  __tx_buffer[12] = 0x31;
  __tx_buffer[13] = 0x36;
  __tx_buffer[14] = 0x0F;
  lcd_writedata(lcd_spim, __tx_buffer, 15); 

  lcd_writecommand(lcd_spim,  __tx_buffer, ILI9341_SLPOUT);    //Exit Sleep 

  rt_time_wait_us(2000);     

  lcd_writecommand(lcd_spim,  __tx_buffer, ILI9341_DISPON);    //Display on 

}