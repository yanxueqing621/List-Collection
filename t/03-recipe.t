use List::Collection;
use Modern::Perl;

my @a = 1..10;
my @b = 5..15;

my @intersect = intersect(\@a, \@b);
my @union = union(\@a, \@b);
my @subtract = subtract(\@a, \@b);
my @complement = complement \@a, \@b;

say "intersect: @intersect";
say "union: @union";
say "subtract: @subtract";
say "complement: @complement";
