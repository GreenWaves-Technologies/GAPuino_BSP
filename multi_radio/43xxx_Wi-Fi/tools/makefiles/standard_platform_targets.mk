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

.PHONY: bootloader download_bootloader no_dct download_dct download
.PHONY: package package_bootloader package_dct package_app

# Include packaging rules
PACKAGE_OUTPUT_DIR := $(OUTPUT_DIR)
-include $(MAKEFILES_PATH)/wiced_package.mk

BOOTLOADER_TARGET := waf.bootloader-NoOS-$(PLATFORM)
BOOTLOADER_OUTFILE := $(BUILD_DIR)/$(BOOTLOADER_TARGET)/binary/$(BOOTLOADER_TARGET)
BOOTLOADER_LOG_FILE ?= $(BUILD_DIR)/bootloader.log
GENERATED_MAC_FILE := $(SOURCE_ROOT)generated_mac_address.txt
MAC_GENERATOR      := $(TOOLS_ROOT)/mac_generator/mac_generator.pl

#APPS LOOK UP TABLE PARAMS
APPS_LUT_DOWNLOAD_DEP :=

#SFLASH_WRITER_APP Required by  download_apps
SFLASH_APP_PLATFROM_BUS := $(PLATFORM)-$(BUS)
SFLASH_APP_BCM4390 := 0
PACKAGE_SFLASH_FLAG := 0

ifeq ($(RESOURCES_LOCATION), RESOURCES_IN_WICEDFS)
FS_IMAGE    := $(OUTPUT_DIR)/filesystem.bin
FILESYSTEM_IMAGE := $(FS_IMAGE)
endif

ifeq (,$(and $(OPENOCD_PATH),$(OPENOCD_FULL_NAME)))
	$(error Path to OpenOCD has not been set using OPENOCD_PATH and OPENOCD_FULL_NAME)
endif


ifneq ($(VERBOSE),1)
BOOTLOADER_REDIRECT	= > $(BOOTLOADER_LOG_FILE)
endif

ifneq (,$(findstring waf/bootloader, $(BUILD_STRING))$(findstring wwd/, $(BUILD_STRING)))
NO_BUILD_BOOTLOADER:=1
NO_BOOTLOADER_REQUIRED:=1
endif

#$(info standard_platform_targets.mk ota2_support=$(OTA2_SUPPORT))
ifeq (1,$(OTA2_SUPPORT))
NO_BUILD_BOOTLOADER:=1
NO_BOOTLOADER_REQUIRED:=1
endif

#$(info standard_platform_targets.mk UPDATE_FROM_SDK=$(UPDATE_FROM_SDK))
ifneq (,$(UPDATE_FROM_SDK))
NO_BUILD_BOOTLOADER:=1
NO_BOOTLOADER_REQUIRED:=1
endif

ifneq ($(NO_BUILD_BOOTLOADER),1)
bootloader:
	$(QUIET)$(ECHO) Building Bootloader
	$(QUIET)$(MAKE) -r -f $(SOURCE_ROOT)Makefile $(BOOTLOADER_TARGET) -I$(OUTPUT_DIR)  SFLASH= EXTERNAL_WICED_GLOBAL_DEFINES=$(EXTERNAL_WICED_GLOBAL_DEFINES) SUB_BUILD=bootloader $(BOOTLOADER_REDIRECT)
	$(QUIET)$(ECHO) Finished Building Bootloader
	$(QUIET)$(ECHO_BLANK_LINE)

download_bootloader: bootloader display_map_summary
	$(QUIET)$(ECHO) Downloading Bootloader ...
ifeq ($(ALWAYS_DOWNLOAD_COMPONENTS),1)
	$(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD)-flash-app.cfg -c "flash write_image erase $(BOOTLOADER_OUTFILE).stripped$(LINK_OUTPUT_SUFFIX)" -c shutdown $(DOWNLOAD_LOG) 2>&1 && $(ECHO) Download complete && $(ECHO_BLANK_LINE) || $(ECHO) "**** OpenOCD failed - ensure you have installed the driver from the drivers directory, and that the debugger is not running **** In Linux this may be due to USB access permissions. In a virtual machine it may be due to USB passthrough settings. Check in the task list that another OpenOCD process is not running. Check that you have the correct target and JTAG device plugged in. ****"
else
	$(QUIET)$(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD)-flash-app.cfg -c "verify_image_checksum $(BOOTLOADER_OUTFILE).stripped$(LINK_OUTPUT_SUFFIX)" -c shutdown $(DOWNLOAD_LOG) 2>&1 && $(ECHO) No changes detected && $(ECHO_BLANK_LINE) || $(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD)-flash-app.cfg -c "flash write_image erase $(BOOTLOADER_OUTFILE).stripped$(LINK_OUTPUT_SUFFIX)" -c shutdown $(DOWNLOAD_LOG) 2>&1 && $(ECHO) Download complete && $(ECHO_BLANK_LINE) || $(ECHO) "**** OpenOCD failed - ensure you have installed the driver from the drivers directory, and that the debugger is not running **** In Linux this may be due to USB access permissions. In a virtual machine it may be due to USB passthrough settings. Check in the task list that another OpenOCD process is not running. Check that you have the correct target and JTAG device plugged in. ****"
endif

package_bootloader: bootloader display_map_summary package_dct
	$(QUIET)$(ECHO) Packaging Bootloader ...
	$(call ADD_TO_PACKAGE, $(BOOTLOADER_OUTFILE).stripped$(LINK_OUTPUT_SUFFIX), "mcuflash", "")

#make sure apps lookup table target is done first, to avoid concurrent file access and crash on linux
copy_bootloader_output_for_eclipse: build_done APPS_LOOKUP_TABLE_RULES
	$(QUIET)$(call MKDIR, $(BUILD_DIR)/eclipse_debug/)
	$(QUIET)$(CP) $(BOOTLOADER_OUTFILE)$(LINK_OUTPUT_SUFFIX) $(BUILD_DIR)/eclipse_debug/last_bootloader.elf


else
ifeq (1,$(NO_BOOTLOADER_REQUIRED))
bootloader:
	@:

else
bootloader:
	$(QUIET)$(ECHO) Skipping building bootloader due to commandline spec

endif

download_bootloader:
	$(QUIET)$(ECHO) Skipping building bootloader due to NO_BOOTLOADER_REQUIRED

copy_bootloader_output_for_eclipse:
	@:

endif



ifneq (no_dct,$(findstring no_dct,$(MAKECMDGOALS)))
download_dct: $(STRIPPED_LINK_DCT_FILE) display_map_summary download_bootloader
	$(QUIET)$(ECHO) Downloading DCT ...
ifeq ($(ALWAYS_DOWNLOAD_COMPONENTS),1)
	$(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD)-flash-app.cfg -c "flash write_image erase $(STRIPPED_LINK_DCT_FILE)" -c shutdown $(DOWNLOAD_LOG) 2>&1 && $(ECHO) Download complete && $(ECHO_BLANK_LINE) || $(ECHO) "**** OpenOCD failed - ensure you have installed the driver from the drivers directory, and that the debugger is not running **** In Linux this may be due to USB access permissions. In a virtual machine it may be due to USB passthrough settings. Check in the task list that another OpenOCD process is not running. Check that you have the correct target and JTAG device plugged in. ****"
else
	$(QUIET)$(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD)-flash-app.cfg -c "verify_image_checksum $(STRIPPED_LINK_DCT_FILE)" -c shutdown $(DOWNLOAD_LOG) 2>&1 && $(ECHO) No changes detected && $(ECHO_BLANK_LINE) || $(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD)-flash-app.cfg -c "flash write_image erase $(STRIPPED_LINK_DCT_FILE)" -c shutdown $(DOWNLOAD_LOG) 2>&1 && $(ECHO) Download complete && $(ECHO_BLANK_LINE) || $(ECHO) "**** OpenOCD failed - ensure you have installed the driver from the drivers directory, and that the debugger is not running **** In Linux this may be due to USB access permissions. In a virtual machine it may be due to USB passthrough settings. Check in the task list that another OpenOCD process is not running. Check that you have the correct target and JTAG device plugged in. ****"
endif

package_dct: $(DCT_IMAGE_PLATFORM) display_map_summary
	$(QUIET)$(ECHO) Packaging DCT ...
	$(call ADD_TO_PACKAGE, $(STRIPPED_LINK_DCT_FILE), "mcuflash", "")
else
download_dct:
	@:

package_dct:
	@:

no_dct:
	$(QUIET)$(ECHO) DCT unmodified

endif

download: $(STRIPPED_LINK_OUTPUT_FILE) display_map_summary download_bootloader $(if $(findstring no_dct,$(MAKECMDGOALS)),,download_dct)
	$(QUIET)$(ECHO) Downloading Application ...
ifeq ($(ALWAYS_DOWNLOAD_COMPONENTS),1)
	$(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD)-flash-app.cfg -c "flash write_image erase $(STRIPPED_LINK_OUTPUT_FILE)" -c shutdown $(DOWNLOAD_LOG) 2>&1 && $(ECHO) Download complete && $(ECHO_BLANK_LINE) || $(ECHO) "**** OpenOCD failed - ensure you have installed the driver from the drivers directory, and that the debugger is not running **** In Linux this may be due to USB access permissions. In a virtual machine it may be due to USB passthrough settings. Check in the task list that another OpenOCD process is not running. Check that you have the correct target and JTAG device plugged in. ****"
else
	$(QUIET)$(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD)-flash-app.cfg -c "verify_image_checksum $(STRIPPED_LINK_OUTPUT_FILE)" -c shutdown $(DOWNLOAD_LOG) 2>&1 && $(ECHO) No changes detected && $(ECHO_BLANK_LINE) || $(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD)-flash-app.cfg -c "flash write_image erase $(STRIPPED_LINK_OUTPUT_FILE)" -c shutdown $(DOWNLOAD_LOG) 2>&1 && $(ECHO) Download complete && $(ECHO_BLANK_LINE) || $(ECHO) "**** OpenOCD failed - ensure you have installed the driver from the drivers directory, and that the debugger is not running **** In Linux this may be due to USB access permissions. In a virtual machine it may be due to USB passthrough settings. Check in the task list that another OpenOCD process is not running. Check that you have the correct target and JTAG device plugged in. ****"
endif

package: $(RELEASE_PACKAGE)
	$(QUIET)$(ECHO) Created package successfully

$(RELEASE_PACKAGE): create_package_descriptor \
		$(STRIPPED_LINK_OUTPUT_FILE) display_map_summary \
		package_bootloader $(if $(findstring no_dct,$(MAKECMDGOALS)),,package_dct) package_app package_apps

package_app: $(STRIPPED_LINK_OUTPUT_FILE)
	$(QUIET)$(ECHO) Packaging Application ...
	$(call ADD_TO_PACKAGE, $(STRIPPED_LINK_OUTPUT_FILE), "mcuflash", "")

ifeq (download,$(filter download,$(MAKECMDGOALS)))
APPS_LUT_DOWNLOAD_DEP := download
endif

ifeq (package,$(filter package,$(MAKECMDGOALS)))
APPS_LUT_PACKAGE_DEP := package
endif

download_apps: APPS_LUT_DOWNLOAD
package_apps: APPS_LUT_PACKAGE

run: $(SHOULD_I_WAIT_FOR_DOWNLOAD)
	$(QUIET)$(ECHO) Resetting target
	$(QUIET)$(call CONV_SLASHES,$(OPENOCD_FULL_NAME)) -c "log_output $(OPENOCD_LOG_FILE)" -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -c init -c "reset run" -c shutdown $(DOWNLOAD_LOG) 2>&1 && $(ECHO) Target running


copy_output_for_eclipse: build_done copy_bootloader_output_for_eclipse
	$(QUIET)$(call MKDIR, $(BUILD_DIR)/eclipse_debug/)
	$(QUIET)$(CP) $(LINK_OUTPUT_FILE) $(BUILD_DIR)/eclipse_debug/last_built.elf



debug: $(BUILD_STRING) $(SHOULD_I_WAIT_FOR_DOWNLOAD)
	$(QUIET)$(GDB_COMMAND) $(LINK_OUTPUT_FILE) -x .gdbinit_attach


$(GENERATED_MAC_FILE): $(MAC_GENERATOR)
	$(QUIET)$(PERL) $<  > $@


EXTRA_PRE_BUILD_TARGETS  += $(GENERATED_MAC_FILE) bootloader
EXTRA_POST_BUILD_TARGETS += copy_output_for_eclipse

