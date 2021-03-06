package List::Collection;
use Modern::Perl;
use Exporter;

# VERSION
# ABSTRACT: List::Collection

=head1 SYNOPSIS

  use List::Collection;
  my @a = qw/1 2 3 4 5 6/;
  my @b = qw/4 5 6 7 8 9/;
  my @c = qw/5 6 7 8 9 10/;

  # get intersection set between two or more List
  my @intersect = intersect(\@a, \@b, \@c);  # result is (5,6)

  # get union set between two or more List
  my @union = union(\@a, \@b, \@c);    # result is (1,2,3,4,5,6,7,8,9,10)

  # get substraction between two
  my @substract = subtract(\@a, \@b);  # result is (1,2,3)

  # get complementation between two or more
  my @complement = complement(\@a, \@b);  # result is (1,2,3,7,8,9)

Or in a object-oriented way

  use List::Collection;
  my @a = qw/1 2 3 4 5 6/;
  my @b = qw/4 5 6 7 8 9/;
  my $lc = List::Collection->new();
  my @union = $lc->union(\@a, \@b);
  my @intersect = $lc->intersect(\@a, \@b);


=head1 DESCRIPTION

Blablabla

=cut

our @ISA = qw/Exporter/;
our @EXPORT = qw/intersect union subtract complement/;

=head1 METHODS

=head2 new

List::Collection's construction function

=cut

sub new {
  my $class = shift;
  return bless { @_ }, $class;
}

sub _remove_obj {
  return if @_ == 0;
  shift if ($_[0] and ref $_[0] eq __PACKAGE__);
  return @_;
}

=head2 intersect

Intersection of multiple Lists, number of parameter could be bigger than two and type is ArrayRef

  my @a = qw/1 2 3 4 5 6/;
  my @b = qw/4 5 6 7 8 9/;
  my @intersect = intersect(\@a, \@b);

=cut

sub intersect {
  my @lists = _remove_obj(@_);
  my $list_count = @lists;
  my (%elements, @out);
  for my $list (@lists) {
    $elements{$_}++ for (@$list);
  }
  for my $key (sort keys %elements) {
    push (@out, $key) if $elements{$key} == $list_count;
  }
  @out = sort { $a <=> $b } @out;
  return @out;
}

=head2 union

union set of multiple Lists, number of parameter could be bigger than two and type is ArrayRef

  my @a = qw/1 2 3 4 5 6/;
  my @b = qw/4 5 6 7 8 9/;
  my @union = union(\@a, \@b);

=cut

sub union {
  my @lists = _remove_obj(@_);
  my (%elements, @out);
  for my $list (@lists) {
    $elements{$_} = 1 for (@$list);
  }
  @out = sort { $a <=> $b } keys %elements;
  return @out;
}

=head2 subtract

subtraction(difference set) of two Lists, input parameters' type is ArrayRef

  my @a = qw/1 2 3 4 5 6/;
  my @b = qw/4 5 6 7 8 9/;
  my @subtract = subtract(\@a, \@b);

=cut

sub subtract {
  my @lists = _remove_obj(@_);
  my %elements;
  $elements{$_} = 1 for (@{$lists[0]});
  delete $elements{$_} for (@{$lists[1]});
  my @out = sort { $a <=> $b } keys %elements;
  return @out;
}

=head2 complement 

complement set of multiple Lists, number of parameter could be bigger than two and  type is ArrayRef

  my @a = qw/1 2 3 4 5 6/;
  my @b = qw/4 5 6 7 8 9/;
  my @complement = complement(\@a, \@b);

=cut

sub complement {
  my @lists = _remove_obj(@_);
  my @union = union(@lists);
  my @intersect = intersect(@lists);
  my @out = subtract(\@union, \@intersect);
  @out = sort { $a <=> $b } @out;
  return @out;
}

1;
