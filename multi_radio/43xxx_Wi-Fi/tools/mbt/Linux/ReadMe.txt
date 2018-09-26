Manufacturing Bluetooth Test Tool

Overview

The manufacturing Bluetooth test tool (MBT) is used to test and verify the RF
performance of the Cypress Bluetooth Classic and Bluetooth Low Energy (BLE) devices.
Each test sends an HCI command to the device and then waits for an HCI Command
Complete event from the device.

To run the tests:
  1. If using a combo (WiFi & BT) eval board, you must run the bt_mfg_test
     sample app. This app configures the BT device to run in the HCI mode and
     the HCI commands and events are passed through the STM mcu via the FTDI
     serial device driver.

  2. Plug the eval board into the computer and note the serial devices under
     /dev that get assigned to the eval board. Two will be listed, e.g. ttyUSB0
     and ttyUSB1. The ttyUSB1 is the HCI UART interface you will want mbt to
     interface to. If the serial devices are not listed when plugging in the
     eval board, refer to the following wiced community thread:
     https://community.cypress.com/message/6034#6034

  3. Update the permissions on the serial device driver by executint the below
     command:
     sudo chmod 777 /dev/ttyUSB1

Note: All examples in this document use ttyUSB1 as the port assigned to the
eval board by the linux machine. Replace “ttyUSB1” in each test example with
the actual port assigned to the eval board under test

Reset Test

This test verifies that the device is correctly configured and connected to
the linux machine.

Usage: mbt reset /dev/ttyUSBx

The example below sends HCI_Reset command to the device and processes the HCI
Command Complete event (BLUETOOTH SPECIFICATION Version 4.1 [Vol 2], Section
7.3.2 for details).

Wiced-SDK/tools/mbt/Linux/Release$ ./mbt reset /dev/ttyUSB1
Opened port /dev/ttyUSB1
writing
01 03 0c 00
received 7
04 0e 04 01 03 0c 00
exiting.

The last byte of the HCI Command Complete event is the operation status, where
0 signifies success.


LE Receiver Test

This test configures the BT to receive reference packets at a fixed
interval. External test equipment should be used to generate the reference
packets.

The channel frequency on which the device listens for the packets is passed as
a parameter in MHz. BLE devices use 40 channels, each of which is 2 MHz wide. Channel
0 maps to 2402 MHz and Channel 39 maps to 2480 MHz (see BLUETOOTH
SPECIFICATION Version 4.1 [Vol 2], Section 7.8.28 for details).

Usage: mbt le_receiver_test /dev/ttyUSBx <rx_channel>
where:
    rx_channel = (F - 2402) / 2
    Range: 0 - 39. Frequency Range : 2402 MHz to 2480 MHz

The example below starts the LE receiver test on Channel 2 (2406 MHz).

Wiced-SDK/tools/mbt/Linux/Release$ ./mbt le_receiver_test /dev/ttyUSB1 2
Opened port /dev/ttyUSB1
writing
01 1d 20 01 02
received 7
04 0e 04 01 1d 20 00
exiting.


The last byte of the HCI Command Complete event is the operation status,
where 0 signifies success. Use mbt le_test_end /dev/ttyUSBx to complete
the test and print the number of received packets.

Note: This test will fail if the device is running another test: use
le_test_end or reset to put the BT in idle state before running this
test.


LE Transmitter Test

The LE Transmitter Test configures the BT to send test packets at a
fixed interval. External test equipment may be used to receive and analyze
the reference packets.

The frequency on which the BT transmits the packets  is passed as a
parameter. BLE devices use 40 channels, each of which is 2 MHz wide. Channel 0
maps to 2402 MHz and Channel 39 maps to 2480 MHz.

The other two parameters specify the length of the test data and the data
pattern to be used (see BLUETOOTH SPECIFICATION Version 4.1 [Vol 2], Section
7.8.29 for details).

Usage: mbt le_transmitter_test /dev/ttyUSBx <tx_channel> <data_length> <packet_payload>
where:
    tx_channel = (F - 2402) / 2
    Range: 0 - 39. Frequency Range : 2402 MHz to 2480 MHz

    data_length = 0–37

    data_pattern = 0–7
        0 = Pseudo-random bit sequence 9
        1 = Pattern of alternating bits: 11110000
        2 = Pattern of alternating bits: 10101010
        3 = Pseudo-random bit sequence 15
        4 = Pattern of all 1s
        5 = Pattern of all 0s
        6 = Pattern of alternating bits: 00001111
        7 = Pattern of alternating bits: 0101

The example below starts the test and instructs the device to transmit packets
on Channel 2 (2406 MHz), with a 10-byte payload of all ones (1s).

Wiced-SDK/tools/mbt/Linux/Release$ ./mbt le_transmitter_test /dev/ttyUSB1 2 10 4
Opened port /dev/ttyUSB1
writing
01 1e 20 03 02 0a 04
received 7
04 0e 04 01 1e 20 00
exiting.

The last byte of the HCI Command Complete event is the status of the operation,
where 0 signifies the success.  Use mbt le_test_end /dev/ttyUSBx to complete the test.

Note: This test will fail if the device is running another test: use le_test_end
or reset to put the BT in idle state before running this test.


LE Test End

This command stops the LE Transmitter or LE Receiver Test that is in progress
on the BT.  The number of packets received during the test is reported
by the device and printed out. The value will always be zero (0) if the LE
Transmitter Test was active (see BLUETOOTH SPECIFICATION Version 4.1 [Vol 2],
Section 7.8.30 for details).

Usage: mbt le_test_end /dev/ttyUSBx

The example below stops the active test.

Wiced-SDK/tools/mbt/Linux/Release$ ./mbt le_test_end  /dev/ttyUSB1
Opened port /dev/ttyUSB1
writing
01 1f 20 00
received 9
04 0e 06 01 1f 20 00 00 00
Success num_packets_received 0
exiting.


Continuous Transmit Test

Note: Unlike the LE tests, this test uses 79 frequencies, each 1 MHz wide.

This test configures the BT to turn the carrier ON or OFF. When the
carrier is ON the device transmits the carrier which specified modulation mode
and type on the specified frequency at a specified power level.


The modulation mode, modulation type, frequency, and power level to be used by
the BT are passed as parameters.

Usage: mbt tx_frequency_arm /dev/ttyUSBx <carrier on/off> <tx_frequency> <tx_power>
where:

    carrier on/off:
        1 = carrier ON
        0 = carrier OFF
    tx_frequency = (2402 – 2480) transmit frequency, in MHz
    tx_power = (–25 to +3) transmit power, in dBm

The example below turns the carrier ON and instructs the BT to transmit on 2402 MHz at 3 dBm.

Wiced-SDK/tools/mbt/Linux/Release$ ./mbt tx_frequency_arm /dev/ttyUSB1 1 2402 3
Opened port /dev/ttyUSB1
writing
01 14 fc 07 00 02 00 00 08 03 00
received 7
04 0e 04 01 14 fc 00
exiting.

To stop the test, send the command a second time with the carrier on/off parameter set to zero (0).
Other parameters will be ignored.

Wiced-SDK/tools/mbt/Linux/Release$ ./mbt tx_frequency_arm /dev/ttyUSB1 0 2402 0
Opened port /dev/ttyUSB1
writing
01 14 fc 07 01 02 00 00 00 00 00
received 7
04 0e 04 01 14 fc 00
exiting.


Connectionless_DUT_Loopback_Test

The basic concept for this test is derived from loopback mode. The tester will
transmit a specific packet to the DUT which is retrasmitted. This structure
will enable the tester to analyse both tx and rx characteristics.

Usage: mbt connectionless_dut_loopback_mode COMx

When executed, the parameters must be entered in hexa-decimal format.[0xXX]
BD-Address should be of 6 bytes. No_of_tests must a value greater than  zero
and less than 16.

The example below takes one test to perform.

WICED-SDK\Tools\mbt\win32>mbt connectionless_dut_loopback_mode /dev/ttyUSBx
BD-Address : 0x00 0x00 0x00 0x01 0x02 0x03
lt_addr : 0x07
no_of_tests: 0x01
retry_offset : 0x01
no_of_packets: 0x01
tx_power: 0x00
rx_channel: 0x00
pkt_type: 0x01
retry_timeout: 0x01
test_scenario: 0x00

writing
01 54 fc 0e 03 02 01 00 00 00 07 01 00 08 00 04 
01 00 
received 9
04 0e 06 01 54 fc 00 00 00 
exiting.


