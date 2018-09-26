#!/usr/bin/perl

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
#use File:stat;

if (! $ARGV == 8)
{
    print "Usage ./apds_dct_header.pl  FactoryResetApp OTAApp DCTImage App0 App1 App2 App3 App4";
    exit;
}

my $FR_LOCATION = 0;

print "#ifndef APPS_LOCATION_H_\n";
print "#define APPS_LOCATION_H_\n";

#print "/* $ARGV[0] $ARGV[1] $ARGV[2] $ARGV[3] $ARGV[4] $ARGV[5] $ARGV[6] $ARGV[7] */\n";

my $CURR_LOCATION = 0;
if ($ARGV[0] eq '-')
{
    $FR_SIZE = 0;
    print "#define        DCT_FR_APP_LOCATION_ID    ( NONE )\n";
}
else
{
    $FR_SIZE = -s $ARGV[0];
    print "#define        DCT_FR_APP_LOCATION_ID    ( EXTERNAL_FIXED_LOCATION )\n";
}
print "#define        DCT_FR_APP_LOCATION       ( $CURR_LOCATION )\n";
$CURR_LOCATION += $FR_SIZE;

my $DCT_LOCATION = $CURR_LOCATION;
if ($ARGV[1] eq '-')
{
    $DCT_SIZE = 0;
    print "#define        DCT_DCT_IMAGE_LOCATION_ID    ( NONE )\n";
}
else
{
    $DCT_SIZE = 25600;
    print "#define        DCT_DCT_IMAGE_LOCATION_ID    ( EXTERNAL_FIXED_LOCATION )\n";
}
print "#define        DCT_DCT_IMAGE_LOCATION       ( $CURR_LOCATION )\n";
$CURR_LOCATION += $DCT_SIZE;

my $OTA_LOCATION = $CURR_LOCATION;
if ($ARGV[2] eq '-')
{
    $OTA_SIZE = 0;
    print "#define        DCT_OTA_APP_LOCATION_ID    ( NONE )\n";
}
else
{
    $OTA_SIZE = -s $ARGV[2];
    print "#define        DCT_OTA_APP_LOCATION_ID    ( EXTERNAL_FIXED_LOCATION )\n";
}
print "#define        DCT_OTA_APP_LOCATION       ( $CURR_LOCATION )\n";
$CURR_LOCATION += $OTA_SIZE;

my $APP0_LOCATION = $CURR_LOCATION;
if ($ARGV[3] eq '-')
{
    $APP0_SIZE = 0;
    print "#define        DCT_APP0_LOCATION_ID    ( NONE )\n";
}
else
{
    $APP0_SIZE = -s $ARGV[3];
    print "#define        DCT_APP0_LOCATION_ID    ( EXTERNAL_FIXED_LOCATION )\n";
}
print "#define        DCT_APP0_LOCATION       ( $CURR_LOCATION )\n";
$CURR_LOCATION += $APP0_SIZE;

my $APP1_LOCATION = $CURR_LOCATION;
if ($ARGV[4] eq '-')
{
    $APP1_SIZE = 0;
    print "#define        DCT_APP1_LOCATION_ID    ( NONE )\n";
}
else
{
    $APP1_SIZE = -s $ARGV[4];
    print "#define        DCT_APP1_LOCATION_ID    ( EXTERNAL_FIXED_LOCATION )\n";
}
print "#define        DCT_APP1_LOCATION       ( $CURR_LOCATION )\n";
$CURR_LOCATION += $APP1_SIZE;

my $APP2_LOCATION = $CURR_LOCATION;
if ($ARGV[5] eq '-')
{
    $APP2_SIZE = 0;
    print "#define        DCT_APP2_LOCATION_ID    ( NONE )\n";
}
else
{
    $APP2_SIZE = -s $ARGV[5];
    print "#define        DCT_APP2_LOCATION_ID    ( EXTERNAL_FIXED_LOCATION )\n";
}
print "#define        DCT_APP2_LOCATION       ( $CURR_LOCATION )\n";
$CURR_LOCATION += $APP2_SIZE;

my $APP3_LOCATION = $CURR_LOCATION;
if ($ARGV[6] eq '-')
{
    $APP3_SIZE = 0;
    print "#define        DCT_APP3_LOCATION_ID    ( NONE )\n";
}
else
{
    $APP3_SIZE = -s $ARGV[6];
    print "#define        DCT_APP3_LOCATION_ID    ( EXTERNAL_FIXED_LOCATION )\n";
}
print "#define        DCT_APP3_LOCATION       ( $CURR_LOCATION )\n";
$CURR_LOCATION += $APP3_SIZE;

my $APP4_LOCATION = $CURR_LOCATION;
if ($ARGV[7] eq '-')
{
    $APP4_SIZE = 0;
    print "#define        DCT_APP4_LOCATION_ID    ( NONE )\n";
}
else
{
    $APP4_SIZE = -s $ARGV[7];
    print "#define        DCT_APP4_LOCATION_ID    ( EXTERNAL_FIXED_LOCATION )\n";
}
print "#define        DCT_APP4_LOCATION       ( $CURR_LOCATION )\n";

print "#endif /* APPS_LOCATION_H_ */\n";
