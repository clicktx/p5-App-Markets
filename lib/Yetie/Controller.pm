package Yetie::Controller;
use Mojo::Base 'Mojolicious::Controller';

sub csrf_protect {
    my $self = shift;
    return 1 if $self->req->method ne 'POST';
    return 1 unless $self->validation->csrf_protect->has_error('csrf_token');
    $self->render(
        text   => 'Forbidden' . ' Invalid CSRF Token.',
        status => 403,
    );
    return;
}

sub is_logged_in {
    my $self = shift;

    my $target_id;
    $target_id = 'customer_id' if $self->isa('Yetie::Controller::Catalog');
    $target_id = 'staff_id'    if $self->isa('Yetie::Controller::Admin');

    return $target_id ? $self->server_session->data($target_id) ? 1 : 0 : undef;
}

# Action process
sub process {
    my ( $self, $action ) = @_;

    # CSRF protection
    return unless $self->csrf_protect();

    # Controller process
    $self->app->plugins->emit_hook( before_init => $self );
    $self->init();
    $self->app->plugins->emit_hook( after_init => $self );

    $self->app->plugins->emit_hook( before_action => $self );
    $self->action_before();

    $self->$action();

    $self->action_after();
    $self->app->plugins->emit_hook( after_action => $self );

    $self->finalize();
}

sub init { }

sub init_form {
    my $self = shift;
    $self->app->plugins->emit_hook( after_init_form => $self );
    return $self;
}

sub action_before {
    my $self = shift;
    $self->service('customer')->add_history;
    return $self;
}

sub action_after {
    my $self = shift;

    my $validation = $self->validation;
    $" = ',';
    $self->app->log->debug( 'Form has validation error at', @{ $validation->failed } ) if $validation->has_error;
    return $self;
}

sub finalize {
    my $self = shift;

    $self->server_session->flush;
    return $self;
}

# Override method
sub redirect_to {
    my $self = shift;

    # Don't override 3xx status
    my $res = $self->res;
    $res->headers->location( $self->url_for(@_) );
    return $self->rendered( $res->is_redirect ? () : 302 );
}

1;
__END__

=head1 NAME

Yetie::Controller - Controller base class

=head1 SYNOPSIS

    package Yetie::Controller::Product;
    use Mojo::Base 'Yetie::Controller';

    # Auto call method
    sub init {
        my $self = shift;

        ...

        $self->SUPER::init();
        return $self;
    }

    # User call method in the action
    sub init_form {
        my ( $self, $form, $product_id ) = @_;

        $form->field('product_id')->value($product_id);

        $self->SUPER::init_form();
        return $self;
    }

    sub index {
        my $self = shift;

        my $form       = $self->form('product');
        my $product_id = $self->stash('product_id');
        $self->init_form( $form, $product_id );

        ...

        $self->render();
    }

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Controller> inherits all attributes from L<Mojolicious::Controller> and
implements the following new ones.

=head1 METHODS

L<Yetie::Controller> inherits all methods from L<Mojolicious::Controller> and
implements the following new ones.

=head2 C<csrf_protect>

    $c->csrf_protect();

Request method 'POST' requires CSRF token.

=head2 C<is_logged_in>

    my $bool = $c->is_logged_in;
    if ($bool){ say "Loged in" }
    else { say "Not loged in" }

Return boolean value.

=head1 SEE ALSO

L<Mojolicious::Controller>

L<Mojolicious>

=cut
