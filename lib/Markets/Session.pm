package Markets::Session;
use Mojo::Base qw/MojoX::Session/;

sub regenerate_session {
    my $self = shift;
    my %data = %{ $self->data };

    # Remove old session
    $self->expire;
    $self->flush;

    # Create new session
    $self->data(%data);
    $self->create;
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
