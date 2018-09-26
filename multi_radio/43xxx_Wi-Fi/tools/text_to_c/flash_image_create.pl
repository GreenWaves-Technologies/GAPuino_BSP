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
# Create a FLASH image with listed files in proper placement
#

if (! $ARGV[0] )
{
    print STDERR "\nCypress Create FLASH File Image\n";
    print STDERR "(Fill all empty space between files with 0xFF)\n";
    print STDERR "  Configuration file is list of hex_offset, file_path\n";
    print STDERR "  ex:\n";
    print STDERR "0x00000000,file_1\n";
    print STDERR "0x00008000,file_2\n\n";
    print STDERR "Usage ./flash_image_create.pl [-f size][-v] <config_file> <output_file>\n";
    print STDERR "      [-c]      =  Compact (do not fill in gaps - essentially cat all the files together)\n";
    print STDERR "                   This would be or a non-OTA2 build. Default:0 (ignores -f)\n";
    print STDERR "      [-f size] =  FLASH size (if < data size, fail)\n";
    print STDERR "                   FLASH size (if > data size, Fill with out to full size with 0xFF)\n";
    print STDERR "      [-v 0|1]  =  verbose output\n";
    exit;
}

# Print start of output
my $compact = 0;
my $file_size = 0;
my $verbose = 0;
my $config_name = "";
my $output_name = "";
my @infile_offsets;
my @infile_filenames;
my @infile_sizes;
my $FF_data = "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff";
my $FF_data_size = 64;
my $i;
my $argc = @ARGV;
for ($i = 0; $i < $argc; $i++)
{
    if ($ARGV[$i] eq "-c")
    {
        $compact = 1;
        next;
    }
    if ($ARGV[$i] eq "-v")
    {
        $i++;
        $verbose = hex($ARGV[$i]);
        next;
    }
    if ($ARGV[$i] eq "-f")
    {
        $i++;
        $file_size = hex($ARGV[$i]);
        next;
    }
    if ( $config_name eq "" )
    {
        $config_name = $ARGV[$i];
        next;
    }
    if ( $output_name eq "")
    {
        $output_name = $ARGV[$i];
        next;
    }
}

#
# output build info
#
print STDERR "\n Create Flash Image File\n";
print STDERR "Config file: $config_name\n";
print STDERR "Image  file: $output_name\n";
if ($compact ne 0)
{
    print STDERR "Compact - ignore -f\n";
}
if ($file_size gt 0)
{
    print STDERR "Output file size: $file_size\n";
}

#read the configuration and parse into arrays
parse_config_file();

# copy over the data
create_FLASH_image();

$size = -s $output_name;
print STDERR "Output: sz:$size $output_name\n";

print STDERR "Done!\n";

############################ Subroutines ################


############################################
#
# Parse the configuration file and put into our arrays
#
############################################
sub parse_config_file()
{
    sysopen(INFILE, $config_name, O_RDONLY) or die "cant open " . $config_name;
    # read in the configuration file
    while( <INFILE> )
    {
        push @config_lines, $_;
    }
    close INFILE;

    $i = 0;
    foreach( @config_lines )
    {
        $_ =~ s/\t//;
        $_ =~ s/  / /;
        $_ =~ s/  / /;
        my @pieces = split(/ /, $_);
        push @infile_offsets, hex($pieces[0]);

        # drop the \r or \n at the end of the string
        $search = "\r";
        $replace = "";
        $pieces[1] =~ s/$search/$replace/;
        $search = "\n";
        $pieces[1] =~ s/$search/$replace/;

        push @infile_filenames, $pieces[1];

        # get file size
        $size = -s "$pieces[1]";
        push @infile_sizes, $size;

        $i++;
    }

    $size = @infile_filenames;
    # print out configuration
    if ($verbose == 1)
    {
        for ( $i = 0; $i < $size; $i++)
        {
            print STDERR " filenam[$i] = $infile_filenames[$i]\n";
            print STDERR " offsets[$i] = $infile_offsets[$i]\n";
            print STDERR " size   [$i] = $infile_sizes[$i]\n";
        }
    }

    sort_files_by_offset();
}

############################################
#
# Sort the files by offset
#
############################################
sub sort_files_by_offset()
{
    # do we need to sort the entries?
    # we expect < 10 files, so just a simple bubble sort
    for ( $i = 0; $i < $size; $i++)
    {
        for ($j = $i; $j < $size; $j++)
        {
            if ($infile_offsets[$j] < $infile_offsets[$i] )
            {
                print STDERR "SORT: swap $i $j $infile_offsets[$j] < $infile_offsets[$i] \n";

                $temp = $infile_offsets[$j];
                $infile_offsets[$j] = $infile_offsets[$i];
                $infile_offsets[$i] = $temp;

                $temp = $infile_sizes[$j];
                $infile_sizes[$j] = $infile_sizes[$i];
                $infile_sizes[$i] = $temp;

                $temp = $infile_filenames[$j];
                $infile_filenames[$j] = $infile_filenames[$i];
                $infile_filenames[$i] = $temp;
            }
        }
    }
}

############################################
#
# copy the data to the FLASH output file
#
############################################
sub create_FLASH_image()
{
    my $last_offset_written = 0;
    my $total_written = 0;
    my $ret;

    # set permission so we can re-write the output file
    chmod 0666, $output_name;

    $ret = open(OUTFILE, ">", $output_name );
    if ($ret eq undef)
    {
        die "cant open ret:$ret $! " . $output_name;
    }
    binmode OUTFILE;

    $last_offset_written = 0;
    $size = @infile_filenames;
    for ( $i = 0; $i < $size; $i++)
    {
        if ($compact eq 0)
        {
            # if the last byte written does not match the offset of this file, fill in with 0xFF
            if ($last_offset_written < $infile_offsets[$i])
            {
                my $diff = $infile_offsets[$i] - $last_offset_written;

                if ($verbose == 1)
                {
                    print STDERR "We need to fill $diff here to fill to $infile_offsets[$i]\n";
                }
                $fill = $diff;
                while ($fill > 0)
                {
                    $chunk = $fill;
                    if ($chunk > $FF_data_size)
                    {
                        $chunk = $FF_data_size;
                    }
                    syswrite OUTFILE, $FF_data, $chunk;
                    $fill -= $chunk;
                }

                $last_offset_written = $last_offset_written + $diff;
                $total_written = $total_written + $diff;
            }
        }
        # open and copy the input file to the output

        printf STDERR "Copying offset: $infile_offsets[$i] size: $infile_sizes[$i] $infile_filenames[$i]\n";
        open(INFILE, "<", $infile_filenames[$i] ) or die "cant open " . $infile_filenames[$i];
        binmode INFILE;

        # copy the file over
        $copied = 0;
        while ($len = sysread INFILE, my $data, 8192)
        {
            $ret = syswrite OUTFILE, $data, $len;
            if ($ret eq undef)
            {
                die "Failed to write ret:$ret err:$!\n";
            }
            $copied = $copied + $len;
        }
        defined $len or die "Failed reading $! INFILE";
        $copied = $copied + $len;

        if ($copied != $infile_sizes[$i])
        {
            "Only read $copied of $infile_sizes[$i] of $infile_filenames[$i]\n";
        }

        $last_offset_written = $last_offset_written + $copied;
        $total_written = $total_written + $copied;

        close INFILE;
    }

    # do we want to fill to the end of the FLASH?
    if (($compact eq 0) && ($file_size > 0))
    {
        if ($last_offset_written <  $file_size)
        {
            my $diff = $file_size - $last_offset_written;

            print STDERR "Filling $diff bytes here to full FLASH size $file_size.\n";

            $fill = $diff;
            while ($fill > 0)
            {
                $chunk = $fill;
                if ($chunk > $FF_data_size)
                {
                    $chunk = $FF_data_size;
                }
                syswrite OUTFILE, $FF_data, $chunk;
                $fill -= $chunk;
            }

            $last_offset_written = $last_offset_written + $diff;
            $total_written = $total_written + $diff;
        }
    }

    close OUTFILE;
}
