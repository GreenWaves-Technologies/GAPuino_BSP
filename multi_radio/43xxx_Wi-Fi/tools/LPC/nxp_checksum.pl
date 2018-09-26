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

if (! ($ARGV[0] &  $ARGV[1]))
{
    print "Usage ./nxp_checksum.pl <readelf output text file> <elf file> <vector section name>";
    exit;
}
#command line parameters
$printall = 0;
$warn = 0;

$read_txt_elf_filename = $ARGV[0];
$binary_filename = $ARGV[1];
$vector_section_name = $ARGV[2];

$BYTE0_POS=0;
$BYTE1_POS=8;
$BYTE2_POS=16;
$BYTE3_POS=24;


##################################################
# Find vector table offset
##################################################
open INFILE, $read_txt_elf_filename or die "cant open " . $read_txt_elf_filename;
@file = <INFILE>;
close INFILE;

$file_cont = join('',@file);
#Look for "Section Headers:"
$file_cont =~ m/Section Headers:.*\s$vector_section_name\s*PROGBITS\s*\S{8}\s\S{6}\s/s;
$section_table =$&;
#print sprintf("%s\n", $section_table);

#Isolate vector table entry
$section_table =~ m/\s$vector_section_name\s*PROGBITS\s*\S{8}\s\S{6}\s/s;
$vectors_line =$&;

#Find vector table offset
if($vectors_line =~ m/\s(\d|[A-F]){6}\s/i)
{
    $vector_offset =$&;
    #strip the whitespace
    $vector_offset=~ m/(\d|[A-F]){6}/i;
    $vector_offset =hex($&);
    $vector_offset=sprintf("%d",$vector_offset);
}
else
{
     print "ERROR: Could not find vector table offset";
     exit;
}

##################################################
# Calculate and insert checksum
##################################################
#open the file
open INFILE,'+<:raw', $binary_filename or die "cant open " . $binary_filename;
binmode(INFILE) || die "can't binmode $binary_filename";
#calculate checksum
seek INFILE, $vector_offset, SEEK_CUR or die "could not seek: $!";

#Read the first 7 interrupt vectors (@4 bytes each=28 bytes total)
for ( my $i = 0; $i < 28; $i++ )
{
          read INFILE, $data_array[$i], 1 or die "could not read: $!";
}

#unpack each vector and sum with previous vector value
for ( my $i = 0; $i < 7; $i++ )
{
     $current_vector=unpack('C',@data_array[4*$i])<<$BYTE0_POS | unpack('C',@data_array[4*$i+1])<<$BYTE1_POS | unpack('C',@data_array[4*$i+2])<<$BYTE2_POS | unpack('C',@data_array[4*$i+3])<<$BYTE3_POS;
     #print sprintf("Current Vector = %x\n",$current_vector);
     $checksum+=$current_vector;
     $checksum-=2**32 if $checksum >= 2**31;
}
$checksum=(0-$checksum);
$checksum-=2**32 if $checksum >= 2**31;
print sprintf("Calculated checksum: 0x%x\r\n",$checksum);
print INFILE pack('l',$checksum);
close INFILE;

