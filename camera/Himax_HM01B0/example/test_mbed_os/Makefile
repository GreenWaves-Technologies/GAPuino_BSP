# User Test
#------------------------------------------
TEST_C          = ../../Drivers/mbed_os/Driver/gapuino_himax.c ./test_BSP_HIMAX.c
INC            += ../../Drivers/mbed_os/Components \
		../../Drivers/mbed_os/Driver

# If you do not want to use RTOS, comment it.
# If you want use RTOS then uncomment it.
# MBED_FLAGS     += -DMBED_CONF_RTOS_PRESENT=1

# For RTOS Jenkins test, it will never finished so add a jenkins test Flag to exit().
# MBED_FLAGS     +=-DJENKINS_TEST_FLAG=1

# RTL Simulation
#------------------------------------------
# recordWlf=YES
# vsimDo="-do ~/wave.do"

PLPBRIDGE_FLAGS += -s camera@../../../test.py

include $(GAP_SDK_HOME)/tools/rules/mbed_rules.mk
