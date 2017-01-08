package Markets::View::DOM;
use Mojo::Base 'Mojolicious::Plugin';

use Markets::View::DOM::EP;
use Mojo::Util qw(monkey_patch);

{
    # no strict 'vars';

    monkey_patch 'Mojo::DOM', new => sub {
        my $class = shift;
        my $self = bless \Markets::View::DOM::EP->new, ref $class || $class;
        return @_ ? $self->parse(@_) : $self;
      },
      content => sub {
        my $self = shift;

        my $type = $self->type;
        if ( $type eq 'root' || $type eq 'tag' ) {
            return $self->_content( 0, 1, @_ ) if @_;
            my $html = Markets::View::DOM::EP->new( xml => $self->xml );
            return join '',
              map { $html->tree($_)->render } Mojo::DOM::_nodes( $self->tree );
        }

        return $self->tree->[1] unless @_;
        $self->tree->[1] = shift;
        return $self;
      },
      _parse =>
      sub { Markets::View::DOM::EP->new( xml => shift->xml )->parse(shift)->tree };
}

sub register {
    my ( $self, $app, $conf ) = @_;
    $app->helper( dom => sub { Mojo::DOM->new } );
}

1;
