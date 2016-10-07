
print "---<start>----\n";
my $dir = "/home/phaigh";

open my ($dh), $dir || die "Flaming death, $!";
#my @files = grep { /bash/xi } readdir($dh);
my @files = readdir($dh);


foreach $item (@files){
   print "here:",$item, "\n";
}

 
print "---< start 2 >---\n";
my $default = "/home/phaigh";
my $cmd = "/usr/bin/ls -al";
print "Default choice is [/home/phaigh]:";
my $response = <STDIN>;
chomp($response); 

print "^$response^\n";

if ($response eq ''){
    $response = $default;
    print "Response matches!\n";
    } else {
    #nothing
}; 

$cmd = $cmd." ".$response;     

print $cmd,"\n";

foreach $ii (@cmd){
    chomp;
    print $ii,"\n";
}

my @files = `$cmd`;

#print "$files\n";
foreach my $item (@files){
   chomp($item);;
   print "here:",$item, "\n";
}

