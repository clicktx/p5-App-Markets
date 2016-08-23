package Markets::Addons;
use Mojo::Base 'Markets::EventEmitter';
use Carp qw/croak/;
use Mojo::Loader 'load_class';
use Mojo::Util 'camelize';

has namespaces => sub { ['Markets::Addon'] };

sub add_filter { croak 'Method "add_filter" not implemented by subclass' }
sub add_action { croak 'Method "add_action" not implemented by subclass' }

# TODO: [WIP]
# sub emit_action { shift->emit(@_) }
sub emit_filter { shift->emit(@_) }

###################################################
###  loading plugin code from Mojolicous::Plugins
###################################################
sub load_addon {
    my ( $self, $name ) = @_;

    # Try all namespaces and full module name
    my $suffix = $name =~ /^[a-z]/ ? camelize $name : $name;
    my @classes = map { "${_}::$suffix" } @{ $self->namespaces };
    for my $class ( @classes, $name ) { return $class->new if _load($class) }

    # Not found
    die qq{Addon "$name" missing, maybe you need to install it?\n};
}

# TODO: registerの他に初期化method等を加えられる？
sub register_addon {
    shift->load_addon(shift)->register( shift, ref $_[0] ? $_[0] : {@_} );
}

# TODO: Mojolicious::Pluginのままでいいのか未検証
sub _load {
    my $module = shift;
    return $module->isa('Mojolicious::Plugin')
      unless my $e = load_class $module;
    ref $e ? die $e : return undef;
}

package Markets::Addons::Action;
use Mojo::Base 'Markets::Addons';

sub add_action {
    my ( $self, $name, $cb, $arg ) = ( shift, shift, shift, shift // {} );
    $arg->{cb} = $cb;
    $arg->{priority} //= 100;
    $self->on( $name => $arg );
    $self->sort($name);
}

package Markets::Addons::Filter;
use Mojo::Base 'Markets::Addons';

sub add_filter {
    my ( $self, $name, $cb, $arg ) = ( shift, shift, shift, shift // {} );
    $arg->{cb} = $cb;
    $arg->{priority} //= 100;
    $self->on( $name => $arg );
    $self->sort($name);
}

1;

=encoding utf8

=head1 NAME

Markets::Addons - Addon manager for Markets

=head1 SYNOPSIS


=head1 DESCRIPTION

L<Markets::Addons> is L<Mojolicious::Plugins> Based.
This module is addon maneger of Markets.

=head1 EVENTS

L<Markets::Addons> inherits all events from L<Mojo::EventEmitter> & L<Markets::EventEmitter>.

=head1 ATTRIBUTES


=head1 METHODS


=head1 SEE ALSO

L<Markets::EventEmitter> L<Mojolicious::Plugins> L<Mojo::EventEmitter>

=cut
