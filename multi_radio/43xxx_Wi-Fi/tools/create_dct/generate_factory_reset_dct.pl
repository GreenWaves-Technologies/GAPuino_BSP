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


my %value_table = ();
my %input = "";
my $actually_read = 0;
my $fd_in_size = 0;

print STDERR "\nCypress generate_factory_reset_dct.pl $ARGV[0] $ARGV[1]\n";

# Read in ARGV[0]
open(my $fd_in, "<", $ARGV[0])
    or die "Can't open $ARGV[0] !";
seek($fd_in, 0, 2);
$fd_in_size = tell($fd_in);
seek($fd_in, 0, 0);
$actually_read = read($fd_in, $file_data, $fd_in_size, 0);
close ($fd_in);

#print STDERR "\nsize:$fd_in_size\nBytes read:$actually_read\nfile_data:\n$file_data\n";

# break up lines in file_data into input
my $start = 0;
my $end = 0;
while (($start < $fd_in_size) and ($end >= 0))
{
    $end = index( $file_data, "\n", $start);
    my $temp_str = substr($file_data, $start, $end - $start + 1);
    $input = $input.$temp_str;
    $start = $end + 1;
}

#print STDERR "\nsize:$fd_in_size\nBytes read:$actually_read\nINPUT:\n$input @input\n";

# Extract all the matching pairs
while ($input =~ m/^(\w+?)\s*=(.*?)(?:\Z|(?=\n^\w))/smg)
{
   $value_table{$1} = $2;
}

# Open the source factory reset file and read content
open FACTORY_RESET_FILE, $ARGV[1] or die "generate_factory_reset_dct.pl:: Couldn't open file ($ARGV[1]): $!";
@file = <FACTORY_RESET_FILE>;
close FACTORY_RESET_FILE;

# Print out new version with dynamic content replaced
$file_content = join('',@file);
$file_content =~ s/_DYNAMIC_(\w*)/$value_table{$1}/g;
print "$file_content";
