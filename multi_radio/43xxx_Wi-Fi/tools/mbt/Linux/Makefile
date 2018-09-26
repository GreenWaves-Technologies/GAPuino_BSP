#******************************************************************************
#*
#*  Copyright 2016, Cypress Semiconductor Corporation or a subsidiary of
#*  Cypress Semiconductor Corporation. All Rights Reserved.
#*
#******************************************************************************

CC      = gcc
MKDIR   = mkdir -p
PWD     = pwd

INCDIR  = ../common
SOURCES = mbt.c $(INCDIR)/mbt_common.c 
CFLAGS  = -pthread
OUTDIR  = ./Release

all : mbt

mbt: $(SOURCES)
	$(MKDIR) $(OUTDIR)
	$(CC) $(CFLAGS) -I $(INCDIR) -o $(OUTDIR)/$@ $^

clean:
	@rm -rf $(OUTDIR)
