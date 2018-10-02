package Yetie::App::Core::View::DOM;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Util qw(monkey_patch);
use Yetie::App::Core::View::DOM::HTML;

{
    monkey_patch 'Mojo::DOM', new => sub {
        my $class = shift;
        my $self = bless \Yetie::App::Core::View::DOM::HTML->new, ref $class || $class;
        return @_ ? $self->parse(@_) : $self;
      },
      content => sub {
        my $self = shift;

        my $type = $self->type;
        if ( $type eq 'root' || $type eq 'tag' ) {
            return $self->_content( 0, 1, @_ ) if @_;
            my $html = Yetie::App::Core::View::DOM::HTML->new( xml => $self->xml );
            return join '', map { $html->tree($_)->render } @{Mojo::DOM::_nodes( $self->tree )};
        }

        return $self->tree->[1] unless @_;
        $self->tree->[1] = shift;
        return $self;
      },
      _parse => sub { Yetie::App::Core::View::DOM::HTML->new( xml => shift->xml )->parse(shift)->tree };
}

sub register {
    my ( $self, $app ) = @_;
    $app->helper( dom => sub { Mojo::DOM->new } );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::App::Core::View::DOM

=head1 SYNOPSIS

    # Mojolicious
    $app->plugin('Yetie::App::Core::View::DOM');

    # Mojolicious::Lite
    plugin 'Yetie::App::Core::View::DOM';


=head1 DESCRIPTION



=head1 ATTRIBUTES

L<Yetie::App::Core::View::DOM> inherits all attributes from L<Mojolicious::Plugin> and implements
the following new ones.

=head1 METHODS

L<Yetie::App::Core::View::DOM> inherits all methods from L<Mojolicious::Plugin> and implements
the following new ones.

=head1 SEE ALSO

L<Yetie::App::Core::View::DOM::HTML>, L<Mojolicious::Plugin>

=cut
