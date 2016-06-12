package builder::MyBuilder;
use strict;
use warnings;
use parent qw(Module::Build);

sub ACTION_test {
    my $self = shift;

    local $ENV{HARNESS_OPTIONS} = ($ENV{HARNESS_OPTIONS} ||'') . 'j19';
    $self->SUPER::ACTION_test(@_);
}

1;
