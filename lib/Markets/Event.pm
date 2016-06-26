package Markets::Event;
use Mojo::Base 'Mojo::EventEmitter';

use constant DEBUG => $ENV{MOJO_EVENTEMITTER_DEBUG} || 0;

sub _add_filter {
    my ( $ev, $name, $code, $conf ) = ( shift, shift, shift, shift // {} );
    my $priority = $conf->{priority} // 100;
    $ev->on( $name => { code => $code, priority => $priority } );
    $ev->sort($name);
}

# sort by priority
sub sort {
    my ( $ev, $name ) = ( shift, shift );
    @{ $ev->{events}{$name} } =
      sort { $b->{priority} <=> $a->{priority} } @{ $ev->{events}{$name} };
}

sub catch {
    $_[0]->on(
        error => {
            code => $_[1]
        }
    ) and return $_[0];
}

sub emit_filter { shift->emit(@_) }

sub emit {
    my ( $ev, $name ) = ( shift, shift );

    if ( my $s = $ev->{events}{$name} ) {
        warn "-- Emit $name in @{[blessed $ev]} (@{[scalar @$s]})\n" if DEBUG;
        for my $cb (@$s) { $cb->{code}(@_) }
    }
    else {
        warn "-- Emit $name in @{[blessed $ev]} (0)\n" if DEBUG;
        die "@{[blessed $ev]}: $_[0]" if $name eq 'error';
    }
    return $ev;
}

sub once { die 'Do not support.' }

sub subscribers { die 'Do not support.' }

sub unsubscribe { die 'Do not support.' }

1;
