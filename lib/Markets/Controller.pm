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
    $self->finalize();
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

sub action_after {
    my $self = shift;
    say "C::action_after()";
    $self->app->plugins->emit_hook( after_action => $self );
}

sub finalize {
    my $self = shift;
    say "C::finalize()";

    return if $self->flash('_is_redirect');
    $self->server_session->flush;
    say "   ... session flush";    # debug
}

sub redirect_to {
    my $self = shift;

    # Add redirect flag
    $self->flash( _is_redirect => 1 );

    # Don't override 3xx status
    my $res = $self->res;
    $res->headers->location( $self->url_for(@_) );
    return $self->rendered( $res->is_redirect ? () : 302 );
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
