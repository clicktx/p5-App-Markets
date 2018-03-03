package Yetie::Controller::Catalog::Account;
use Mojo::Base 'Yetie::Controller::Catalog';

sub authorize {
    my $self = shift;
    return 1 if $self->is_logged_in;

    $self->flash( ref => $self->req->url->to_string );
    $self->redirect_to( $self->url_for('RN_customer_login') );
    return 0;
}

sub login {
    my $self = shift;
    $self->flash( ref => $self->flash('ref') );

    # Initialize form
    my $form = $self->form('account-login');
    return $self->render() unless $form->has_data;
    return $self->render() unless $form->do_validate;

    my $email    = $form->param('email');
    my $password = $form->param('password');
    my $route    = $self->flash('ref') || 'RN_customer_home';
    return $self->redirect_to($route) if $self->service('customer')->story->login_process( $email, $password );

    # Login failure
    $form->field($_)->append_error_class for qw(email password);
    return $self->render( login_failure => 1 );
}

sub logout {
    my $self = shift;

    my $session = $self->server_session;
    $session->remove_session;
    $self->render();
}

sub home {
    my $self = shift;
    $self->render();
}

sub orders {
    my $self = shift;
    $self->render();
}

sub wishlist {
    my $self = shift;
    $self->render();
}

1;
