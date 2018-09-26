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
    print "Usage ./map_parse_iar.pl [-a] [-w] <map file filename>";
    print "           -a = show all sections";
    print "           -w = show more warnings";
    exit;
}

#command line parameters
$printall = 0;
$warn = 0;
foreach (@ARGV)
{
    if ( $_ eq "-a" )
    {
        $printall = 1;
    }
    elsif ( $_ eq "-w" )
    {
        $warn = 1;
    }
    else
    {
        $filename = $_;
    }
}

#open the file
open my $INFILE, $filename or die "cant open " . $filename;
my $file_cont = do { local $/; <$INFILE> };
close $INFILE;

# grab just the module summary section
$file_cont =~ s/.*MODULE SUMMARY(.*)ENTRY LIST.*/$1/sgi;

# The first column of the module summary table is variable size. Determine the width from the table header
my $first_col_gap_width = $file_cont;
$first_col_gap_width =~ s/.*Module([ ]+)ro code.*/$1/sgi;
$first_col_gap_width = length( $first_col_gap_width );



my %module_list;

# Loop for each module : look for :
# <Module_name>.a
# followed by some text
# followed by "Total:"
# followed by a number of spaces calculated in first_col_gap_width above
# followed by 3 fields of digits or spaces
while ( $file_cont =~ m/\n(\S+\.a)\:(.*?)Total\:[ ]{0,$first_col_gap_width}([\d ]{0,9})([\d ]{0,9})([\d ]{0,9})/sgi )
{
    my $library = $1;
    my $obj_raw_list = $2;
    my $ro_code = $3;
    my $ro_data = $4;
    my $rw_data = $5;
    my @obj_list;


    # remove spaces separating thousands
    $ro_code =~ s/ //sgi;
    $ro_data =~ s/ //sgi;
    $rw_data =~ s/ //sgi;

    # Some fields are blank - change to zeros
    if ( $ro_code eq "" )
    {
        $ro_code = 0;
    }
    if ( $ro_data eq "" )
    {
        $ro_data = 0;
    }
    if ( $rw_data eq "" )
    {
        $rw_data = 0;
    }

    # Create up object list
    while (    $obj_raw_list =~ m/(\S+\.o)/sgi )
    {
        push @obj_list, $1;
    }

    # Insert module into list if it doesn't exist
    # otherwise add the module sizes to the exising sizes
    if ( exists $module_list{ get_desc( $library ) } )
    {
        $module_list{ get_desc( $library ) }{ ro_code } += $ro_code;
        $module_list{ get_desc( $library ) }{ ro_data } += $ro_data;
        $module_list{ get_desc( $library ) }{ rw_data } += $rw_data;
    }
    else
    {
        $module_list{ get_desc( $library ) } = {  ro_code => $ro_code, ro_data => $ro_data, rw_data => $rw_data, };
    }

}


# Print the table

my $total_ro_code = 0;
my $total_ro_data = 0;
my $total_rw_data = 0;

print "----------------------------------|---------|---------|---------|\n";
print "                                  |         |  Const  |  Var    |\n";
print "              Module              |  Code   |  Data   |  Data   |\n";
print "----------------------------------+---------+---------+---------|\n";
foreach $module (sort {"\L$a" cmp "\L$b"} keys %module_list)
{
    print sprintf("%-34.34s| %7d | %7d | %7d |\n", $module, $module_list{$module}{ro_code},  $module_list{$module}{ro_data},$module_list{$module}{rw_data});
    $total_ro_code += $module_list{$module}{ro_code};
    $total_ro_data += $module_list{$module}{ro_data};
    $total_rw_data += $module_list{$module}{rw_data};

}
print         "----------------------------------+---------+---------+---------|\n";
print sprintf("TOTAL (bytes)                     | %7d | %7d | %7d |\n", $total_ro_code,  $total_ro_data, $total_rw_data);
print         "----------------------------------|---------|---------|---------|\n";
print "\n";



exit(0);


# Get a generic module description from the module filename
sub get_desc
{
    my $modulefn = shift;
    my $module = "Other ($modulefn)";

    if ( $modulefn =~ m/App_\S+\.a/sgi )
    {
        $module = "App";
    }
    elsif ( $modulefn =~ m/vector_table/sgi ||
            $modulefn =~ m/interrupt_handlers_GCC\.o/sgi ||
            $modulefn =~ m/HardFault_handler\.o/sgi )
    {
        $module = "Interrupt Vectors";
    }
    elsif ( $modulefn =~ m/ThreadX\.a/sgi ||
            $modulefn =~ m/ThreadX-\d.\d.\w+\.a/sgi )
    {
        $module = "ThreadX";
    }
    elsif ( $modulefn =~ m/SPI_Flash_Library/sgi )
    {
        $module = "SPI Flash Library";
    }
    elsif ( $modulefn =~ m/resources\.a/sgi )
    {
        $module = "resources";
    }
    elsif ( $modulefn =~ m/Wiced_Wifi_image\.a/sgi )
    {
        $module = "WLAN firmware";
    }
    elsif ( $modulefn =~ m/STM32F1xx_lib\.a/sgi ||
            $modulefn =~ m/STM32F1xx_Drv\.a/sgi ||
            $modulefn =~ m/STM32F2xx_?D?r?v?\.a/sgi ||
            $modulefn =~ m/STM32F4xx_?D?r?v?\.a/sgi ||
            $modulefn =~ m/SAM4S_?D?r?v?\.a/sgi ||
            $modulefn =~ m/K60_?D?r?v?\.a/sgi )
    {
        $module = "Host MCU-family library";
    }
    elsif ( $modulefn =~ m/dl7M_tln\.a/sgi ||
            $modulefn =~ m/rt7M_tl\.a/sgi ||
            $modulefn =~ m/m7M_tl\.a/sgi )
    {
        $module = "IAR libc";
    }
    elsif ( $modulefn =~ m/Wiced_(NetX|NetX_Duo|LwIP)_Interface\.a/sgi )
    {
        $module = "Networking";
    }
    elsif ( $modulefn =~ m/WICED\.a/sgi ||
            $modulefn =~ m/Wiced_(ThreadX|FreeRTOS)_Interface\.a/sgi ||
            $modulefn =~ m/Wiced_\w+\_Interface_\w+\.a/sgi ||
            $modulefn =~ m/Wiced_Network_\w+_\w+\.a/sgi )
    {
        $module = "WICED";
    }
    elsif ( $modulefn =~ m/\w+_Interface_(SPI|SDIO)\.a/sgi ||
            $modulefn =~ m/WWD_for_(SPI|SDIO)_\w+\.a/sgi ||
            $modulefn =~ m/WWD_\w+\_Interface\.a/sgi ||
            $modulefn =~ m/WWD_\w+\_Interface_\w+\.a/sgi )
    {
        $module = "WWD";
    }
    elsif ( $modulefn =~ m/crt0_iar\.o/sgi ||
            $modulefn =~ m/Platform_\S+\.a/sgi )
    {
        $module = "platform";
    }
    elsif ( $modulefn =~ m/Lib_(.+)\.a/sgi )
    {
        $module = $1;
    }
    elsif ( $modulefn =~ m/Supplicant_besl\.a/sgi ||
            $modulefn =~ m/Supplicant_besl.\w+\.a/sgi ||
            $modulefn =~ m/BESL\.\w+\.\w+\.a/sgi )
    {
        $module = "Supplicant - BESL";
    }
    elsif ( $modulefn =~ m/.*app_header\.o/sgi )
    {
        $module = "Bootloader";
    }
    elsif ( $modulefn =~ m/gedday\.\w+\.\w+\.\w+\.\w+\.a/sgi )
    {
        $module = "Gedday";
    }
    elsif ( $modulefn =~ m/NetX\.a/sgi ||
         $modulefn =~ m/NetX.\w+\.a/sgi )
    {
        $module = "NetX";
    }
    elsif ( $modulefn =~ m/NetX_Duo\.a/sgi ||
            $modulefn =~ m/NetX_Duo-\d.\d.\w+\.a/sgi )
   {
       $module = "NetX-Duo - Code";
   }
    elsif ( $modulefn =~ m/LwIP\.a/sgi )
    {
        $module = "LwIP";
    }
    elsif ( $modulefn =~ m/FreeRTOS\.a/sgi )
    {
        $module = "FreeRTOS";
    }
    elsif ( $modulefn =~ m/NoOS\.a/sgi )
    {
        $module = "NoOS";
    }

    return $module;
}
