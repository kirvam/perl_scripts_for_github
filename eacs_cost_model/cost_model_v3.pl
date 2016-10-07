#
# Name: cost_model
# AUTH: PMH
# DATE: 06/13/2016
# DESC:
# Tool to illustrate cost model for CLOUD Services
#
#
#

# Set Globals
use Data::Dumper;

my %utilization;
my %budgeted;
my @cust_res_list ="";
my $ii == 0;  

$utilization{"0"} = "First Entry/Header.";

print Dumper \%utilization;
#print "Test util hash: $utilization_hash{"0"} \n";
print "---< Start >----\n";

# create list of utilization files
my @list = create_list_of_files("utili",".");

# loop through list and dump utlization data into utilization hash
#  loop_list(@list,$ii,$sub,\%utilization)

print "Dumper\n";
print Dumper \%utilization;

 #loop_list(@list,$ii,\%utilization,\&dump_into_util_hash);
 loop_list(\&dump_into_util_hash,\%utilization,@list,$ii);

# create list of customer resources and check against utilization hash
 my @cust_res_list = create_list_of_files("customer","."); 
 my $ii ==0;
 print "Dumper on \@cust_res_list\n";
 print Dumper \@cust_res_list;
 loop_list(\&check_budget_against_util_hash,\%utilization,@cust_res_list,$ii);

# create list of budgeted files
# dump into budgeted hash
# dump into utilization hash
# sort utilization hash and print
# pick through utilization hash and match up to client
# create master preadsheet
# create consolidated invoice/alert 


print "---< End >----\n";
exit;
#my $exit_code = read_config($file,$actions);

#if ($exit_code == 1 ) { 
#   print "Success!\n";
#    } else { 
#     print "sub exit not 1, failed!\n";
#};

# Subs:
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
#my(@list,$ii,$ref,$sub_routine)= @_;
my($sub_routine,$ref,@list,$ii)= @_;
print Dumper \$ref;
# sub \&dump_into_util_hash
# my($file,$ii,$ref) = @_;
# loop_list(@list,$ii,$sub,\%utilization);
#my(@
# $ref is hash ref
#foreach my $file (@list){
print "XXXX number of values in list: $#list\n";
foreach my $file ( 0 .. $#list -1 ){
  print "Prcessing file: $list[$file]\n";
  &$sub_routine($list[$file],$ii,$ref);
  #dump_into_util_hash($list[$file],$ii,$ref);
 }
 print Dumper \%utilization;
# return(\$ref);
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
# my($input) = @_;
my($pattern,$dir)= @_;
#chomp($input);
#print "here input: ^$input^\n";
#my($dir,$pattern) = split /\s+/, $input, 2;
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

sub check_budget_against_util_hash {
#ServiceProvider,ServiceName,ServiceType,ServiceProductName,ServiceCostBudgeted(monthly)
##VTPVT,cow,IaaS,VTPVT2,200
  my($file,$ii,$ref) = @_;
  my $name = $file;
  $name =~ m/.*__([a-zA-Z]{3,6})\.txt$/xi;
  $name = $1;
  print "name: ^$name^\n";
  #print "file: $file\n";
  #print "\$ii: $ii\n";
  #print "hash ref: $ref\n\n";
  my $total;
  my @data;
   open my($CF), $file or return;  # Failure
     while(<$CF>){
     my $line = $_;
      chomp($line);
      #print "Opening $file.  Counter is ^$ii^.\n";
      #print "Line is:\n$line\n";
     if ( $line =~ m/^$/ix ) { print "Skipping blank line\n"; next; };
     if ( $line =~ m/^(\#)+/xi ){ print "Skipping Header line.\n"; next;
        } else {
          $ii++;
          #print "Line: $line\n";
          my($ServiceProvider,$ServiceName,$ServiceType,$ServiceProductName,$ServiceCostBudgeted) = split(/,/,$line,5);
           if ( ${$ref}{$ServiceName} ){ my $val = ${$ref}{$ServiceName};      
           # 7: NAS: AZ: turtle: 5: -13
           my $diff = ($ServiceCostBudgeted + $val);
           $total = ($total + $diff);
           print "$ii,$name,$ServiceProvider,$ServiceType,$ServiceName,$ServiceCostBudgeted,$val,$diff,$total\n";
           my $string;
           my @str_data = ($ii, $name, $ServiceProvider, $ServiceType, $ServiceName, $ServiceCostBudgeted, $val, $diff, $total);
             foreach my $item ( 0 .. $#str_data ){
                  $string = $string.$str_data[$item].",";
                 # push @data, $string;
                 }
                 push @data, $string;
             #${$ref}{$val} = $ServiceName;
             ${$ref}{$ServiceName} = $val;
               }   else   {
              my $val = 0;
              my $diff = ($ServiceCostBudgeted + 0);
              $total = ($total + $diff);
              my $note = "-No current util data this period.";
              print "$ii,$name,$ServiceProvider,$ServiceType,$ServiceName,$ServiceCostBudgeted,$val,$diff,$total,$note\n";
              my $string;
              my @str_data = ($ii, $name, $ServiceProvider, ,$ServiceType, $ServiceName, $ServiceCostBudgeted, $val, $diff, $total, $note );
             foreach my $item ( 0 .. $#str_data ){
                  $string = $string.$str_data[$item].",";
                 # push @data, $string;
                 }
                push @data, $string;
         }
       }
   # return($data);
   #
 }
  # return($data);
  # create_xlsx();
  # my($file_name,$worksheet_name,$header,@array) = @_;
 my $header = "Number,AgencyName,ServiceProvider,ServiceType,ServiceName,ServiceCostBudgeted,CurrentUtilization,Diff,RunningTotal,Note";
 print "header_string: $header\n";
 unshift @data, $header;
 foreach my $test (@data){
   print "\$test: $test\n";
 };
 #print "unshifted: $data[0]\n";
 
 create_xlsx($name,$name,$name,@data);
 #print "--<HERE 1 dump_into_util_hash>---\n";
 #print_hash($ref);
 #print "--<HERE 2 dump_into_util_hash>---\n";
 #return($ref);
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
           #${$ref}{$val} = $ServiceName;
           ${$ref}{$ServiceName} = $val;
       }
 }
 print "--<HERE 1 dump_into_util_hash>---\n";
 print_hash($ref);
 print "--<HERE 2 dump_into_util_hash>---\n";
 return($ref);
}

sub print_hash {
my($array_ref) = @_;
print "--< Start print_hash Sub >-----\n";
  foreach my $key ( sort ( {$a<=>$b} keys %$array_ref ) ) {
   print $key , ",", ${$array_ref}{$key}, "\n";
   #print ${$array_ref}{$key}, ",", $key, "\n";
   
  }
print "---< End print_hash Sub >-----\n";
}


sub create_spreadsheet {
# sub to create spreat sheet
# my(@data,$name_for_sheet) = @_;
use Excel::Writer::XLSX;

$name_for_sheet = $name_for_sheet."\.xlsx";
print "name_for_sheet: $name_for_sheet\n";
# Create a new Excel workbook
my $workbook = Excel::Writer::XLSX->new( $name_for_sheet );

# Add a worksheet
  $worksheet = $workbook->add_worksheet();

#  Add and define a format
  $format = $workbook->add_format();
  $format->set_bold();
  $format->set_color( 'red' );
  $format->set_align( 'center' );

# Write a formatted and unformatted string, row and column notation.
  $col = $row = 0;
  $worksheet->write( $row, $col, 'Hi Excel!', $format );
  $worksheet->write( 1, $col, 'Hi Excel!' );

# Write a number and a formula using A1 notation
  $worksheet->write( 'A3', 1.2345 );
  $worksheet->write( 'A4', '=SIN(PI()/4)' );

};



sub intake_create {
# use strict;
my %HoA;
print "-------------------<main while>-------------------\n";
my %HoA = &intake_file;
print "-------------------<next section>------------------------\n";

print_HoA(%HoA); # calls sub create_xlsx to create the xlsx  
};
 
# SUBS
#################################################################################
sub print_HoA {
# sub to print HoA
  my($file_name,$worksheet_name,$header);
  my(%HoA) = @_;
  foreach my $item ( keys %HoA ) {
   my @array;
    foreach my $i ( 0 .. $#{ $HoA{$item} } ) {
       $file_name = $item;
       $worksheet_name = $file_name;
       $header = "Header - $file_name";
       my $string = $HoA{$item}[$i];
        chomp($string);
        print "HERE: $string\n";
        push @array, $string;
    }
   print "--<break -each key>---\n";
  create_xlsx($file_name,$worksheet_name,$header,@array);
 }
};

sub create_xlsx {
# sub to create xlsx
  my($file_name,$worksheet_name,$header,@array) = @_;
  print "file_name: $file_name\n";
  $file_name = $file_name."\.xlsx";
  print "file_name: $file_name\n";
  print "worksheet_name: $worksheet_name\n";
  $header = $header." - "."Monthly Utilization Report";
  print "header: $header\n";
  print "unshifted: $array[0]\n";
  use Excel::Writer::XLSX;
# Create a new Excel workbook
  my $workbook = Excel::Writer::XLSX->new( $file_name );
   # Add a worksheet
  my $worksheet = $workbook->add_worksheet( $worksheet_name );   
   #  Add and define a format
  my $format = $workbook->add_format();
     $format->set_bold(1);
     $format->set_align( 'left' );
     $format->set_bg_color('green');
     $format->set_color('white');	
      $format->set_font('Tahoma');
      $format->set_size('10');
 # Write a formatted and unformatted string, row and column notation.
      $worksheet->write( 0, 1, $header, $format );
      # turn off bold
  my $format = $workbook->add_format();
      $format->set_bold(0);
      $format->set_bg_color();
      $format->set_color();
      $format->set_font('Tahoma');
      $format->set_size('10');
 # set row to start on row 2 to allow for header..
   my $col = 0; my $row = 3;
     foreach my $item (@array){
       print "creat_xls: $item\n";
       #print "ITEM: \$item: $array[0]\n";
       if( $item !~ m/$_[0]/ ){
       my @small = split(/,/,$item);
         $format->set_bold(1);
         $format->set_align( 'left' );
         $format->set_bg_color('green');
         $format->set_color('white');
         $format->set_font('Tahoma');
         $format->set_size('10');
#
         for my $ii ( 0 .. $#small ){
           $col = $ii+2; # controls start of column
           print "write line: $row, $col, $small[$ii]\n";
           $worksheet->write( $row, $col, $small[$ii], $format );
            };
          } else {
       my @small = split(/,/,$item);
       #  my $col = 0; my $row = 0;
 #
       my $format = $workbook->add_format();
         $format->set_bold(0);
         $format->set_bg_color();
         $format->set_color();
         $format->set_font('Tahoma');
         $format->set_size('10');
 #
         for my $ii ( 0 .. $#small ){
           $col = $ii+2; # controls start of column
           print "write line: $row, $col, $small[$ii]\n";
           $worksheet->write( $row, $col, $small[$ii], $format );
      }
    }
     $row++;
 };
};

sub intake_file {
# sub to intake file and populate %HoA;
my %HoA;
  while(<>){
  my $line = $_;
  chomp($line);
   my $pattern = "\t\t";
   #my $pattern = ",";
   #print "\$pattern: = ^$pattern^\n"; exit;
     my @array = split(/$pattern/,$line);
     my $remove = shift @array;  # shifting off first element
        print "REMOVED $remove\n";

       my $line = join($pattern, @array);
       my $key = $array[0];
         print "KEY $key\n";
        if ( $HoA{$key} ){
        push @{ $HoA{$key} }, $line;
         foreach $key ( keys %HoA ){
          print "\$HoA\{$key\} \= @{ $HoA{$key} }\n";
            }
        } else {
         $HoA{$key} = [ $line ];
         foreach $key ( keys %HoA ){
         print "\$HoA\{$key\} \= @{ $HoA{$key} }\n";
      }
   }
 }
     return %HoA;
};


