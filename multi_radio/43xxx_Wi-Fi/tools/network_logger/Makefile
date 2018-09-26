#
# Copyright 2017, Cypress Semiconductor Corporation or a subsidiary of 
 # Cypress Semiconductor Corporation. All Rights Reserved.
 # This software, including source code, documentation and related
 # materials ("Software"), is owned by Cypress Semiconductor Corporation
 # or one of its subsidiaries ("Cypress") and is protected by and subject to
 # worldwide patent protection (United States and foreign),
 # United States copyright laws and international treaty provisions.
 # Therefore, you may use this Software only as provided in the license
 # agreement accompanying the software package from which you
 # obtained this Software ("EULA").
 # If no EULA applies, Cypress hereby grants you a personal, non-exclusive,
 # non-transferable license to copy, modify, and compile the Software
 # source code solely for use in connection with Cypress's
 # integrated circuit products. Any reproduction, modification, translation,
 # compilation, or representation of this Software except as specified
 # above is prohibited without the express written permission of Cypress.
 #
 # Disclaimer: THIS SOFTWARE IS PROVIDED AS-IS, WITH NO WARRANTY OF ANY KIND,
 # EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, NONINFRINGEMENT, IMPLIED
 # WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. Cypress
 # reserves the right to make changes to the Software without notice. Cypress
 # does not assume any liability arising out of the application or use of the
 # Software or any product or circuit described in the Software. Cypress does
 # not authorize its products for use in any products where a malfunction or
 # failure of the Cypress product may reasonably be expected to result in
 # significant property damage, injury or death ("High Risk Product"). By
 # including Cypress's product in a High Risk Product, the manufacturer
 # of such system or application assumes all risk of such use and in doing
 # so agrees to indemnify Cypress against all liability.
#

NAME := network_logger

# Determine build environment
UNAME_OS = $(shell uname)
UNAME_ARCH  = $(shell uname -m)

ifeq ($(findstring CYGWIN,$(UNAME_OS)),CYGWIN)
EXTENSION :=.exe
OS        := Win
CC_32     := i686-pc-cygwin-gcc.exe
CC_64     := x86_64-pc-cygwin-gcc.exe
CFLAGS_32 :=
CFLAGS_64 :=
ifeq ($(findstring x86_64,$(UNAME_ARCH)),x86_64)
DLL_32    := /usr/i686-pc-cygwin/sys-root/usr/bin/cygwin1.dll
DLL_64    := /usr/bin/cygwin1.dll
else # i686
DLL_32    := /usr/bin/cygwin1.dll
DLL_64    := /usr/x86_64-pc-cygwin/sys-root/usr/bin/cygwin1.dll
endif
else ifeq ($(findstring Linux,$(UNAME_OS)),Linux)
EXTENSION :=
OS        := Linux
CC_32     := gcc
CC_64     := gcc
CFLAGS_32 := -lpthread -m32
CFLAGS_64 := -lpthread -m64
DLL_32    :=
DLL_64    :=
else
$(error "Unsupported build environment")
endif

ifeq ($(findstring x86_64,$(UNAME_ARCH)),x86_64)
ARCH := 64
else
ARCH := 32
endif

BIN_DIR := ../common/$(OS)
SRC     := src/network_logger.c

.PHONY: default 32 64

default: $(ARCH)

32: $(SRC)
	@$(info Building $(NAME) for $(OS)$(@))
	@mkdir -p $(BIN_DIR)$(@)
	@$(CC_$(@)) $(CFLAGS_$(@)) -o $(BIN_DIR)$(@)/$(NAME)$(EXTENSION) $(SRC)
ifneq ($(DLL_32),)
	@cp $(DLL_$(@)) $(BIN_DIR)$(@)/
endif

64: $(SRC)
	@$(info Building $(NAME) for $(OS)$(@))
	@mkdir -p $(BIN_DIR)$(@)
	@$(CC_$(@)) $(CFLAGS_$(@)) -o $(BIN_DIR)$(@)/$(NAME)$(EXTENSION) $(SRC)
ifneq ($(DLL_64),)
	@cp $(DLL_$(@)) $(BIN_DIR)$(@)/
endif

