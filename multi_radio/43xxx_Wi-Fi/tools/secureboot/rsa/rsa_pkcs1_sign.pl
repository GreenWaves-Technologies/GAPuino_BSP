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
# Input args  : sign, rsa_priave_key, inputfile, outputfile
# Assumptions : openssl is installed and path to openssl is in Windows PATH environment variable
#             : rsa_private_key.n is present in the RSA keys folder
# Calculate the RSA Signature of the inputfile
# outputfile = inputfile + RSA signature + RSA public key

my ($sign, $rsa_private_key, $infile, $outfile) = @ARGV;

# For Debugging
# foreach $key (keys(%ENV)) {
# printf("%-10.10s: $ENV{$key}\n", $key);
# }

local $ENV{PATH} = "$ENV{SAVED_PATH}";

#Open infile to read
open INFILE, '<', $infile or die $!;
binmode INFILE;

my $tmp_file = 'img_temp';
open TMPFILE, '>', $tmp_file or die $!;
binmode TMPFILE;

#Copy input file to img_temp
while(<INFILE>)
{
    print TMPFILE $_;
}

close TMPFILE;

my $filesize = -s  "img_temp";
# Pad tmp_file to make its size % 16
$residue = (16 - ($filesize % 16)) & 0xf;
open TMPFILE, '>>', $tmp_file or die $!;
binmode TMPFILE;

while($residue > 0)
{
    print TMPFILE "\0";
    $residue -= 1;
}

close TMPFILE;
close INFILE;
#Calculate sha256 hash of input and sign the hash using rsa_private_key
system("openssl dgst -sha256 -sign $rsa_private_key -out sig_tmp  $tmp_file");

#Outfile = tmp_file + RSA signature + RSA public key
open TMPFILE, '<', $tmp_file or die $!;
binmode TMPFILE;
open OUTFILE, '>', $outfile or die $!;
binmode OUTFILE;
while(<TMPFILE>)
{
    print OUTFILE $_;
}
close TMPFILE;

open SIGFILE, '<', "sig_tmp" or die $!;
binmode SIGFILE;
while(<SIGFILE>)
{
    print OUTFILE $_;
}

open PUB_KEY_HASH, "<", "$rsa_private_key.n" or die $!;
binmode PUB_KEY_HASH;
while(<PUB_KEY_HASH>)
{
    print OUTFILE $_;
}

close PUB_KEY_HASH;
close SIGFILE;
close OUTFILE;
unlink sig_tmp;
unlink img_temp;
