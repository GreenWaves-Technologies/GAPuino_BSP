/*
 * MultiRadio_Library.h
 *
 *  Created on: 13 Apr 2018
 *      Author: TP
 */

#include "rt/rt_api.h"

#ifndef MAIN_H_
#define MAIN_H_


#define SPI2_DATAREADY_PIN 5
#define SPI2_DATAREADY_PAD 17

#define SPI2_CS_PIN 
#define SPI2_CS_PAD	

#define SPI_BUSY_PIN 19
#define SPI_BUSY_PAD 33

#define	SPI_READY_PIN 0




#define __UNUSED__ 0


extern rt_spim_t *spim;
extern rt_event_t* spi_evnt;

void _Error_Handler(char *file, int line);











#endif