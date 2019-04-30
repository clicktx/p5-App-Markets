package Yetie::Controller::Admin::Staff;
use Mojo::Base 'Yetie::Controller::Admin';

sub login {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );

    # Initialize form
    my $form = $c->form('admin-login');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() unless $form->do_validate;

    my $login_id = $form->param('login_id');
    my $password = $form->param('password');

    my $route = $c->flash('ref') || 'rn.admin.dashboard';
    return $c->redirect_to($route) if $c->service('staff')->login_process_with_password( $login_id, $password );

    # Set error class
    $form->append_error_classes(qw(login_id password));
    return $c->render( login_failure => 1 );
}

sub logout {
    my $c = shift;

    my $session = $c->server_session;
    $session->remove_session;

    return $c->redirect_to('rn.admin.login');
}

sub profile {
    my $c = shift;
    $c->render();
}

1;
