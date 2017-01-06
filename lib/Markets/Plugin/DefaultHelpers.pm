package Markets::Plugin::DefaultHelpers;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app, $conf ) = @_;

    # Set stash template
    $app->helper( template => sub { shift->stash( template => shift ) } );
}

1;
__END__

=head1 NAME

Markets::Plugin::DefaultHelpers - Default helpers plugin for Markets

=head1 DESCRIPTION

=head1 HELPERS

=head2 template

    $c->template('hoge/index');

Alias for $c->stash(template => 'hoge/index');

=head1 AUTHOR

Markets authors.
