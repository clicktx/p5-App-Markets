package Markets::DefaultHelpers;
use Mojo::Base 'Mojolicious::Plugin';
use Carp qw/croak/;

sub register {
    my ( $self, $app, $conf ) = @_;

    # Get constant value
    $app->helper(
        const => sub {
            my ( $c, $key ) = @_;
            my $constants = $c->app->config('constants');
            unless ( $constants->{$key} ) {
                $c->app->log->warn("const('$key') has no constant value.");
                croak "const('$key') has no constant value.";
            }
            return $constants->{$key};
        }
    );

    # Set stash template
    $app->helper( template => sub { shift->stash( template => shift ) } );
}

1;
__END__

=head1 NAME

Markets::DefaultHelpers - Default helpers plugin for Markets

=head1 DESCRIPTION

=head1 HELPERS

=head2 const

    my $hoge = $c->const('hoge');

Get constant value.

=head2 template

    $c->template('hoge/index');

Alias for $c->stash(template => 'hoge/index');

=head1 AUTHOR

Markets authors.
