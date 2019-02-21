package Yetie::Controller;
use Mojo::Base 'Mojolicious::Controller';

# Override Mojolicious::Controller::cookie
sub cookie {
    my ( $self, $name ) = ( shift, shift );

    # Request cookie
    return $self->SUPER::cookie($name) unless @_;

    # Response cookie
    my ( $value, $opt ) = ( shift, shift || {} );
    $opt->{path}     //= '/';
    $opt->{httponly} //= 1;
    return $self->SUPER::cookie( $name => $value, $opt );
}

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

sub is_get_request { shift->req->method eq 'GET' ? 1 : 0 }

sub is_logged_in {
    my $self = shift;

    my $method = $self->isa('Yetie::Controller::Admin') ? 'is_staff_logged_in' : 'is_customer_logged_in';
    return $self->server_session->$method ? 1 : 0;
}

# Action process
sub process {
    my ( $self, $action ) = @_;

    # CSRF protection
    return unless $self->csrf_protect();

    # Set variant for templates
    $self->stash( variant => $self->language ) unless $self->language eq 'en';

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

1;
__END__

=for stopwords httponly

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

=head1 PROSESS

Controller process.

C<before_init> hook

=head3 C<init>

C<after_init> hook

=head3 C<init_form>

C<after_init_form> hook

C<before_action> hook

=head3 C<action_before>

C<controller action>

=head3 C<action_after>

C<after_action> hook

=head3 C<finalize>

=head1 ATTRIBUTES

L<Yetie::Controller> inherits all attributes from L<Mojolicious::Controller> and
implements the following new ones.

=head1 METHODS

L<Yetie::Controller> inherits all methods from L<Mojolicious::Controller> and
implements the following new ones.

=head2 C<cookie>

    my $foo = $c->cookie('foo');
    $c->cookie( foo => 'bar', { path => '/', httponly => 1 } )

Set default options.

path: /

httponly: 1

L<Mojolicious::Controller/cookie>

=head2 C<csrf_protect>

    $c->csrf_protect();

Request method 'POST' requires CSRF token.

=head2 C<is_get_request>

    my $bool = $c->is_get_request;

Return boolean value.

=head2 C<is_logged_in>

    my $bool = $c->is_logged_in;
    if ($bool){ say "Logged in" }
    else { say "Not logged in" }

Return boolean value.

=head2 C<redirect_to>

=head2 C<process>


See L</PROSESS>

=head1 SEE ALSO

L<Mojolicious::Controller>

L<Mojolicious>

=cut
