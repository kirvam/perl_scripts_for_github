#
#
#
#
#
#$dispatch_table =
#
use Data::Dumper;



$actions =
            {    
                     DOG => "woof",
                   CHDIR => \&change_dir,
                 LOGFILE => \&open_log_file,
               VERBOSITY => \&set_verbosity,
                   LIST  => \&list_files,
                    PWD  => \&pwd_location,
                   DATE  => \&date_cmd,
};
#                   DATE  => sub { my $cmd = @_; chomp($cmd); my $path = "/usr/bin/"; my $cmd = $path.$date; $out = `$cmd` or die "Flaming death on date!, $!\n" ; print $date,"\n\n"; },


print Dumper \$actions; 

print "$actions->{DOG}\n";

#date_cmd("date");
#exit;

my $file = shift;

#my $exit_code = read_config_old($file);

my $exit_code = read_config($file,$actions);

if ($exit_code == 1 ) { 
    print "Success!\n";
     } else { 
      print "sub exit not 1, failed!\n";
};


#####################
sub read_config {
# sub to read config file.
  my ($filename,$actions) = @_;        
  open my($CF), $filename or return;  # Failure
  while (<$CF>) {
    chomp;
    print "line: ^$_^\n";
    my($directive,$rest) = split(/\s+/,$_,2);
    print "here directive: ^$directive^\n";
    print "here rest: ^$rest^\n";
    print "here \$actions->{$directive}: $actions->{$directive}\n";
    if (exists $actions->{$directive}) {
       $actions->{$directive}->($rest, $actions);
    } else {
      die "Unrecognized directive $directive on line $. of $filename; aborting";
    }
  }
  return 1;  # Success
}

sub set_verbosity {
$VERBOSITY = shift
}

sub list_files {
my ($dir) = @_;
    my $cmd = "/usr/bin/ls";
    $cmd = $cmd." ".$rest;
    my @files = `$cmd` or die "Couldn.t chdir to '$rest': $!; aborting";
   
     foreach my $item (@files) { 
       chomp($item);
       print "cmd here: ", $item, "\n";
      }
       print "\n";
}

sub pwd_location {
    my $cmd = @_;
    chomp($cmd);
    my $pwd = `$cmd` or die "Couldn.t '$cmd': $!; aborting";
       print "pwd here: ", $pwd, "\n";
   print "\n";
}

sub date_cmd{
my($cmd) = @_;
my $out = `/usr/bin/date`;
print "date: $out\n";
}

sub read_config_old {
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
