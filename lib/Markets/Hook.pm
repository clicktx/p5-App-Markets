package Markets::Hook;
use Mojo::Base 'Mojo::EventEmitter';

use constant DEBUG => $ENV{MOJO_EVENTEMITTER_DEBUG} || 0;
use Carp 'croak';

sub add_filter { croak 'Method "add_filter" not implemented by subclass' }
sub add_action { croak 'Method "add_action" not implemented by subclass' }

# sort by priority
sub sort {
    my ( $self, $name ) = ( shift, shift );
    @{ $self->{events}{$name} } =
      sort { $a->{priority} <=> $b->{priority} } @{ $self->{events}{$name} };
}

sub catch {
    $_[0]->on(
        error => {
            cb => $_[1]
        }
    ) and return $_[0];
}

sub emit_filter { shift->emit(@_) }

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

sub once { croak 'Method "once" not supported.' }

1;
