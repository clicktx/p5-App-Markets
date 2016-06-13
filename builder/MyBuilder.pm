package builder::MyBuilder;
use strict;
use warnings;
use parent qw(Module::Build);
use Harriet;

sub ACTION_test {
    my $self = shift;

    my $harriet = Harriet->new('t/harriet');
    $harriet->load_all();

    $self->SUPER::ACTION_test(@_);
}

1;
