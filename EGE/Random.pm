package EGE::Random;

use strict;
use warnings;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(rnd);

use List::Util;

my $rnd;

sub rnd {
    $rnd ||= EGE::Random->new;
}

sub new {
    my $self = {};
    bless $self, shift;
    $self;
}

sub in_range {
    my ($self, $lo, $hi) = @_;
    int rand($hi - $lo + 1) + $lo;
}

sub pick {
    my ($self, @array) = @_;
    @array[rand @array];
}

sub pickn {
    my ($self, $n, @array) = @_;
    @array = List::Util::shuffle @array;
    @array[0 .. $n - 1];
}

1;