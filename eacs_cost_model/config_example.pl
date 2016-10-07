#
#
#
#
#

my $file = shift;

my $exit_code = read_config($file);

if ($exit_code == 1 ) { 
    print "Success!\n";
     } else { 
      print "sub exit not 1, failed!\n";
};

#####################
sub read_config {
my ($filename) = @_;
open my($CF), $filename or return; # Failure
while (<$CF>) {
chomp;
my ($directive, $rest) = split /\s+/, $_, 2;
if ($directive eq 'LIST') {
    my $cmd = "/usr/bin/ls";
    $cmd = $cmd." ".$rest;
    my @files = `$cmd` or die "Couldn.t chdir to '$rest': $!; aborting";
    foreach my $item (@files) { 
       chomp($item);
       print "cmd here: ", $item, "\n";
       }
print "\n";
} elsif ($directive eq 'LOGFILE') {
open STDERR, ">>", $rest
or die "Couldn.t open log file '$rest': $!; aborting";
} elsif ($directive eq 'PWD') {
    my $cmd = "pwd";
#    $cmd = $cmd." ".$rest;
    my @files = `$cmd` or die "Couldn.t chdir to '$rest': $!; aborting";
    foreach my $item (@files) { 
       chomp($item);
       print "pwd here: ", $item, "\n";
       }
print "\n";
#open STDERR, ">>", $rest
#or die "Couldn.t open log file '$rest': $!; aborting";
} elsif ($directive eq 'VERBOSITY') {
$VERBOSITY = $rest;
print "verbosity here: $rest\n";
print "\n";
} else {
die "Unrecognized directive $directive on line $. of $filename; aborting";
 }
 }
return 1; # Success
}
