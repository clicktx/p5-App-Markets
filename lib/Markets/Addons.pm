package Markets::Addons;
use Mojo::Base 'Markets::EventEmitter';
use Carp qw/croak/;
use Mojo::Loader 'load_class';
use Mojo::Util 'camelize';

has namespaces => sub { ['Markets::Addon'] };
has action => sub { Markets::Addons::Action->new };
has filter => sub { Markets::Addons::Filter->new };
has default_priority => '100';

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

sub register_addon {
    shift->load_addon(shift)->init( shift, ref $_[0] ? $_[0] : {@_} );
}

sub _load {
    my $module = shift;
    return $module->isa('Markets::Addon')
      unless my $e = load_class $module;
    ref $e ? die $e : return undef;
}

###################################################

sub emit_action { shift->emit(@_) }
sub emit_filter { shift->emit(@_) }
sub on_hook     { shift->on(@_) }

package Markets::Addons::Action;
use Mojo::Base 'Markets::Addons';

# sub on_hook { shift->on(@_) }

package Markets::Addons::Filter;
use Mojo::Base 'Markets::Addons';

# sub on_hook { shift->on(@_) }

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
