# MultiRadio module

MultiRadio is a multi standard RF platform for MCU and embedded devices. It includes an high speed WiFi with TCP and UDP capabilities and a maximum througput up to 24 Mbps, in parallel with an Bluetooth Low energy interface for low data rate and simple applications, moreover LoRaWAN connectivity allows long range communications. 
All the protocols are easily accesible by SPI interface, and throught lightweight APIs.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

The FT2232H Mini Module requires USB device drivers, available free from

```
http://www.ftdichip.com
```

which are used to make the FT2232H on the Mini Module appear as a two virtual COM ports (VCP). This
then allows the user to communicate with the USB interface via a standard PC serial emulation port. Another FTDI USB driver, the D2XX driver, can also be used with application software to directly
access the FT2232H on the Mini Module though a DLL.

GAP

```
https://github.com/pulp-platform/pulp-sdk
```

Must use
```
tag 2018.09.01 
```

Clone or download this folder into local machine


## Deployment

### Expansion board description

The Sterling-LWB STM Expansion Board is designed for use with the ST 32F411EDISCOVERY
The expansion board routes pins from the STM32F4xx MCU to interface with the Sterling-LWB module. In addition, the Expansion Board includes SPI Flash and a USB/JTAG debugger.
The board provides a single micro-USB interface for JTAG programming and access to the UART1 serial interface of the STM32F411 MCU. The JTAG interface is provided via a standard FTDI FT2232H IC with its VID and PID updated to be a WICED debugger (VID: 0x0a5c PID: 0x43fa).

The USB SWD debug interface on the Discovery board is not used. The WICED SDK assumes a JTAG debugger, which is provided on the Expansion Board.

<img src="https://github.com/GreenWaves-Technologies/GAPuino_BSP/blob/master/multi_radio/43xxx_Wi-Fi/resources/img/SWD_debug_interface.png" align="center" />

In order to use the Sterling-LWB module, the conflicting components must be removed on the 32F411EDISCOVERY Discovery board.

<img src="https://github.com/GreenWaves-Technologies/GAPuino_BSP/blob/master/multi_radio/43xxx_Wi-Fi/resources/img/Comp_rm.png" align="center" />

The Sterling-LWB expansion board requires a 1A +5VDC power supply to operate. The barrel connector (J3) is configured for 5VDC center positive. J3 powers both the Sterling-LWB expansion board and the attached Discovery Board. For access to the JTAG and USB-to-serial adapter on the Sterling-LWB expansion board, attach a Windows PC via micro-USB cable to the micro-USB port on the Sterling-LWB expansion board (J1).

<img src="https://github.com/GreenWaves-Technologies/GAPuino_BSP/blob/master/multi_radio/43xxx_Wi-Fi/resources/img/board_connection.PNG" align="center" />

### Wire connection between GAP and the ST 32F411EDISCOVERY

*Wires length must be shorter than 20 cm*

| GAPUINO | 32F411EDISCOVERY |
| --- | --- |
| SPI1_SCLK | PB13 |
| SPI1_MISO | PB14 |
| SPI1_MOSI | PB15 |
| SPI1_CS0 | PC1 |
| GPIO_A19 | PC2 |
| GPIO_A5 | PB7 |
| GND | GND |

## Sterling-LWB firmware loading

Open the Command Prompt,
Go to path

```
/multi_radio/43xxx_Wi-Fi/
```

start the .bat file
```
First_Load_ExtFlash.bat
```


## License

[![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png)](https://creativecommons.org/publicdomain/zero/1.0/)
