echo Downloading Bootloader ...
echo Building apps lookup table
.\tools\OpenOCD\Win32\openocd-all-brcm-libftdi.exe -s .\tools\OpenOCD\scripts -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -f ./tools/OpenOCD/stm32f4x-flash-app.cfg -c "verify_image_checksum build/waf.bootloader-NoOS-LSRSTERLING_00950/binary/waf.bootloader-NoOS-LSRSTERLING_00950.stripped.elf" -c shutdown >> build/openocd_log.txt 2>&1 && echo No changes detected && "./tools/common/Win32/echo.exe" || .\tools\OpenOCD\Win32\openocd-all-brcm-libftdi.exe -s .\tools\OpenOCD\scripts -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -f ./tools/OpenOCD/stm32f4x-flash-app.cfg -c "flash write_image erase build/waf.bootloader-NoOS-LSRSTERLING_00950/binary/waf.bootloader-NoOS-LSRSTERLING_00950.stripped.elf" -c shutdown >> build/openocd_log.txt 2>&1 && echo Download complete && "./tools/common/Win32/echo.exe" || echo "**** OpenOCD failed - ensure you have installed the driver from the drivers directory, and that the debugger is not running **** In Linux this may be due to USB access permissions. In a virtual machine it may be due to USB passthrough settings. Check in the task list that another OpenOCD process is not running. Check that you have the correct target and JTAG device plugged in. ****"


echo Downloading DCT ...
.\tools\OpenOCD\Win32\openocd-all-brcm-libftdi.exe -s .\tools\OpenOCD\scripts -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -f ./tools/OpenOCD/stm32f4x-flash-app.cfg -c "verify_image_checksum build/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/DCT.stripped.elf" -c shutdown >> build/openocd_log.txt 2>&1 && echo No changes detected && "./tools/common/Win32/echo.exe" || .\tools\OpenOCD\Win32\openocd-all-brcm-libftdi.exe -s .\tools\OpenOCD\scripts -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -f ./tools/OpenOCD/stm32f4x-flash-app.cfg -c "flash write_image erase build/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/DCT.stripped.elf" -c shutdown >> build/openocd_log.txt 2>&1 && echo Download complete && "./tools/common/Win32/echo.exe" || echo "**** OpenOCD failed - ensure you have installed the driver from the drivers directory, and that the debugger is not running **** In Linux this may be due to USB access permissions. In a virtual machine it may be due to USB passthrough settings. Check in the task list that another OpenOCD process is not running. Check that you have the correct target and JTAG device plugged in. ****"


echo Downloading Application ...

.\tools\OpenOCD\Win32\openocd-all-brcm-libftdi.exe -s .\tools\OpenOCD\scripts -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -f ./tools/OpenOCD/stm32f4x-flash-app.cfg -c "verify_image_checksum build/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/binary/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug.stripped.elf" -c shutdown >> build/openocd_log.txt 2>&1 && echo No changes detected && "./tools/common/Win32/echo.exe" || .\tools\OpenOCD\Win32\openocd-all-brcm-libftdi.exe -s .\tools\OpenOCD\scripts -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -f ./tools/OpenOCD/stm32f4x-flash-app.cfg -c "flash write_image erase build/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/binary/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug.stripped.elf" -c shutdown >> build/openocd_log.txt 2>&1 && echo Download complete && "./tools/common/Win32/echo.exe" || echo "**** OpenOCD failed - ensure you have installed the driver from the drivers directory, and that the debugger is not running **** In Linux this may be due to USB access permissions. In a virtual machine it may be due to USB passthrough settings. Check in the task list that another OpenOCD process is not running. Check that you have the correct target and JTAG device plugged in. ****"


echo Downloading resources filesystem ... build/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/filesystem.bin at sector 1  size 95...
.\tools\OpenOCD\Win32\openocd-all-brcm-libftdi.exe -s .\tools\OpenOCD\scripts -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -f apps/waf/sflash_write/sflash_write.tcl -c "sflash_write_file build/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/filesystem.bin 4096 LSRSTERLING_00950-SDIO 0 0" -c shutdown >> build/openocd_log.txt 2>&1

echo Downloading apps lookup table in wiced_apps.mk ... build/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/APPS.bin @ 0x0000 size 
.\tools\OpenOCD\Win32\openocd-all-brcm-libftdi.exe -s .\tools\OpenOCD\scripts -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -f apps/waf/sflash_write/sflash_write.tcl -c "sflash_write_file build/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/APPS.bin 0x0000 LSRSTERLING_00950-SDIO 0 0" -c shutdown >> build/openocd_log.txt 2>&1

echo Resetting target

.\tools\OpenOCD\Win32\openocd-all-brcm-libftdi.exe -s .\tools\OpenOCD\scripts -c "log_output build/openocd_log.txt" -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -c init -c "reset run" -c shutdown >> build/openocd_log.txt 2>&1 && echo Target running

echo Making .gdbinit

echo set remotetimeout 20 > .gdbinit
echo shell start /B ./tools/OpenOCD/Win32/openocd-all-brcm-libftdi.exe -s ./tools/OpenOCD/scripts -f ./tools/OpenOCD/CYW9WCD1EVAL1.cfg -f ./tools/OpenOCD/stm32f4x.cfg -f ./tools/OpenOCD/stm32f4x_gdb_jtag.cfg  -l build/openocd_log.txt >> .gdbinit
