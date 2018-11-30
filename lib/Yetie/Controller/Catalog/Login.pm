package Yetie::Controller::Catalog::Login;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
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

sub email {
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

sub password {
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

1;
