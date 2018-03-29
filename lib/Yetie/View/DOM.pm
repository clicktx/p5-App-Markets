package Yetie::View::DOM;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Util qw(monkey_patch);
use Yetie::View::DOM::HTML;

{
    monkey_patch 'Mojo::DOM', new => sub {
        my $class = shift;
        my $self = bless \Yetie::View::DOM::HTML->new, ref $class || $class;
        return @_ ? $self->parse(@_) : $self;
      },
      content => sub {
        my $self = shift;

        my $type = $self->type;
        if ( $type eq 'root' || $type eq 'tag' ) {
            return $self->_content( 0, 1, @_ ) if @_;
            my $html = Yetie::View::DOM::HTML->new( xml => $self->xml );
            return join '', map { $html->tree($_)->render } Mojo::DOM::_nodes( $self->tree );
        }

        return $self->tree->[1] unless @_;
        $self->tree->[1] = shift;
        return $self;
      },
      _parse => sub { Yetie::View::DOM::HTML->new( xml => shift->xml )->parse(shift)->tree };
}

sub register {
    my ( $self, $app ) = @_;
    $app->helper( dom => sub { Mojo::DOM->new } );
}

1;
