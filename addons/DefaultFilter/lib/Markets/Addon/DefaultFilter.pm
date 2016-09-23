package Markets::Addon::DefaultFilter;
use Mojo::Base 'Markets::Addon';

use Data::Dumper;

my $class = __PACKAGE__;
my $home  = $class->addon_home;    # get this addon home abs path.

sub register {
    my ( $self, $app, $conf ) = @_;

    $self->add_filter(
        filter_form => \&query_convert_ja,
        { default_priority => -9999 }
    );
}

sub query_convert_ja {
    my ($c) = @_;
    say "hook! DefaultFilter!";
    return if $c->app->language ne 'ja';
    say "language is ja.";
    my $query = $c->req;
    say $query;
}

sub install   { }
sub uninstall { }
sub update    { }

sub enable {
    my $self = shift;    # my ($self, $app, $arg) = (shift, shift, shift // {});
    $self->SUPER::enable(@_);
}

sub disable {
    my $self = shift;
    $self->SUPER::disable(@_);
}

1;
