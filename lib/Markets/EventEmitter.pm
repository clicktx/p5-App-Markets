package Markets::EventEmitter;
use Mojo::Base 'Mojo::EventEmitter';

use constant DEBUG => $ENV{MOJO_EVENTEMITTER_DEBUG} || 0;
use Carp 'croak';

sub catch {
    $_[0]->on(
        error => {
            cb => $_[1]
        }
    ) and return $_[0];
}

sub emit {
    my ( $self, $name ) = ( shift, shift );

    if ( my $s = $self->{events}{$name} ) {
        warn "-- Emit $name in @{[blessed $self]} (@{[scalar @$s]})\n" if DEBUG;
        for my $event (@$s) { $event->{cb}(@_) }
    }
    else {
        warn "-- Emit $name in @{[blessed $self]} (0)\n" if DEBUG;
        die "@{[blessed $self]}: $_[0]" if $name eq 'error';
    }
    use Data::Dumper;
    say Dumper $self;
    return $self;
}

sub once { croak 'Method "once" not supported.' }

# sort by priority
sub sort {
    my ( $self, $name ) = ( shift, shift );
    @{ $self->{events}{$name} } =
      sort { $a->{priority} <=> $b->{priority} } @{ $self->{events}{$name} };
}

1;

=encoding utf8

=head1 NAME

Markets::EventEmitter - Event emitter base class for L<Markets::Addons>

=head1 SYNOPSIS


=head1 DESCRIPTION

This module is L<Mojo::EventEmitter> Based.
There Events will be run in priority order.

=head1 EVENTS

L<Markets::EventEmitter> inherits all events from L<Mojo::EventEmitter> & L<Mojolicious::Plugins>.

=head1 ATTRIBUTES


=head1 METHODS

=head2 emit

    $e = $e->emit('name');
    $e = $e->emit('name' => $arg1, $arg2, $arg3, ...);

Emit event.

=head2 on

    my $hash_ref = $e->on(name => $args);

Subscribe to event.

    $e->on(
        name => {
            cb       => \&cb,
            priority => $int,   # default 100
        }
    );

=head2 sort

    $e->sort('name');

Sort the Events in order of priority


=head1 SEE ALSO

L<Mojo::EventEmitter>

=cut
