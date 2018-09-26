set remotetimeout 20 
shell start /B ./tools/OpenOCD/Win32/openocd-all-brcm-libftdi.exe -s ./tools/OpenOCD/scripts -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -f ./tools/OpenOCD/stm32f4x_gdb_jtag.cfg  -l build/openocd_log.txt 
