#
#
#
#
#
#
use Data::Dumper;

my %utilization;
my %budgeted;
my @list;
my $ii == 0;

$actions =
            {    
                     DOG => \&dog_sub,
                   CHDIR => \&change_dir,
                 LOGFILE => \&open_log_file,
               VERBOSITY => \&set_verbosity,
                   LIST  => \&list_files,
                    PWD  => \&pwd_location,
                   DATE  => \&date_cmd,
                   FIND  => \&create_list_of_files,
#};

#$actions =
#            {    
#                   FIND  => \&create_list_of_files,
                   LOOP_LIST => \&loop_list,
};
#                   DATE  => sub { my $cmd = @_; chomp($cmd); my $path = "/usr/bin/"; my $cmd = $path.$date; $out = `$cmd` or die "Flaming death on date!, $!\n" ; print $date,"\n\n"; },


#print Dumper \$actions; 
#print "$actions->{DOG}\n";
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
       #$actions->{$directive}->($rest, $actions);
       print "here rest: ^$rest^\n";
       $actions->{$directive}->($rest);

    } else {
      die "Unrecognized directive $directive on line $. of $filename; aborting";
    }
  }
  return 1;  # Success
}
##
##
##  Need to think about this...
sub loop_list {
my(@list,$ii,$rest,$ref)= @_;
#my(@
# $ref is hash ref
foreach my $file (@list){
  $sub_action->($file,$ii,$ref)
  #dump_into_util_hash($file,$ii,
 }
}
 
sub dog_sub {
my($bark) = @_;
chomp($bark);
print "here bark: $bark\n\n";
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
    my($cmd) = @_;
    chomp($cmd);
    my $pwd = `$cmd` or die "Could not '$cmd': $!; aborting";
       print "pwd here: ", $pwd, "\n";
   print "\n";
}

sub date_cmd{
my($cmd) = @_;
my $out = `/usr/bin/date`;
print "date: $out\n";
}

sub create_list_of_files {
#sub to open all files whcih match certain patter.
# $pattern -of files to make into list
# $dir -where to start making list of files
# my $list = create_list_of_files("utili",".");
my($input) = @_;
chomp($input);
print "here input: ^$input^\n";
my($dir,$pattern) = split /\s+/, $input, 2;
print "here dir: ^$dir^\n";
print "here pattern: ^$pattern^\n";
my @files = glob( $dir . '/*' );
my @list;
for my $file (@files){
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
#    print "---here---\n";
    for my $item (@list){
          print $item, "\n";
    }
  push @{$_}, @list;
   foreach my $item ( @{$_} ){
       print "Anon item: $item\n";
   };
  return(@list);
}

### OLD ###
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
