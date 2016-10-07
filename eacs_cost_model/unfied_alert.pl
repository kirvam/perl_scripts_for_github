# Name: nified alert
# Date: 06/13/2016
# Auth: PMH
# Desc: scrpt to unfiy and sort data from text files.
# Note: 
#

my %utilization_hash;
my %customer_resource_hash;

use Data::Dumper;

my $dispatch_table = {
         UTILX => 1_2,
         UTIL  => \&process_util_files,
       };
   

print "---<start>---\n";
my $list = create_list_of_files("utili",".");

#my $file = shift;

#open_file($file,UTIL,\%map);


print "---<end>---\n";
quit;








## Subs
#
#
sub open_file {
# open file and read
my($file,$type,$dispatch_table) = @_;
#my($file) = @_;
open my($FH), $file or die "Flaming death on open of $file: $?";

print Dumper \$dispatch_table;
my $sub = $map{$type};
$sub->($file);

while(<$FH>){
  chomp($_);
  print $_,"\n";
 }

};


sub process_util_files {
# sub to process utilization files
my($file) = @_;
my $href = \%utilization_hash;
# Utilization File Pattern
# #:ItemNumber,ServiceName,ServiceUtilization(monthly)
#my($ItemNumber,$ServiceName,$ServiceUtilization);
open my($FH), $file or die "Flaming death on open of $file: $?";

while(<$FH>){
  chomp($_);
  my $line = $_;
  # print $_,"\n";
   my($ItemNumber,$ServiceName,$ServiceUtilization) = split/,/,$line;
   ${$hash_ref}{$ServiceName} = $line; 

  }
  print "--Dumper---\n";
   print Dumper \%{$href};
  print "--Dumper---\n";
 #return \%{$href};
}

sub create_list_of_files {
# sub to open all files whcih match certain patter.
# $pattern -of files to make into list
# $dir -where to start making list of files
# my $list = create_list_of_files("utili",".");
my($pattern,$dir) = @_;
my @files = glob( $dir . '/*' );
my @list;
for my $file (@files){
 #unless ($file =~ m/^(u)/ix) { print $file,"\n"};
  if ($file =~ m/($pattern)
                   .*__.*
                   \.txt$ 
                   # utilization
                   /ix ) { 
        print "--- $file, $1\n";
        push @list, $file;
     } else {
        next; 
    }
}
print "---here---\n";
for my $item (@list){
    print $item, "\n";
  }
return($list);
}
