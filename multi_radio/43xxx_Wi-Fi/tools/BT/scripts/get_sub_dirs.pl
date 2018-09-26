my @to_visit;


$to_visit[0] = $ARGV[0];

print "$to_visit[0] ";

while (@to_visit) 
{
   my $dir = pop(@to_visit);

   opendir(my $dh, $dir) or die "Cannot open $dir";

   my $file;
   while(defined($file = readdir($dh))) 
   {
      next if $file eq '.';
      next if $file eq '..';

      # Should use File::Spec.
      $file = "$dir/$file";

      if (-d $file) 
      {
         push(@to_visit, $file);
         print "$file ";
      } 
   }
}
