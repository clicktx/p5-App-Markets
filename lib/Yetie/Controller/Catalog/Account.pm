package Yetie::Controller::Catalog::Account;
use Mojo::Base 'Yetie::Controller::Catalog';

sub authorize {
    my $c = shift;
    return 1 if $c->is_logged_in;

    $c->flash( ref => $c->req->url->to_string );
    $c->redirect_to( $c->url_for('RN_customer_login') );
    return 0;
}

sub login {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );

    # Initialize form
    my $form = $c->form('account-login');
    return $c->render() unless $form->has_data;
    return $c->render() unless $form->do_validate;

    my $email    = $form->param('email');
    my $password = $form->param('password');
    my $route    = $c->flash('ref') || 'RN_customer_home';
    return $c->redirect_to($route) if $c->service('customer')->login_process( $email, $password );

    # Login failure
    $form->field($_)->append_error_class for qw(email password);
    return $c->render( login_failure => 1 );
}

sub login_email {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );

    # Initialize form
    my $form = $c->form('account-email');
    return $c->render() unless $form->has_data;
    return $c->render() unless $form->do_validate;

    my $email = $form->param('email');

    # my $customer = $c->service('customer')->find_customer($email);
    # say 'Not registered' unless $customer->is_registered;

    $c->flash( email => $email );
    return $c->redirect_to('RN_customer_login_password');
}

sub login_password {
    my $c = shift;
    $c->flash( ref => $c->flash('ref'), email => $c->flash('email') );
    return $c->redirect_to('RN_customer_login') unless $c->flash('email');

    # Initialize form
    my $form = $c->form('account-password');

    return $c->render() unless $form->has_data;
    return $c->render() unless $form->do_validate;

    my $email    = $c->flash('email');
    my $password = $form->param('password');
    my $route    = $c->flash('ref') || 'RN_home';
    return $c->redirect_to($route) if $c->service('customer')->login_process( $email, $password );

    # Login failure
    $form->field('password')->append_error_class;
    return $c->render( login_failure => 1 );
}

sub logout {
    my $c = shift;

    my $session = $c->server_session;
    $session->remove_session;
    $c->render();
}

sub home {
    my $c = shift;
    $c->render();
}

sub orders {
    my $c = shift;
    $c->render();
}

sub wishlist {
    my $c = shift;
    $c->render();
}

1;
