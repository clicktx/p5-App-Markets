package Yetie::Addon::EventEmitter;
use Mojo::Base 'Mojo::EventEmitter';

use constant DEBUG => $ENV{MOJO_EVENTEMITTER_DEBUG} || 0;
use Carp 'croak';

sub catch {
    $_[0]->on( { name => 'error', cb => $_[1] } ) and return $_[0];
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
    return $self;
}

sub on {
    my ( $self, $arg ) = ( shift, shift // {} );
    my $name = $arg->{name};
    push @{ $self->{events}{$name} }, $arg or return;
    $self->_sort_by_priority($name) and return $arg;
}

sub once { croak 'Method "once" not supported.' }

sub unsubscribe { shift->SUPER::unsubscribe(@_) }

# sort by priority
sub _sort_by_priority {
    my ( $self, $name ) = ( shift, shift );
    {
        no warnings 'uninitialized';
        @{ $self->{events}{$name} } =
          sort { $a->{priority} <=> $b->{priority} } @{ $self->{events}{$name} };
    }
}

1;

=encoding utf8

=head1 NAME

Yetie::Addon::EventEmitter - Event emitter base class for L<Yetie::Addon::Handler>

=head1 SYNOPSIS


=head1 DESCRIPTION

This module is L<Mojo::EventEmitter> Based.
There Events will be run in priority order.

=head1 EVENTS

L<Yetie::Addon::EventEmitter> inherits all events from L<Mojo::EventEmitter> & L<Mojolicious::Plugins>.

=head1 ATTRIBUTES


=head1 METHODS

=head2 C<catch>



=head2 C<emit>

    $e = $e->emit('name');
    $e = $e->emit('name' => $arg1, $arg2, $arg3, ...);

Emit event.

=head2 C<on>

    my $hash_ref = $e->on($args_ref);

    $e->on(
        {
            name     => 'trigger_name'
            cb       => \&cb,
            priority => $int,
        }
    );

Subscribe to event.
Sort the Events in order of priority.

=head2 C<once>

"once" not supported.

=head2 C<unsubscribe>

  $e = $e->unsubscribe('foo');
  $e = $e->unsubscribe(foo => $trigger_ref);

Unsubscribe from event.

=head1 SEE ALSO

L<Mojo::EventEmitter>

=cut
