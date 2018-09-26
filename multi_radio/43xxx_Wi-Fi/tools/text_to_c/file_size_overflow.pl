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

if (! $ARGV == 2)
{
    print "Usage ./file_size_overflow.pl  Filename Max_FileSize_Bytes";
    exit;
}

my $file_size = 0;
my $max_size = 0;

# Get input file size
if (! -e $ARGV[0])
{
    $file_size = "4096";
}
else
{
    $file_size = -s $ARGV[0];
}

# Get max file size to verify if input file size overflow
# We must handle the max size given in both INTEGER format and HEX format !!
if (( index($ARGV[1], 'x') != -1 ) || (index($ARGV[1], 'X') != -1 ))
{
    $max_size = hex($ARGV[1]);
}
else
{
    $max_size = int($ARGV[1]);
}

# Return file size when overflow
# Return null blank if no overflow
if ($file_size > $max_size)
{
    print ("$file_size");
}
else
{
    print ("");
}
