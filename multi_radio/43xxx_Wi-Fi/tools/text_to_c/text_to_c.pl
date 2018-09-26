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

if (! $ARGV[0] )
{
    print "Usage ./text_to_c.pl  <variable name> <text file>";
    exit;
}

# Print start of output
$variable_name = shift @ARGV;
$original_variable_name = $variable_name;
$file = shift @ARGV;

#open the file
open INFILE, "<:raw", $file or die "cant open " . $file;
@file_cont_array = <INFILE>;
close INFILE;
$file_cont = join('',@file_cont_array);


if ( ( $file =~ m/\.html$/sgi ) ||
     ( $file =~ m/\.txt$/sgi ) )
{
  while ( $file_cont =~ s/^(.*?)\r?\n?\<WICED\:section\s+suffix=\"(\S+)\"\s*\/\>\r?\n?(.*)$/$3/sgi )
  {
    my $substr = $1;
    my $variable_suffix = $2;
    print "const char ${variable_name}[" . (length( $substr )+1) . "] = ";
    while ( $substr =~ s/^(.*?\n)(.*)$/$2/sgi )
    {
        print "\"" . escape_string( $1 ) . "\" \\\n";
    }
    print "\"" . escape_string( $substr ) . "\";\n\n";
    $variable_name = $original_variable_name . $variable_suffix;
  }
}



print "const char ${variable_name}[" . (length( $file_cont )+1) . "] = ";
while ( $file_cont =~ s/^(.*?\n)(.*)$/$2/sgi )
{
    print "\"" . escape_string( $1 ) . "\" \\\n";
}
print "\"" . escape_string( $file_cont ) . "\";\n";




sub escape_string( $escstring )
{
  my $escstring = shift;
  # Escape characters for C string
  $escstring =~ s/\\/\\\\/sgi; # backslash
  $escstring =~ s/\a/\\a/sgi;  # bell
  $escstring =~ s/\x8/\\b/sgi; # backspace
  $escstring =~ s/\f/\\f/sgi;  # formfeed
  $escstring =~ s/\n/\\n/sgi;  # linefeed
  $escstring =~ s/\r/\\r/sgi;  # carriage return
  $escstring =~ s/\t/\\t/sgi;  # tab
  $escstring =~ s/\xB/\\v/sgi; # vertical tab
  $escstring =~ s/\'/\\'/sgi;  # single quote
  $escstring =~ s/\"/\\"/sgi;  # double quote
  return $escstring;
}
