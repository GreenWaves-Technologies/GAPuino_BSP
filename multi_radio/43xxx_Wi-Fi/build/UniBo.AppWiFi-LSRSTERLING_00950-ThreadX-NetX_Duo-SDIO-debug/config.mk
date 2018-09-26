WICED_SDK_MAKEFILES           += ./WICED/platform/MCU/STM32F4xx/peripherals/libraries/libraries.mk ./libraries/utilities/crc/crc.mk ./libraries/utilities/ring_buffer/ring_buffer.mk ./WICED/platform/MCU/STM32F4xx/peripherals/peripherals.mk ./WICED/platform/GCC/GCC.mk ./WICED/security/BESL/mbedtls_open/mbedtls_open.mk ./libraries/utilities/base64/base64.mk ./libraries/utilities/TLV/TLV.mk ./libraries/utilities/linked_list/linked_list.mk ./libraries/daemons/DHCP_server/DHCP_server.mk ./libraries/test/TraceX/TraceX.mk ././libraries/drivers/bluetooth/firmware/firmware.mk ././WICED/platform/MCU/STM32F4xx/STM32F4xx.mk ./libraries/filesystems/wicedfs/wicedfs.mk ./libraries/protocols/DNS/DNS.mk ././WICED/security/PostgreSQL/PostgreSQL.mk ././WICED/security/BESL/BESL.mk ././WICED/WWD/WWD.mk ././WICED/network/NetX_Duo/WICED/WICED.mk ././WICED/network/NetX_Duo/WWD/WWD.mk ././WICED/RTOS/ThreadX/WICED/WICED.mk ././WICED/RTOS/ThreadX/WWD/WWD.mk ./libraries/inputs/gpio_button/gpio_button.mk ./libraries/drivers/spi_flash/spi_flash.mk ././libraries/drivers/bluetooth/low_energy/low_energy.mk ././libraries/drivers/spi_slave/spi_slave.mk ././WICED/WICED.mk ./WICED/network/NetX_Duo/NetX_Duo.mk ./WICED/RTOS/ThreadX/ThreadX.mk ./platforms/LSRSTERLING_00950/LSRSTERLING_00950.mk ./apps/UniBo/AppWiFi/AppWiFi.mk
TOOLCHAIN_NAME                := GCC
JTAG                          := CYW9WCD1EVAL1
WICED_SDK_LDFLAGS             += -Wl,--gc-sections -Wl,--cref -mthumb -mcpu=cortex-m4 -Wl,-A,thumb -Wl,-z,max-page-size=0x10 -Wl,-z,common-page-size=0x10 -mlittle-endian -nostartfiles -Wl,--defsym,__STACKSIZE__=800 -L ./WICED/platform/MCU/STM32F4xx/GCC -L ./WICED/platform/MCU/STM32F4xx/GCC/STM32F411
RESOURCE_CFLAGS               += -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\" -mthumb -mcpu=cortex-m4 -mlittle-endian
RESOURCE_CXXFLAGS             += -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\" -mthumb -mcpu=cortex-m4 -mlittle-endian
WICED_SDK_LINK_SCRIPT         += ././WICED/platform/MCU/STM32F4xx/GCC/app_with_bootloader.ld
WICED_SDK_LINK_SCRIPT_CMD     += -Wl,-T ././WICED/platform/MCU/STM32F4xx/GCC/app_with_bootloader.ld
WICED_SDK_PREBUILT_LIBRARIES  += ./WICED/RTOS/ThreadX/ThreadX.ARM_CM4.debug.a ./WICED/network/NetX_Duo/NetX_Duo.ThreadX.ARM_CM4.debug.a ././libraries/drivers/bluetooth/low_energy/../bluetooth_low_energy.ThreadX.NetX_Duo.ARM_CM4.release.a ././WICED/security/BESL/BESL_generic.ARM_CM4.release.a ././WICED/security/PostgreSQL/PostgreSQL.ARM_CM4.release.a
WICED_SDK_CERTIFICATES        += 
WICED_SDK_PRE_APP_BUILDS      += bootloader
WICED_SDK_DCT_LINK_SCRIPT     += ././WICED/platform/MCU/STM32F4xx/GCC/STM32F411/dct.ld
WICED_SDK_DCT_LINK_CMD        += -Wl,-T ././WICED/platform/MCU/STM32F4xx/GCC/STM32F411/dct.ld
WICED_SDK_APPLICATION_DCT     += 
WICED_SDK_WIFI_CONFIG_DCT_H   += ./include/default_wifi_config_dct.h
WICED_SDK_BT_CONFIG_DCT_H     += ./include/default_bt_config_dct.h
WICED_SDK_LINK_FILES          +=                                      $(OUTPUT_DIR)/Modules/./WICED/platform/MCU/STM32F4xx/../../ARM_CM4/crt0_GCC.o $(OUTPUT_DIR)/Modules/./WICED/platform/MCU/STM32F4xx/../../ARM_CM4/hardfault_handler.o $(OUTPUT_DIR)/Modules/./WICED/platform/MCU/STM32F4xx/platform_vector_table.o                $(OUTPUT_DIR)/Modules/WICED/platform/GCC/mem_newlib.o $(OUTPUT_DIR)/Modules/WICED/platform/GCC/time_newlib.o $(OUTPUT_DIR)/Modules/WICED/platform/GCC/stdio_newlib.o        
WICED_SDK_INCLUDES            +=                                                                             -I./WICED/platform/MCU/STM32F4xx/peripherals/libraries/. -I./WICED/platform/MCU/STM32F4xx/peripherals/libraries/inc -I./WICED/platform/MCU/STM32F4xx/peripherals/libraries/../../../ARM_CM4/CMSIS -I./libraries/utilities/crc/. -I./libraries/utilities/ring_buffer/. -I./WICED/platform/MCU/STM32F4xx/peripherals/. -I./WICED/platform/GCC/. -I./WICED/security/BESL/mbedtls_open/include -I./libraries/utilities/base64/. -I./libraries/utilities/TLV/. -I./libraries/utilities/linked_list/. -I./libraries/daemons/DHCP_server/. -I./libraries/test/TraceX/. -I././WICED/platform/MCU/STM32F4xx/. -I././WICED/platform/MCU/STM32F4xx/.. -I././WICED/platform/MCU/STM32F4xx/../.. -I././WICED/platform/MCU/STM32F4xx/../../include -I././WICED/platform/MCU/STM32F4xx/../../ARM_CM4 -I././WICED/platform/MCU/STM32F4xx/../../ARM_CM4/CMSIS -I././WICED/platform/MCU/STM32F4xx/peripherals -I././WICED/platform/MCU/STM32F4xx/WAF -I././WICED/platform/MCU/STM32F4xx/../../../../../apps/waf/bootloader/ -I./libraries/filesystems/wicedfs/src -I./libraries/protocols/DNS/. -I././WICED/security/PostgreSQL/include -I././WICED/security/BESL/host/WICED -I././WICED/security/BESL/TLS -I././WICED/security/BESL/crypto_internal -I././WICED/security/BESL/WPS -I././WICED/security/BESL/include -I././WICED/security/BESL/P2P -I././WICED/security/BESL/crypto_internal/homekit_srp -I././WICED/security/BESL/crypto_internal/ed25519 -I././WICED/security/BESL/supplicant -I././WICED/security/BESL/DTLS -I././WICED/security/BESL/mbedtls_open/include -I././WICED/WWD/. -I././WICED/WWD/include -I././WICED/WWD/include/network -I././WICED/WWD/include/RTOS -I././WICED/WWD/internal/bus_protocols/SDIO -I././WICED/WWD/internal/chips/4343x -I././WICED/WWD/../../libraries/utilities/linked_list -I././WICED/WWD/../RTOS/ThreadX/WICED -I././WICED/network/NetX_Duo/WICED/. -I././WICED/network/NetX_Duo/WWD/. -I././WICED/RTOS/ThreadX/WICED/. -I././WICED/RTOS/ThreadX/WWD/. -I././WICED/RTOS/ThreadX/WWD/CM3_CM4 -I./libraries/inputs/gpio_button/. -I./libraries/drivers/spi_flash/. -I././libraries/drivers/bluetooth/low_energy/./ -I././libraries/drivers/bluetooth/low_energy/../include -I././libraries/drivers/bluetooth/low_energy/../BTE/Components/gki/common -I././libraries/drivers/bluetooth/low_energy/../BTE/Components/udrv/include -I././libraries/drivers/bluetooth/low_energy/../BTE/Projects/bte/main -I././libraries/drivers/bluetooth/low_energy/../BTE/Components/stack/include -I././libraries/drivers/bluetooth/low_energy/../BTE/proto_disp/ -I././libraries/drivers/bluetooth/low_energy/../BTE/WICED -I././libraries/drivers/spi_slave/. -I././WICED/. -I././WICED/platform/include -I././WICED/../apps/UniBo/AppWiFi -I./WICED/network/NetX_Duo/ver5.7_sp2 -I./WICED/network/NetX_Duo/ver5.7_sp2/netx_bsd_layer -I./WICED/network/NetX_Duo/WICED -I./WICED/RTOS/ThreadX/ver5.6 -I./WICED/RTOS/ThreadX/ver5.6/Cortex_M3_M4/GCC -I./WICED/RTOS/ThreadX/WWD/CM3_CM4 -I./platforms/LSRSTERLING_00950/. -I./platforms/LSRSTERLING_00950/./libraries/inputs/gpio_button -I./WICED/WWD/internal/chips/4343x -I./libraries -I./include
WICED_SDK_DEFINES             +=                                                                        -DSFLASH_APPS_HEADER_LOC=0x0000 -DUSE_STDPERIPH_DRIVER -D_STM3x_ -D_STM32x_ -DSTM32F411xE -DPLATFORM_SUPPORTS_LOW_POWER_MODES -DMAX_WATCHDOG_TIMEOUT_SECONDS=22 -DUSING_WICEDFS -DADD_LWIP_EAPOL_SUPPORT -DNXD_EXTENDED_BSD_SOCKET_SUPPORT -DOPENSSL -DSTDC_HEADERS -Dwifi_firmware_image=resources_firmware_DIR_4343W_DIR_4343WA1_bin -Dwifi_firmware_clm_blob=resources_firmware_DIR_4343W_DIR_4343WA1_clm_blob -DWWD_DOWNLOAD_CLM_BLOB -DADD_NETX_EAPOL_SUPPORT -DNX_FRAGMENT_IMMEDIATE_ASSEMBLY -DWWD_STARTUP_DELAY=10 -DBOOTLOADER_MAGIC_NUMBER=0x4d435242 -DNETWORK_NetX_Duo=1 -DNetX_Duo_VERSION=\"v5.7_sp2\" -DNX_INCLUDE_USER_DEFINE_FILE -D__fd_set_defined -DSYS_TIME_H_AVAILABLE -DRTOS_ThreadX=1 -DThreadX_VERSION=\"v5.6\" -DTX_INCLUDE_USER_DEFINE_FILE -DHSE_VALUE=8000000 -DCRLF_STDIO_REPLACEMENT -DWICED_DCT_INCLUDE_BT_CONFIG -DWICED_DISABLE_STDIO -DWICED_DISABLE_TLS -DTX_PACKET_POOL_SIZE=7 -DRX_PACKET_POOL_SIZE=4 -DCOM_PACKET_POOL_SIZE=11 -DWICED_CONFIG_DISABLE_DTLS -DWICED_CONFIG_DISABLE_ENTERPRISE_SECURITY -DENABLE_PLATFORM_FUN -DWICED_SDK_WIFI_CONFIG_DCT_H=\"./include/default_wifi_config_dct.h\" -DWICED_SDK_BT_CONFIG_DCT_H=\"./include/default_bt_config_dct.h\"
COMPONENTS                := App_WiFi Platform_LSRSTERLING_00950 ThreadX NetX_Duo WICED Lib_SPI_Slave_Library Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED Lib_SPI_Flash_Library_LSRSTERLING_00950 Lib_GPIO_button WWD_ThreadX_Interface WICED_ThreadX_Interface WWD_NetX_Duo_Interface WICED_NetX_Duo_Interface WWD_for_SDIO_ThreadX Supplicant_BESL Fortuna_PostgreSQL Lib_DNS Lib_Wiced_RO_FS STM32F4xx Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1 Lib_tracex Lib_DHCP_Server Lib_Linked_List Lib_TLV Lib_base64 mbedTLS_Open common_GCC STM32F4xx_Peripheral_Drivers Lib_Ring_Buffer Lib_crc STM32F4xx_Peripheral_Libraries
BUS                       := SDIO
IMAGE_TYPE                := ram
NETWORK_FULL              := NetX_Duo
RTOS_FULL                 := ThreadX
PLATFORM_DIRECTORY        := LSRSTERLING_00950
APP_FULL                  := UniBo/AppWiFi
NETWORK                   := NetX_Duo
RTOS                      := ThreadX
PLATFORM                  := LSRSTERLING_00950
APPS_CHIP_REVISION        := 
USB                       := 
APP                       := AppWiFi
HOST_OPENOCD              := stm32f4x
HOST_ARCH                 := ARM_CM4
WICED_SDK_CERTIFICATE         := 
WICED_SDK_PRIVATE_KEY         := 
NO_BUILD_BOOTLOADER           := 
NO_BOOTLOADER_REQUIRED        := 
COMPILER_SPECIFIC_SYSTEM_DIR  := -isystem ./tools/ARM_GNU/bin/Win32/../../include -isystem ./tools/ARM_GNU/bin/Win32/../../lib/include -isystem ./tools/ARM_GNU/bin/Win32/../../lib/include-fixed
BOARD_SPECIFIC_OPENOCD_SCRIPT := 
App_WiFi_LOCATION         := ./apps/UniBo/AppWiFi/
Platform_LSRSTERLING_00950_LOCATION         := ./platforms/LSRSTERLING_00950/
ThreadX_LOCATION         := ./WICED/RTOS/ThreadX/
NetX_Duo_LOCATION         := ./WICED/network/NetX_Duo/
WICED_LOCATION         := ././WICED/
Lib_SPI_Slave_Library_LOCATION         := ././libraries/drivers/spi_slave/
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_LOCATION         := ././libraries/drivers/bluetooth/low_energy/
Lib_SPI_Flash_Library_LSRSTERLING_00950_LOCATION         := ./libraries/drivers/spi_flash/
Lib_GPIO_button_LOCATION         := ./libraries/inputs/gpio_button/
WWD_ThreadX_Interface_LOCATION         := ././WICED/RTOS/ThreadX/WWD/
WICED_ThreadX_Interface_LOCATION         := ././WICED/RTOS/ThreadX/WICED/
WWD_NetX_Duo_Interface_LOCATION         := ././WICED/network/NetX_Duo/WWD/
WICED_NetX_Duo_Interface_LOCATION         := ././WICED/network/NetX_Duo/WICED/
WWD_for_SDIO_ThreadX_LOCATION         := ././WICED/WWD/
Supplicant_BESL_LOCATION         := ././WICED/security/BESL/
Fortuna_PostgreSQL_LOCATION         := ././WICED/security/PostgreSQL/
Lib_DNS_LOCATION         := ./libraries/protocols/DNS/
Lib_Wiced_RO_FS_LOCATION         := ./libraries/filesystems/wicedfs/
STM32F4xx_LOCATION         := ././WICED/platform/MCU/STM32F4xx/
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_LOCATION         := ././libraries/drivers/bluetooth/firmware/
Lib_tracex_LOCATION         := ./libraries/test/TraceX/
Lib_DHCP_Server_LOCATION         := ./libraries/daemons/DHCP_server/
Lib_Linked_List_LOCATION         := ./libraries/utilities/linked_list/
Lib_TLV_LOCATION         := ./libraries/utilities/TLV/
Lib_base64_LOCATION         := ./libraries/utilities/base64/
mbedTLS_Open_LOCATION         := ./WICED/security/BESL/mbedtls_open/
common_GCC_LOCATION         := ./WICED/platform/GCC/
STM32F4xx_Peripheral_Drivers_LOCATION         := ./WICED/platform/MCU/STM32F4xx/peripherals/
Lib_Ring_Buffer_LOCATION         := ./libraries/utilities/ring_buffer/
Lib_crc_LOCATION         := ./libraries/utilities/crc/
STM32F4xx_Peripheral_Libraries_LOCATION         := ./WICED/platform/MCU/STM32F4xx/peripherals/libraries/
App_WiFi_SOURCES          += ram.c api.c ExtInterface.c AppCO.c AppWiFi.c ble_app.c wiced_bt_cfg.c
Platform_LSRSTERLING_00950_SOURCES          += platform.c
ThreadX_SOURCES          += 
NetX_Duo_SOURCES          += ver5.7_sp2/nxd_external_functions.c
WICED_SOURCES          += internal/wiced_core.c internal/time.c internal/system_monitor.c internal/wiced_lib.c internal/wiced_crypto.c internal/waf.c internal/wiced_audio.c internal/wifi.c internal/wiced_wifi_deep_sleep.c internal/wiced_cooee.c internal/wiced_easy_setup.c internal/wiced_filesystem.c internal/wiced_low_power.c
Lib_SPI_Slave_Library_SOURCES          += spi_slave.c
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_SOURCES          += ../BTE/bt_logmsg/wiced_bt_logmsg.c ../BTE/proto_disp/wiced_bt_protocol_print.c
Lib_SPI_Flash_Library_LSRSTERLING_00950_SOURCES          += spi_flash.c spi_flash_wiced.c
Lib_GPIO_button_SOURCES          += gpio_button.c
WWD_ThreadX_Interface_SOURCES          += wwd_rtos.c CM3_CM4/low_level_init.c
WICED_ThreadX_Interface_SOURCES          += wiced_rtos.c ../../wiced_rtos_common.c
WWD_NetX_Duo_Interface_SOURCES          += wwd_buffer.c wwd_network.c
WICED_NetX_Duo_Interface_SOURCES          += wiced_network.c tcpip.c ../../wiced_network_common.c ../../wiced_tcpip_common.c
WWD_for_SDIO_ThreadX_SOURCES          += internal/wwd_thread.c internal/wwd_ap_common.c internal/wwd_thread_internal.c internal/wwd_sdpcm.c internal/wwd_internal.c internal/wwd_management.c internal/wwd_wifi.c internal/wwd_wifi_sleep.c internal/wwd_wifi_chip_common.c internal/wwd_rtos_interface.c internal/wwd_logging.c internal/wwd_debug.c internal/wwd_eapol.c internal/bus_protocols/wwd_bus_common.c internal/bus_protocols/SDIO/wwd_bus_protocol.c internal/wwd_clm.c internal/chips/4343x/wwd_ap.c internal/chips/4343x/wwd_chip_specific_functions.c
Supplicant_BESL_SOURCES          += host/WICED/besl_host.c host/WICED/wiced_tls.c host/WICED/wiced_wps.c host/WICED/wiced_p2p.c host/WICED/cipher_suites.c host/WICED/tls_cipher_suites.c host/WICED/dtls_cipher_suites.c host/WICED/p2p_internal.c host/WICED/wiced_supplicant.c P2P/p2p_events.c P2P/p2p_frame_writer.c host/WICED/wiced_dtls.c
Fortuna_PostgreSQL_SOURCES          += 
Lib_DNS_SOURCES          += dns.c
Lib_Wiced_RO_FS_SOURCES          += src/wicedfs.c wicedfs_drivers.c
STM32F4xx_SOURCES          += ../../ARM_CM4/crt0_GCC.c ../../ARM_CM4/hardfault_handler.c ../../ARM_CM4/host_cm4.c ../platform_resource.c ../platform_stdio.c ../wiced_platform_common.c ../wwd_platform_separate_mcu.c ../wwd_resources.c ../wiced_apps_common.c ../wiced_waf_common.c ../platform_nsclock.c platform_vector_table.c platform_init.c platform_unhandled_isr.c platform_filesystem.c WAF/waf_platform.c  ../platform_button.c ../wiced_dct_internal_common.c ../wiced_dct_update.c WWD/wwd_platform.c WWD/wwd_SDIO.c
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_SOURCES          += 43438A1/37_4MHz/bt_firmware_controller.c
Lib_tracex_SOURCES          += 
Lib_DHCP_Server_SOURCES          += dhcp_server.c
Lib_Linked_List_SOURCES          += linked_list.c
Lib_TLV_SOURCES          += tlv.c
Lib_base64_SOURCES          += bsd-base64.c
mbedTLS_Open_SOURCES          += library/aes.c library/aesni.c library/arc4.c library/asn1parse.c library/asn1write.c library/base64.c library/bignum.c library/blowfish.c library/camellia.c library/ccm.c library/cipher.c library/cipher_wrap.c library/cmac.c library/ctr_drbg.c library/des.c library/dhm.c library/ecdh.c library/ecdsa.c library/ecjpake.c library/ecp.c library/ecp_curves.c library/entropy.c library/entropy_poll.c library/error.c library/gcm.c library/havege.c library/hmac_drbg.c library/md.c library/md2.c library/md4.c library/md5.c library/md_wrap.c library/memory_buffer_alloc.c library/oid.c library/padlock.c library/pem.c library/pk.c library/pk_wrap.c library/pkcs12.c library/pkcs5.c library/pkparse.c library/pkwrite.c library/platform.c library/ripemd160.c library/rsa.c library/sha1.c library/sha256.c library/sha512.c library/threading.c library/timing.c library/version.c library/version_features.c library/xtea.c library/certs.c library/pkcs11.c library/x509.c library/x509_create.c library/x509_crl.c library/x509_crt.c library/x509_csr.c library/x509write_crt.c library/x509write_csr.c library/debug.c library/net_sockets.c library/ssl_cache.c library/ssl_ciphersuites.c library/ssl_cli.c library/ssl_cookie.c library/ssl_srv.c library/ssl_ticket.c library/ssl_tls.c 
common_GCC_SOURCES          +=  mem_newlib.c time_newlib.c math_newlib.c cxx_funcs.c stdio_newlib.c
STM32F4xx_Peripheral_Drivers_SOURCES          += platform_adc.c platform_gpio.c platform_i2c.c platform_mcu_powersave.c platform_pwm.c platform_rtc.c platform_spi.c platform_uart.c platform_watchdog.c platform_i2s.c platform_ext_memory.c platform_audio_timer.c platform_gspi_master.c
Lib_Ring_Buffer_SOURCES          += ring_buffer.c
Lib_crc_SOURCES          += crc.c
STM32F4xx_Peripheral_Libraries_SOURCES          += src/misc.c src/stm32f4xx_adc.c src/stm32f4xx_can.c src/stm32f4xx_crc.c src/stm32f4xx_dac.c src/stm32f4xx_dbgmcu.c src/stm32f4xx_dma.c src/stm32f4xx_exti.c src/stm32f4xx_flash.c src/stm32f4xx_gpio.c src/stm32f4xx_rng.c src/stm32f4xx_i2c.c src/stm32f4xx_iwdg.c src/stm32f4xx_pwr.c src/stm32f4xx_rcc.c src/stm32f4xx_rtc.c src/stm32f4xx_sdio.c src/stm32f4xx_spi.c src/stm32f4xx_syscfg.c src/stm32f4xx_tim.c src/stm32f4xx_usart.c src/stm32f4xx_wwdg.c
App_WiFi_CHECK_HEADERS    += 
Platform_LSRSTERLING_00950_CHECK_HEADERS    += 
ThreadX_CHECK_HEADERS    += 
NetX_Duo_CHECK_HEADERS    += 
WICED_CHECK_HEADERS    += internal/wiced_internal_api.h ../include/default_wifi_config_dct.h ../include/resource.h ../include/wiced.h ../include/wiced_defaults.h ../include/wiced_easy_setup.h ../include/wiced_framework.h ../include/wiced_management.h ../include/wiced_platform.h ../include/wiced_rtos.h ../include/wiced_tcpip.h ../include/wiced_time.h ../include/wiced_utilities.h ../include/wiced_crypto.h ../include/wiced_wifi.h ../include/wiced_wifi_deep_sleep.h
Lib_SPI_Slave_Library_CHECK_HEADERS    += 
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_CHECK_HEADERS    += 
Lib_SPI_Flash_Library_LSRSTERLING_00950_CHECK_HEADERS    += 
Lib_GPIO_button_CHECK_HEADERS    += 
WWD_ThreadX_Interface_CHECK_HEADERS    += wwd_rtos.h
WICED_ThreadX_Interface_CHECK_HEADERS    += rtos.h
WWD_NetX_Duo_Interface_CHECK_HEADERS    += wwd_buffer.h wwd_network.h
WICED_NetX_Duo_Interface_CHECK_HEADERS    += wiced_network.h
WWD_for_SDIO_ThreadX_CHECK_HEADERS    += internal/wwd_ap.h internal/wwd_ap_common.h internal/wwd_bcmendian.h internal/wwd_internal.h internal/wwd_logging.h internal/wwd_sdpcm.h internal/wwd_thread.h internal/wwd_thread_internal.h internal/bus_protocols/wwd_bus_protocol_interface.h internal/bus_protocols/SDIO/wwd_bus_protocol.h internal/chips/4343x/chip_constants.h include/wwd_assert.h include/wwd_constants.h include/wwd_debug.h include/wwd_events.h include/wwd_management.h include/wwd_poll.h include/wwd_structures.h include/wwd_wifi.h include/wwd_wifi_sleep.h include/wwd_wifi_chip_common.h include/wwd_wlioctl.h include/Network/wwd_buffer_interface.h include/Network/wwd_network_constants.h include/Network/wwd_network_interface.h include/platform/wwd_bus_interface.h include/platform/wwd_platform_interface.h include/platform/wwd_resource_interface.h include/platform/wwd_sdio_interface.h include/platform/wwd_spi_interface.h include/RTOS/wwd_rtos_interface.h
Supplicant_BESL_CHECK_HEADERS    += 
Fortuna_PostgreSQL_CHECK_HEADERS    += 
Lib_DNS_CHECK_HEADERS    += 
Lib_Wiced_RO_FS_CHECK_HEADERS    += 
STM32F4xx_CHECK_HEADERS    += 
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_CHECK_HEADERS    += 
Lib_tracex_CHECK_HEADERS    += 
Lib_DHCP_Server_CHECK_HEADERS    += 
Lib_Linked_List_CHECK_HEADERS    += 
Lib_TLV_CHECK_HEADERS    += 
Lib_base64_CHECK_HEADERS    += 
mbedTLS_Open_CHECK_HEADERS    += 
common_GCC_CHECK_HEADERS    += 
STM32F4xx_Peripheral_Drivers_CHECK_HEADERS    += 
Lib_Ring_Buffer_CHECK_HEADERS    += 
Lib_crc_CHECK_HEADERS    += 
STM32F4xx_Peripheral_Libraries_CHECK_HEADERS    += 
App_WiFi_INCLUDES         := -I./apps/UniBo/AppWiFi/.
Platform_LSRSTERLING_00950_INCLUDES         := 
ThreadX_INCLUDES         := 
NetX_Duo_INCLUDES         := 
WICED_INCLUDES         := -I././WICED/security/BESL/crypto_internal -I././WICED/security/BESL/include -I././WICED/security/BESL/host/WICED -I././WICED/security/BESL/WPS -I././WICED/security/PostgreSQL -I././WICED/security/PostgreSQL/include -I././WICED/security/BESL/mbedtls_open/include
Lib_SPI_Slave_Library_INCLUDES         := 
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_INCLUDES         := 
Lib_SPI_Flash_Library_LSRSTERLING_00950_INCLUDES         := 
Lib_GPIO_button_INCLUDES         := 
WWD_ThreadX_Interface_INCLUDES         := 
WICED_ThreadX_Interface_INCLUDES         := 
WWD_NetX_Duo_Interface_INCLUDES         := 
WICED_NetX_Duo_Interface_INCLUDES         := 
WWD_for_SDIO_ThreadX_INCLUDES         := 
Supplicant_BESL_INCLUDES         := 
Fortuna_PostgreSQL_INCLUDES         := 
Lib_DNS_INCLUDES         := 
Lib_Wiced_RO_FS_INCLUDES         := 
STM32F4xx_INCLUDES         := 
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_INCLUDES         := 
Lib_tracex_INCLUDES         := 
Lib_DHCP_Server_INCLUDES         := 
Lib_Linked_List_INCLUDES         := 
Lib_TLV_INCLUDES         := 
Lib_base64_INCLUDES         := 
mbedTLS_Open_INCLUDES         := 
common_GCC_INCLUDES         := 
STM32F4xx_Peripheral_Drivers_INCLUDES         := 
Lib_Ring_Buffer_INCLUDES         := 
Lib_crc_INCLUDES         := 
STM32F4xx_Peripheral_Libraries_INCLUDES         := 
App_WiFi_DEFINES          := 
Platform_LSRSTERLING_00950_DEFINES          := 
ThreadX_DEFINES          := 
NetX_Duo_DEFINES          := 
WICED_DEFINES          := 
Lib_SPI_Slave_Library_DEFINES          := 
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_DEFINES          := 
Lib_SPI_Flash_Library_LSRSTERLING_00950_DEFINES          := -DSFLASH_SUPPORT_SST_PARTS -DSFLASH_SUPPORT_MACRONIX_PARTS -DSFLASH_SUPPORT_EON_PARTS -DSFLASH_SUPPORT_MICRON_PARTS
Lib_GPIO_button_DEFINES          := 
WWD_ThreadX_Interface_DEFINES          := 
WICED_ThreadX_Interface_DEFINES          := 
WWD_NetX_Duo_Interface_DEFINES          := 
WICED_NetX_Duo_Interface_DEFINES          := 
WWD_for_SDIO_ThreadX_DEFINES          := 
Supplicant_BESL_DEFINES          := 
Fortuna_PostgreSQL_DEFINES          := 
Lib_DNS_DEFINES          := 
Lib_Wiced_RO_FS_DEFINES          := 
STM32F4xx_DEFINES          := 
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_DEFINES          := 
Lib_tracex_DEFINES          := 
Lib_DHCP_Server_DEFINES          := 
Lib_Linked_List_DEFINES          := 
Lib_TLV_DEFINES          := 
Lib_base64_DEFINES          := 
mbedTLS_Open_DEFINES          := 
common_GCC_DEFINES          := 
STM32F4xx_Peripheral_Drivers_DEFINES          := 
Lib_Ring_Buffer_DEFINES          := 
Lib_crc_DEFINES          := 
STM32F4xx_Peripheral_Libraries_DEFINES          := 
App_WiFi_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
Platform_LSRSTERLING_00950_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
ThreadX_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
NetX_Duo_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
WICED_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
Lib_SPI_Slave_Library_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
Lib_SPI_Flash_Library_LSRSTERLING_00950_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
Lib_GPIO_button_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
WWD_ThreadX_Interface_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
WICED_ThreadX_Interface_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
WWD_NetX_Duo_Interface_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
WICED_NetX_Duo_Interface_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
WWD_for_SDIO_ThreadX_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
Supplicant_BESL_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -fno-strict-aliasing
Fortuna_PostgreSQL_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -fno-strict-aliasing
Lib_DNS_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
Lib_Wiced_RO_FS_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
STM32F4xx_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
Lib_tracex_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
Lib_DHCP_Server_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -Wall -fsigned-char -ffunction-sections -fdata-sections -fno-common -std=gnu11                  -Werror -Wstrict-prototypes  -W -Wshadow  -Wwrite-strings -pedantic -std=c11 -U__STRICT_ANSI__ -Wconversion -Wextra -Wdeclaration-after-statement -Wconversion -Waddress -Wlogical-op -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wmissing-field-initializers -Wdouble-promotion -Wswitch-enum -Wswitch-default -Wuninitialized -Wunknown-pragmas -Wfloat-equal  -Wundef  -Wshadow 
Lib_Linked_List_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
Lib_TLV_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
Lib_base64_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
mbedTLS_Open_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   -fno-strict-aliasing
common_GCC_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
STM32F4xx_Peripheral_Drivers_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
Lib_Ring_Buffer_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
Lib_crc_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
STM32F4xx_Peripheral_Libraries_CFLAGS           := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4    -mlittle-endian                   
App_WiFi_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Platform_LSRSTERLING_00950_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
ThreadX_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
NetX_Duo_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
WICED_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_SPI_Slave_Library_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_SPI_Flash_Library_LSRSTERLING_00950_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_GPIO_button_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
WWD_ThreadX_Interface_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
WICED_ThreadX_Interface_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
WWD_NetX_Duo_Interface_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
WICED_NetX_Duo_Interface_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
WWD_for_SDIO_ThreadX_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Supplicant_BESL_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Fortuna_PostgreSQL_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_DNS_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_Wiced_RO_FS_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
STM32F4xx_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_tracex_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_DHCP_Server_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_Linked_List_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_TLV_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_base64_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
mbedTLS_Open_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
common_GCC_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
STM32F4xx_Peripheral_Drivers_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_Ring_Buffer_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
Lib_crc_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
STM32F4xx_Peripheral_Libraries_CXXFLAGS         := -DWICED_VERSION=\"Wiced_006.000.001.0005\" -DBUS=\"$(BUS)\" -Ibuild/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/resources/ -DPLATFORM=\"$(PLATFORM)\" -DAPPS_CHIP_REVISION=\"$(APPS_CHIP_REVISION)\"             -mthumb -mcpu=cortex-m4  -mlittle-endian                   
App_WiFi_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Platform_LSRSTERLING_00950_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
ThreadX_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
NetX_Duo_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
WICED_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_SPI_Slave_Library_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_SPI_Flash_Library_LSRSTERLING_00950_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_GPIO_button_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
WWD_ThreadX_Interface_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
WICED_ThreadX_Interface_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
WWD_NetX_Duo_Interface_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
WICED_NetX_Duo_Interface_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
WWD_for_SDIO_ThreadX_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Supplicant_BESL_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Fortuna_PostgreSQL_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_DNS_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_Wiced_RO_FS_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
STM32F4xx_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_tracex_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_DHCP_Server_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_Linked_List_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_TLV_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_base64_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
mbedTLS_Open_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
common_GCC_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
STM32F4xx_Peripheral_Drivers_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_Ring_Buffer_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
Lib_crc_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
STM32F4xx_Peripheral_Libraries_ASMFLAGS         :=             -mcpu=cortex-m4 -mfpu=softvfp  -mlittle-endian                   
App_WiFi_RESOURCES        := 
Platform_LSRSTERLING_00950_RESOURCES        := 
ThreadX_RESOURCES        := 
NetX_Duo_RESOURCES        := 
WICED_RESOURCES        := 
Lib_SPI_Slave_Library_RESOURCES        := 
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_RESOURCES        := 
Lib_SPI_Flash_Library_LSRSTERLING_00950_RESOURCES        := 
Lib_GPIO_button_RESOURCES        := 
WWD_ThreadX_Interface_RESOURCES        := 
WICED_ThreadX_Interface_RESOURCES        := 
WWD_NetX_Duo_Interface_RESOURCES        := 
WICED_NetX_Duo_Interface_RESOURCES        := 
WWD_for_SDIO_ThreadX_RESOURCES        := resources/firmware/4343W/4343WA1.bin resources/firmware/4343W/4343WA1.clm_blob
Supplicant_BESL_RESOURCES        := 
Fortuna_PostgreSQL_RESOURCES        := 
Lib_DNS_RESOURCES        := 
Lib_Wiced_RO_FS_RESOURCES        := 
STM32F4xx_RESOURCES        := 
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_RESOURCES        := 
Lib_tracex_RESOURCES        := 
Lib_DHCP_Server_RESOURCES        := 
Lib_Linked_List_RESOURCES        := 
Lib_TLV_RESOURCES        := 
Lib_base64_RESOURCES        := 
mbedTLS_Open_RESOURCES        := 
common_GCC_RESOURCES        := 
STM32F4xx_Peripheral_Drivers_RESOURCES        := 
Lib_Ring_Buffer_RESOURCES        := 
Lib_crc_RESOURCES        := 
STM32F4xx_Peripheral_Libraries_RESOURCES        := 
App_WiFi_MAKEFILE         := ./apps/UniBo/AppWiFi/AppWiFi.mk
Platform_LSRSTERLING_00950_MAKEFILE         := ./platforms/LSRSTERLING_00950/LSRSTERLING_00950.mk
ThreadX_MAKEFILE         := ./WICED/RTOS/ThreadX/ThreadX.mk
NetX_Duo_MAKEFILE         := ./WICED/network/NetX_Duo/NetX_Duo.mk
WICED_MAKEFILE         := ././WICED/WICED.mk
Lib_SPI_Slave_Library_MAKEFILE         := ././libraries/drivers/spi_slave/spi_slave.mk
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_MAKEFILE         := ././libraries/drivers/bluetooth/low_energy/low_energy.mk
Lib_SPI_Flash_Library_LSRSTERLING_00950_MAKEFILE         := ./libraries/drivers/spi_flash/spi_flash.mk
Lib_GPIO_button_MAKEFILE         := ./libraries/inputs/gpio_button/gpio_button.mk
WWD_ThreadX_Interface_MAKEFILE         := ././WICED/RTOS/ThreadX/WWD/WWD.mk
WICED_ThreadX_Interface_MAKEFILE         := ././WICED/RTOS/ThreadX/WICED/WICED.mk
WWD_NetX_Duo_Interface_MAKEFILE         := ././WICED/network/NetX_Duo/WWD/WWD.mk
WICED_NetX_Duo_Interface_MAKEFILE         := ././WICED/network/NetX_Duo/WICED/WICED.mk
WWD_for_SDIO_ThreadX_MAKEFILE         := ././WICED/WWD/WWD.mk
Supplicant_BESL_MAKEFILE         := ././WICED/security/BESL/BESL.mk
Fortuna_PostgreSQL_MAKEFILE         := ././WICED/security/PostgreSQL/PostgreSQL.mk
Lib_DNS_MAKEFILE         := ./libraries/protocols/DNS/DNS.mk
Lib_Wiced_RO_FS_MAKEFILE         := ./libraries/filesystems/wicedfs/wicedfs.mk
STM32F4xx_MAKEFILE         := ././WICED/platform/MCU/STM32F4xx/STM32F4xx.mk
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_MAKEFILE         := ././libraries/drivers/bluetooth/firmware/firmware.mk
Lib_tracex_MAKEFILE         := ./libraries/test/TraceX/TraceX.mk
Lib_DHCP_Server_MAKEFILE         := ./libraries/daemons/DHCP_server/DHCP_server.mk
Lib_Linked_List_MAKEFILE         := ./libraries/utilities/linked_list/linked_list.mk
Lib_TLV_MAKEFILE         := ./libraries/utilities/TLV/TLV.mk
Lib_base64_MAKEFILE         := ./libraries/utilities/base64/base64.mk
mbedTLS_Open_MAKEFILE         := ./WICED/security/BESL/mbedtls_open/mbedtls_open.mk
common_GCC_MAKEFILE         := ./WICED/platform/GCC/GCC.mk
STM32F4xx_Peripheral_Drivers_MAKEFILE         := ./WICED/platform/MCU/STM32F4xx/peripherals/peripherals.mk
Lib_Ring_Buffer_MAKEFILE         := ./libraries/utilities/ring_buffer/ring_buffer.mk
Lib_crc_MAKEFILE         := ./libraries/utilities/crc/crc.mk
STM32F4xx_Peripheral_Libraries_MAKEFILE         := ./WICED/platform/MCU/STM32F4xx/peripherals/libraries/libraries.mk
App_WiFi_PRE_BUILD_TARGETS:= 
Platform_LSRSTERLING_00950_PRE_BUILD_TARGETS:= 
ThreadX_PRE_BUILD_TARGETS:= 
NetX_Duo_PRE_BUILD_TARGETS:= 
WICED_PRE_BUILD_TARGETS:= 
Lib_SPI_Slave_Library_PRE_BUILD_TARGETS:= 
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_PRE_BUILD_TARGETS:= 
Lib_SPI_Flash_Library_LSRSTERLING_00950_PRE_BUILD_TARGETS:= 
Lib_GPIO_button_PRE_BUILD_TARGETS:= 
WWD_ThreadX_Interface_PRE_BUILD_TARGETS:= 
WICED_ThreadX_Interface_PRE_BUILD_TARGETS:= 
WWD_NetX_Duo_Interface_PRE_BUILD_TARGETS:= 
WICED_NetX_Duo_Interface_PRE_BUILD_TARGETS:= 
WWD_for_SDIO_ThreadX_PRE_BUILD_TARGETS:= 
Supplicant_BESL_PRE_BUILD_TARGETS:= 
Fortuna_PostgreSQL_PRE_BUILD_TARGETS:= 
Lib_DNS_PRE_BUILD_TARGETS:= 
Lib_Wiced_RO_FS_PRE_BUILD_TARGETS:= 
STM32F4xx_PRE_BUILD_TARGETS:= 
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_PRE_BUILD_TARGETS:= 
Lib_tracex_PRE_BUILD_TARGETS:= 
Lib_DHCP_Server_PRE_BUILD_TARGETS:= 
Lib_Linked_List_PRE_BUILD_TARGETS:= 
Lib_TLV_PRE_BUILD_TARGETS:= 
Lib_base64_PRE_BUILD_TARGETS:= 
mbedTLS_Open_PRE_BUILD_TARGETS:= 
common_GCC_PRE_BUILD_TARGETS:= 
STM32F4xx_Peripheral_Drivers_PRE_BUILD_TARGETS:= 
Lib_Ring_Buffer_PRE_BUILD_TARGETS:= 
Lib_crc_PRE_BUILD_TARGETS:= 
STM32F4xx_Peripheral_Libraries_PRE_BUILD_TARGETS:= 
App_WiFi_PREBUILT_LIBRARY := 
Platform_LSRSTERLING_00950_PREBUILT_LIBRARY := 
ThreadX_PREBUILT_LIBRARY := ./WICED/RTOS/ThreadX/ThreadX.ARM_CM4.debug.a
NetX_Duo_PREBUILT_LIBRARY := ./WICED/network/NetX_Duo/NetX_Duo.ThreadX.ARM_CM4.debug.a
WICED_PREBUILT_LIBRARY := 
Lib_SPI_Slave_Library_PREBUILT_LIBRARY := 
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_PREBUILT_LIBRARY := ././libraries/drivers/bluetooth/low_energy/../bluetooth_low_energy.ThreadX.NetX_Duo.ARM_CM4.release.a
Lib_SPI_Flash_Library_LSRSTERLING_00950_PREBUILT_LIBRARY := 
Lib_GPIO_button_PREBUILT_LIBRARY := 
WWD_ThreadX_Interface_PREBUILT_LIBRARY := 
WICED_ThreadX_Interface_PREBUILT_LIBRARY := 
WWD_NetX_Duo_Interface_PREBUILT_LIBRARY := 
WICED_NetX_Duo_Interface_PREBUILT_LIBRARY := 
WWD_for_SDIO_ThreadX_PREBUILT_LIBRARY := 
Supplicant_BESL_PREBUILT_LIBRARY := ././WICED/security/BESL/BESL_generic.ARM_CM4.release.a
Fortuna_PostgreSQL_PREBUILT_LIBRARY := ././WICED/security/PostgreSQL/PostgreSQL.ARM_CM4.release.a
Lib_DNS_PREBUILT_LIBRARY := 
Lib_Wiced_RO_FS_PREBUILT_LIBRARY := 
STM32F4xx_PREBUILT_LIBRARY := 
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_PREBUILT_LIBRARY := 
Lib_tracex_PREBUILT_LIBRARY := 
Lib_DHCP_Server_PREBUILT_LIBRARY := 
Lib_Linked_List_PREBUILT_LIBRARY := 
Lib_TLV_PREBUILT_LIBRARY := 
Lib_base64_PREBUILT_LIBRARY := 
mbedTLS_Open_PREBUILT_LIBRARY := 
common_GCC_PREBUILT_LIBRARY := 
STM32F4xx_Peripheral_Drivers_PREBUILT_LIBRARY := 
Lib_Ring_Buffer_PREBUILT_LIBRARY := 
Lib_crc_PREBUILT_LIBRARY := 
STM32F4xx_Peripheral_Libraries_PREBUILT_LIBRARY := 
App_WiFi_BUILD_TYPE       := debug
Platform_LSRSTERLING_00950_BUILD_TYPE       := debug
ThreadX_BUILD_TYPE       := debug
NetX_Duo_BUILD_TYPE       := debug
WICED_BUILD_TYPE       := debug
Lib_SPI_Slave_Library_BUILD_TYPE       := debug
Lib_Bluetooth_Embedded_Low_Energy_Stack_for_WICED_BUILD_TYPE       := debug
Lib_SPI_Flash_Library_LSRSTERLING_00950_BUILD_TYPE       := debug
Lib_GPIO_button_BUILD_TYPE       := debug
WWD_ThreadX_Interface_BUILD_TYPE       := debug
WICED_ThreadX_Interface_BUILD_TYPE       := debug
WWD_NetX_Duo_Interface_BUILD_TYPE       := debug
WICED_NetX_Duo_Interface_BUILD_TYPE       := debug
WWD_for_SDIO_ThreadX_BUILD_TYPE       := debug
Supplicant_BESL_BUILD_TYPE       := debug
Fortuna_PostgreSQL_BUILD_TYPE       := debug
Lib_DNS_BUILD_TYPE       := debug
Lib_Wiced_RO_FS_BUILD_TYPE       := debug
STM32F4xx_BUILD_TYPE       := debug
Lib_WICED_Bluetooth_Firmware_Driver_for_BCM43438A1_BUILD_TYPE       := debug
Lib_tracex_BUILD_TYPE       := debug
Lib_DHCP_Server_BUILD_TYPE       := debug
Lib_Linked_List_BUILD_TYPE       := debug
Lib_TLV_BUILD_TYPE       := debug
Lib_base64_BUILD_TYPE       := debug
mbedTLS_Open_BUILD_TYPE       := release
common_GCC_BUILD_TYPE       := debug
STM32F4xx_Peripheral_Drivers_BUILD_TYPE       := debug
Lib_Ring_Buffer_BUILD_TYPE       := debug
Lib_crc_BUILD_TYPE       := debug
STM32F4xx_Peripheral_Libraries_BUILD_TYPE       := debug
BOARD_REVISION   := 
WICED_SDK_UNIT_TEST_SOURCES   :=          ././WICED/internal/unit/wiced_unit.cpp                          ./libraries/filesystems/wicedfs/src/unit/wicedfs_unit_images.c ./libraries/filesystems/wicedfs/src/unit/wicedfs_unit.cpp        ./libraries/daemons/DHCP_server/unit/dhcp_server_unit.cpp ./libraries/daemons/DHCP_server/unit/dhcp_server_test_content.c                  
APP_WWD_ONLY              := 
USES_BOOTLOADER_OTA       := 1
NODCT                     := 
ALL_RESOURCES             :=   resources/firmware/4343W/4343WA1.bin resources/firmware/4343W/4343WA1.clm_blob
RESOURCES_LOCATION        := RESOURCES_IN_WICEDFS
INTERNAL_MEMORY_RESOURCES := 
EXTRA_TARGET_MAKEFILES :=    ./tools/makefiles/standard_platform_targets.mk
EXTRA_PLATFORM_MAKEFILES := 
APPS_LUT_HEADER_LOC := 0x0000
APPS_START_SECTOR := 1 
FR_APP := 
OTA2_FAILSAFE_APP := 
OTA_APP := 
DCT_IMAGE := 
FILESYSTEM_IMAGE := build/UniBo.AppWiFi-LSRSTERLING_00950-ThreadX-NetX_Duo-SDIO-debug/filesystem.bin 
WIFI_FIRMWARE :=  
APP0 :=  
APP1 :=  
APP2 :=  
FR_APP_SECURE := 
OTA_APP_SECURE := 
FAILSAFE_APP_SECURE := 
WICED_ROM_SYMBOL_LIST_FILE := 
WICED_SDK_CHIP_SPECIFIC_SCRIPT :=                               
WICED_SDK_CONVERTER_OUTPUT_FILE :=                               
WICED_SDK_FINAL_OUTPUT_FILE :=                               
WICED_RAM_STUB_LIST_FILE := 
DCT_IMAGE_SECURE := 
FILESYSTEM_IMAGE_SECURE := 
WIFI_FIRMWARE_SECURE := 
APP0_SECURE := 
APP1_SECURE := 
APP2_SECURE := 
