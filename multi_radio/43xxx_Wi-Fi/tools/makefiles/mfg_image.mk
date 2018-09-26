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

include $(MAKEFILES_PATH)/wiced_toolchain_common.mk

include $(BUILD_DIR)/$(FRAPP)/config.mk

COMPONENTS := $(subst -, ,$(MAKECMDGOALS))
USE_APP       := $(if $(findstring app,$(COMPONENTS)),1)
# look for ota, but NOT ota2_image or ota2_download or ota2_factory_image or ota2_factory_download
USE_OTA       := $(if $(findstring ota,$(COMPONENTS)),$(if $(findstring ota2_,$(COMPONENTS)),0,1))
USE_DCT       := $(if $(findstring dct,$(COMPONENTS)),1)
DO_DOWNLOAD   := $(if $(findstring download,$(COMPONENTS)),1)

DCT ?=$(BUILD_DIR)/$(FRAPP)/DCT.stripped.elf

ifeq ($(wildcard $(DCT)),)
$(error Could not find specified DCT file $(DCT))
endif

ifeq ($(strip $(USE_APP)$(USE_OTA)$(USE_DCT)),)
$(error Specify one or more of: app (Factory Reset App image), dct (Device Config Table), ota (Over The Air Upgrade App Image))
endif

ifneq ($(strip $(USE_OTA)),)
ifeq ($(strip $(OTA)),)
$(error Specify app-rtos-networkstack target for OTA app with OTA=   e.g. OTA=ota_upgrade-ThreadX-NetX_Duo)
endif
endif

APP_COMPONENTS := $(subst -, ,$(FRAPP))
APP_BUS        := $(if $(findstring SDIO,$(APP_COMPONENTS)),SDIO,$(findstring SPI,$(APP_COMPONENTS)))
APP_PLATFORM   := $(notdir $(strip $(foreach comp,$(APP_COMPONENTS),$(wildcard $(SOURCE_ROOT)WICED/platform/$(comp)))))

OTA_TGT:=$(OTA)-$(PLATFORM)-$(BUS)
SFLASHWRITER_TGT:=waf.sflash_write-NoOS-$(PLATFORM)-$(BUS)

OTA_TGT_DIR:=$(subst .,_,$(OTA_TGT))
SFLASHWRITER_TGT_DIR:=$(subst .,_,$(SFLASHWRITER_TGT))

ifneq ($(DO_DOWNLOAD),)
-include ./build/$(SFLASHWRITER_TGT_DIR)/config.mk
endif

OUTPUT_DIR :=./build/$(FRAPP)/
OUTPUT_DIR_CONVD := $(call CONV_SLASHES,$(OUTPUT_DIR))


.PHONY: ota_upgrade_app concated_sflash_image

$(MAKECMDGOALS): concated_sflash_image  $(if $(DO_DOWNLOAD),download_sflash)

ota_upgrade_app:
	$(QUIET)$(ECHO) Building the OTA-Upgrade App $(OTA_TGT)
	$(QUIET)$(ECHO_BLANK_LINE)
	$(QUIET)$(MAKE) $(SILENT) -f $(SOURCE_ROOT)Makefile -s $(OTA_TGT) NO_BUILD_BOOTLOADER=1
	$(QUIET)$(ECHO_BLANK_LINE)


concated_sflash_image: $(if $(USE_OTA),ota_upgrade_app) pad_dct
	$(QUIET)$(ECHO) Concatenating the binaries into an image for the serial-flash chip
	$(QUIET)$(ECHO_BLANK_LINE)
	$(QUIET)$(CAT) $(call CONV_SLASHES,$(BUILD_DIR)/$(FRAPP)/binary/$(FRAPP).stripped.elf) > $(OUTPUT_DIR_CONVD)sflash.bin
ifneq ($(strip $(USE_DCT)),)
	$(QUIET)$(CAT) $(call CONV_SLASHES,$(DCT)) >> $(OUTPUT_DIR_CONVD)sflash.bin
else
	$(QUIET)$(PERL) -e "$(PERL_ESC_DOLLAR)x=-s'$(DCT)'; print \"\xff\" x $(PERL_ESC_DOLLAR)x;" > $(call CONV_SLASHES,./build/$(FRAPP)/blankDCT.bin)
	$(QUIET)$(CAT) $(call CONV_SLASHES,./build/$(FRAPP)/blankDCT.bin) >> $(OUTPUT_DIR_CONVD)sflash.bin
endif
ifneq ($(strip $(USE_OTA)),)
	$(QUIET)$(CAT) $(call CONV_SLASHES,./build/$(OTA_TGT_DIR)/binary/$(OTA_TGT_DIR).stripped.elf) >> $(OUTPUT_DIR_CONVD)sflash.bin
endif
	$(QUIET)$(ECHO_BLANK_LINE)


sflash_writer_app:
	$(QUIET)$(ECHO) Building the Serial Flash Writer App
	$(QUIET)$(ECHO_BLANK_LINE)
	$(QUIET)$(MAKE) $(SILENT) -f $(SOURCE_ROOT)Makefile -s $(SFLASHWRITER_TGT) NO_BUILD_BOOTLOADER=1
	$(QUIET)$(ECHO) Done
	$(QUIET)$(ECHO_BLANK_LINE)

./build/$(SFLASHWRITER_TGT_DIR)/config.mk: sflash_writer_app

download_sflash: sflash_writer_app
	$(QUIET)$(ECHO) Downloading Serial Flash image
	$(QUIET)$(ECHO_BLANK_LINE)
	$(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f apps/waf/sflash_write/sflash_write.tcl -c "sflash_write_file $(OUTPUT_DIR)sflash.bin 0x0 $(PLATFORM)-$(BUS) 1 0" -c shutdown
	$(QUIET)$(ECHO_BLANK_LINE)

pad_dct:
	$(QUIET)$(PERL) $(TOOLS_ROOT)/create_dct/pad_dct.pl $(DCT)
