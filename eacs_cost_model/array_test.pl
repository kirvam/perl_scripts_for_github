#
#
#

my $d1 = "cat";
my $d2 = "dog";
my $d3 = "pig";
my $d4 = "cow";



my @str_array = ( $d1, $d2, $d3, $d4 ); 

unshift @str_array, "SHARK";

foreach my $item ( @str_array ){
        print "item: $item\n";
};



