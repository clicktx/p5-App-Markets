package Markets::Session;
use Mojo::Base qw/MojoX::Session/;

sub new {
    my $self = shift;
    say "M::Session::new";    # debug
    $self->SUPER::new(@_);
}

1;
__END__

=head1 NAME

Markets::Session - based MojoX::Session

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 METHODS

=head1 SEE ALSO

L<MojoX::Session>

L<Mojolicious>

=cut
