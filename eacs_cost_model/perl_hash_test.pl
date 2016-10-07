#
#
#
#

use Data::Dumper;

my %utilization;
$utilization{"XXXXX"} = "EACS_TEAM";
$utilization{"YYYYY"} = "EACS_TEAM";

#print_hash(\%utilization);

#exit;


print Dumper \%utilization;


my %budgeted;
my $ii == 0 ;

my $util_file = shift;
print "Name of file: $util_file\n";
print "Counter: ^$ii^\n";

my $budget_file = shift;;


print "----< Start >---\n";
my $hash_ref = dump_into_util_hash($util_file,$ii,\%utilization);


print "----< End >---\n";

# subs
#
#^#:ItemNumber,ServiceName,ServiceUtilzation(monthly cost)^
#1,squid,85
#2,tiger,12
#3,lion,67
#4,finch,13
#5,owl,73
#6,turtle,13
#
sub dump_into_util_hash {
my($file,$ii,$ref) = @_;
#print "file: $file\n";
#print "\$ii: $ii\n";
#print "hash ref: $ref\n\n";
open my($CF), $file or return;  # Failure
 while(<$CF>){
    my $line = $_;
    chomp($line);
    #print "Opening $file.  Counter is ^$ii^.\n";
    #print "Line is:\n$line\n";
     if ( $line =~ m/^(\#\:)+/xi ){ print "Skiping Header line.\n"; next; 
       } else {
        $ii++;
        #print "Line: $line\n";
        my($LineNumber,$ServiceName,$ServiceUtilization) = split(/,/,$line,3);
        my $val = ($ServiceUtilization * -1);
        print "$ii:$ServiceName:\<$ServiceUtilization\>:$val\n";
        ${$ref}{$val} = $ServiceName;
     }
 }
  print "--<dump_into_util_hash>---\n";
  print_hash($ref);
  print "--<dump_into_util_hash>---\n";
return($ref);
}

sub print_hash {
my($array_ref) = @_;
print "--< Start print_hash Sub >-----\n";
foreach my $key ( sort ( keys %$array_ref ) ) {
  print $key , "=", ${$array_ref}{$key}, "\n";
  }
 print "---< End print_hash Sub >-----\n";
}

