package Markets::Controller;
use Mojo::Base 'Mojolicious::Controller';

sub process {
    my ( $self, $action ) = @_;

    # CSRF protection
    return unless $self->csrf_protect();

    # Controller process
    $self->init();
    $self->action_before();
    $self->$action();
    $self->action_after();
}

sub csrf_protect {
    my $self = shift;
    return 1 if $self->req->method ne 'POST';
    return 1 unless $self->validation->csrf_protect->has_error('csrf_token');
    $self->render(
        text   => 'Bad CSRF token!',
        status => 403,
    );
    return;
}

sub init {
    my $self = shift;
    say "C::init()";
}

sub action_before {
    my $self = shift;
    say "C::action_before()";
    $self->service('customer')->add_history;
    $self->app->plugins->emit_hook( before_action => $self );
}

# TODO:sessionのflush後に呼ばれるため注意
sub action_after {
    my $self = shift;
    say "C::action_after()";
    $self->app->plugins->emit_hook( after_action => $self );
}

1;
__END__

=head1 NAME

Markets::Controller - Controller base class

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Controller> inherits all attributes from L<Mojolicious::Controller> and
implements the following new ones.

=head1 METHODS

L<Markets::Controller> inherits all methods from L<Mojolicious::Controller> and
implements the following new ones.

=head1 SEE ALSO

L<Mojolicious::Controller>

L<Mojolicious>

=cut
