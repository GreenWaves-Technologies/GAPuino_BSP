#!/usr/bin/perl

###############################################################################
#
# THIS INFORMATION IS PROPRIETARY TO
#     BROADCOM CORPORATION
#  All rights reserved
#
#
#  Prints RAM usage statistics.
###############################################################################

# Args
# 0 elf list file $(ELF_OUT_LIST)
# 1-.. Elf file list $(ELF_LIST)

my $list_filename = shift(@ARGV);
my @elf_list = @ARGV;

my $tier2_start_addr;
my $tier2_end_adr;
my $tier2_ram_start;

foreach my $elf ( @elf_list )
{
	my $lst = $elf;
	$lst =~ s/^(.*)\.elf$/$1.lst/i;  # Change elf extension to lst

	open(my $lst_hnd, '<', $lst) || die("Error opening $lst: $!\n");
	my $lst_content = do { local $/; <$lst_hnd> };
	close( $lst_hnd );

	if ( $lst_content =~ m/^PATCH_ROM_START=(0x[[:alnum:]]+)/mi )
	{
		$tier2_start_addr = hex($1);
	}
	if ( $lst_content =~ m/^PATCH_ROM_SIZE=(0x[[:alnum:]]+)/mi )
	{
		$tier2_end_adr    = hex($1);
	}
	if ( $lst_content =~ m/^PATCH_RAM_START=(0x[[:alnum:]]+)/mi )
	{
		$tier2_ram_start    = hex($1);
	}
}

$tier2_end_adr = $tier2_end_adr + $tier2_start_addr;

if ( ! defined($tier2_start_addr) )
{
	die "ERROR: tier2_start_addr - Load Region CM3_Ver1 not found in list files\n";
}

open(my $list_handle, '<', $list_filename) || die("Error opening $list_filename: $!\n");
my $list_file_content = do { local $/; <$list_handle> };
close( $list_handle );

if ( $list_file_content !~ m/^[[:space:]]+(0x[[:alnum:]]+)[[:space:]]+spar_irom_begin[[:space:]]=[[:space:]]0x[[:alnum:]]+/mi )
{
	die "ERROR: failed to find spar_irom_begin in $list_filename\n";
}
my $spar_start_adr = hex($1);

if ( $list_file_content !~ m/^[[:space:]]+(0x[[:alnum:]]+)[[:space:]]+spar_iram_end[[:space:]]=[[:space:]]\./mi )
{
	die "ERROR: failed to find spar_irom_end in $list_filename\n";
}
my $spar_end_adr = hex($1);


print  "--------------------------------------------------------------------------------\n";
printf "Patch code starts at              0x%08X (RAM address)\n", $tier2_start_addr;
printf "Patch code ends at                0x%08X (RAM address)\n", $tier2_end_adr;
printf "Patch RW/ZI size                  %d bytes\n", ($spar_start_adr - $tier2_ram_start);
printf "Application starts at             0x%08X (RAM address)\n", $spar_start_adr;
printf "Application ends at               0x%08X (RAM address)\n", $spar_end_adr;
printf "\n";
printf "Patch code size                   %*d bytes\n", 10, ($tier2_end_adr - $tier2_start_addr);
printf "Application RAM footprint         %*d bytes\n", 10, ($spar_end_adr - $spar_start_adr);
print  "                                      ------\n";
printf "Total RAM footprint               %*d bytes (%02.1fkiB)\n", 10, ($spar_end_adr - $tier2_ram_start), ($spar_end_adr - $tier2_ram_start) / 1024;
print  "--------------------------------------------------------------------------------\n";
