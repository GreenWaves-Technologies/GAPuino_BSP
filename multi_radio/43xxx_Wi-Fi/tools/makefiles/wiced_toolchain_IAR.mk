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

ARM_GNU_ARCH_LIST :=

THUMB_GNU_ARCH_LIST := ARM_CM0 \
                       ARM_CM3 \
                       ARM_CM4 \
                       ARM_CR4

########  Define your IAR path here if auto detection fails ############

IAR_VERSIONS_FOUND := $(sort $(filter-out C:/Program Files/IAR Systems/Embedded Workbench, $(wildcard   C:/Program\ Files/IAR\ Systems/*)))

ifneq ($(IAR_VERSIONS_FOUND),)
IAR_LATEST_VERSION := $(word $(words $(IAR_VERSIONS_FOUND)),$(IAR_VERSIONS_FOUND))
IAR_ARM_WORKBENCH_PATH := C:\Program Files\IAR Systems\Embedded Workbench $(IAR_LATEST_VERSION)
IAR_TOOLCHAIN_PATH := "C:\Program Files\IAR Systems\Embedded Workbench $(IAR_LATEST_VERSION)\arm\bin\"
else
IAR_VERSIONS_FOUND := $(sort $(filter-out C:/Program Files (x86)/IAR Systems/Embedded Workbench, $(wildcard   C:/Program\ Files\ (x86)/IAR\ Systems/*)))
ifneq ($(IAR_VERSIONS_FOUND),)
IAR_LATEST_VERSION := $(word $(words $(IAR_VERSIONS_FOUND)),$(IAR_VERSIONS_FOUND))
IAR_ARM_WORKBENCH_PATH := C:\Program Files (x86)\IAR Systems\Embedded Workbench $(IAR_LATEST_VERSION)
IAR_TOOLCHAIN_PATH := "C:\Program Files (x86)\IAR Systems\Embedded Workbench $(IAR_LATEST_VERSION)\arm\bin\"
else
ifeq ($(IAR),1)
$(error could not auto detect IAR toolchain path. please set manually in wiced_toolchain_common.mk)
endif
endif
endif


# Leverage OpenOCD and GDB for IAR toolchain.  Win32 only for now.
GNU_TOOLCHAIN_PATH := $(TOOLS_ROOT)/ARM_GNU/bin/Win32/
GDBINIT_STRING      = shell start /B $(OPENOCD_FULL_NAME) -f $(OPENOCD_PATH)$(JTAG).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD).cfg -f $(OPENOCD_PATH)$(HOST_OPENOCD)_gdb_jtag.cfg -l $(OPENOCD_LOG_FILE)
GDB_COMMAND         = cmd /C $(call CONV_SLASHES, $(TOOLCHAIN_PATH))$(TOOLCHAIN_PREFIX)gdb$(EXECUTABLE_SUFFIX)


IAR_WORKBENCH_BIN_PATH := $(IAR_ARM_WORKBENCH_PATH)\common\bin
IAR_WORKBENCH_EXECUTABLE := $(IAR_WORKBENCH_BIN_PATH)\IarIdePM.exe

ifneq ($(filter $(HOST_ARCH), $(THUMB_GNU_ARCH_LIST) $(ARM_GNU_ARCH_LIST)),)

# Set shortcuts to the compiler and other tools
CC := $(IAR_TOOLCHAIN_PATH)iccarm.exe
CXX := $(IAR_TOOLCHAIN_PATH)iccarm.exe
AS := $(IAR_TOOLCHAIN_PATH)iasmarm.exe
AR := $(IAR_TOOLCHAIN_PATH)iarchive.exe
LN := $(IAR_TOOLCHAIN_PATH)ilinkarm.exe
CN := $(IAR_TOOLCHAIN_PATH)ielftool.exe

#file for compilation results, we will use this file to generate build results table
IAR_BUILD_RESULTS_FILE	   := $(OUTPUT_DIR)/iar_build_results_tmp.txt

# Turn off warning about non-standard line endings
COMPILER_SPECIFIC_PEDANTIC_CFLAGS     :=
IAR_IDENTIFIER_DEFINE				  := -DIAR_TOOLCHAIN
COMPILER_SPECIFIC_OPTIMIZED_CFLAGS    := -Oh
COMPILER_SPECIFIC_UNOPTIMIZED_CFLAGS  := -On
# Suppress unix line ending warning
COMPILER_SPECIFIC_STANDARD_CFLAGS     := --char_is_signed -e $(IAR_IDENTIFIER_DEFINE) --vla  --dlib_config full

# C++ options:
# For IAR, one can choose Embedded C++ (--ec++) or Extended Embedded C++ (--eec++)
# Embedded C++ is chosen here for efficiency considerations. In Embedded C++, advanced
# features such as RTTI and Exception handling are not supported.
#
# Dlib config
# --dlib_config full to enable dlib support for I/O streams such as stdin/stdout/stderr
COMPILER_SPECIFIC_STANDARD_CXXFLAGS   := --char_is_signed -e $(IAR_IDENTIFIER_DEFINE) --ec++ --dlib_config full
COMPILER_SPECIFIC_ARFLAGS_CREATE      := --create -o
COMPILER_SPECIFIC_ARFLAGS_ADD         := -r -o
COMPILER_SPECIFIC_ARFLAGS_VERBOSE     :=
COMPILER_SPECIFIC_DEPS_FLAG            = --dependencies=m +
COMPILER_SPECIFIC_DEBUG_CFLAGS        := -DDEBUG --debug $(COMPILER_SPECIFIC_UNOPTIMIZED_CFLAGS)
COMPILER_SPECIFIC_DEBUG_CXXFLAGS      := -DDEBUG --debug $(COMPILER_SPECIFIC_UNOPTIMIZED_CFLAGS)
COMPILER_SPECIFIC_DEBUG_ASFLAGS       :=
COMPILER_SPECIFIC_DEBUG_LDFLAGS       :=
COMPILER_SPECIFIC_RELEASE_CFLAGS      := -DNDEBUG --debug $(COMPILER_SPECIFIC_OPTIMIZED_CFLAGS)
COMPILER_SPECIFIC_RELEASE_CXXFLAGS    := -DNDEBUG --debug $(COMPILER_SPECIFIC_OPTIMIZED_CFLAGS)
COMPILER_SPECIFIC_RELEASE_ASFLAGS     :=
COMPILER_SPECIFIC_RELEASE_LDFLAGS     :=
COMPILER_SPECIFIC_LINK_MAP            =  --map $(1)
COMPILER_SPECIFIC_LINK_FILES          =  $(1)
COMPILER_SPECIFIC_LINK_SCRIPT_DEFINE_OPTION = --config
COMPILER_SPECIFIC_LINK_SCRIPT         =  --config $(1)
ASM_COMPILER_FLAGS					  = $(IAR_IDENTIFIER_DEFINE) -D$(RTOS)
COMPILER_SPECIFIC_EXTRA_DCT_LDFLAGS   :=

COMPILER_SPECIFIC_STDOUT_REDIRECT     := >> $(IAR_BUILD_RESULTS_FILE)
#force not to use default libraries
LINKER 							      :=  $(LN)
LINK_SCRIPT_SUFFIX                    := .icf
CONVERTER 							  :=  $(CN)
CONVERTER_SCRIPT_SUFFIX               := .hex
#--no_library_search
OPTIONS_IN_FILE_OPTION                := -f
TOOLCHAIN_NAME                        := IAR

# $(1) is map file, $(2) is CSV output file
COMPILER_SPECIFIC_MAPFILE_TO_CSV =


MAPFILE_PARSER            :=$(TOOLS_ROOT)/mapfile_parser/map_parse_iar.pl

# $(1) is map file, $(2) is CSV output file
COMPILER_SPECIFIC_MAPFILE_DISPLAY_SUMMARY = $(PERL) $(MAPFILE_PARSER) $(1)

# Add to build_done $(if $(TOOLCHAIN_NAME),IAR,$(IAR_PROJECT_FILE))
$(IAR_PROJECT_FILE):
	$(QUIET)$(ECHO) Generating IAR project file
	$(QUIET)$(IAR_PROJECT_GENERATOR) $(IAR_PROJECT_DEFAULT_TEMPLATE) $(SOURCE_ROOT)


# Chip specific flags for IAR
# Suppress unaligned structure warning for processors that allow unaligned access
ifeq ($(HOST_ARCH),ARM_CM4)
CPU_CFLAGS   := --cpu_mode thumb --cpu Cortex-M4  --diag_suppress Pa039 --diag_suppress Pa050
CPU_CXXFLAGS := --cpu_mode thumb --cpu Cortex-M4  --diag_suppress Pa039 --diag_suppress Pa050
CPU_ASMFLAGS := --cpu_mode thumb --cpu Cortex-M4
endif

ifeq ($(HOST_ARCH),ARM_CM3)
CPU_CFLAGS   := --cpu_mode thumb --cpu Cortex-M3  --diag_suppress Pa039 --diag_suppress Pa050
CPU_CXXFLAGS := --cpu_mode thumb --cpu Cortex-M3  --diag_suppress Pa039 --diag_suppress Pa050
CPU_ASMFLAGS := --cpu_mode thumb --cpu Cortex-M3
endif

ENDIAN_CFLAGS_LITTLE   := --endian little
ENDIAN_CXXFLAGS_LITTLE := --endian little
ENDIAN_ASMFLAGS_LITTLE := --endian little


OBJCOPY := $(CN)
STRIP   := $(CN)

# $(1) input file, $(2) output file
STRIP_OPTIONS = --silent --strip $(1) $(2)
FINAL_OUTPUT_OPTIONS = --silent --bin $(1) $(2)

LINK_OUTPUT_SUFFIX :=.elf

FINAL_OUTPUT_SUFFIX :=.bin

endif #ifneq ($(filter $(HOST_ARCH), ARM_CM3 ARM_CM4),)
