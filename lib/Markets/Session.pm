package Markets::Session;
use Mojo::Base qw/MojoX::Session/;

sub new {
    my $class = shift;
    say "M::Session::new";    # debug
    my $self = $class->SUPER::new(@_);

    return $self;
}

use DDP;

sub regenerate_session {
    my $self = shift;

    my %data = %{$self->data};
    p %data;         # debug
    p $self->sid;    # debug

    # Remove old session
    $self->expire;
    $self->flush;

    p %data;         # debug
    p $self->sid;    # debug

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
