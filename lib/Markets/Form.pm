package Markets::Form;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;

    $app->plugin($_) for qw(Markets::Form::CustomFilter Markets::Form::CustomValidator);
}

1;

=encoding utf8

=head1 NAME

Markets::Form - Form for Markets

=head1 DESCRIPTION

=head1 SEE ALSO

L<Mojolicious::Plugin>

=cut
