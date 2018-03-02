package Yetie::Controller::Admin::Staff;
use Mojo::Base 'Yetie::Controller::Admin';

sub authorize {
    my $self = shift;
    return 1 if $self->is_logged_in;

    $self->flash( ref => $self->req->url->to_string );
    $self->redirect_to( $self->url_for('RN_admin_login') );
    return 0;
}

sub login {
    my $self = shift;

    $self->flash( ref => $self->flash('ref') );

    # Initialize form
    my $form = $self->form('admin-login');
    return $self->render() unless $form->has_data;

    return $self->render() unless $form->do_validate;

    my $login_id = $form->param('login_id');
    my $password = $form->param('password');

    my $route = $self->flash('ref') || 'RN_admin_dashboard';
    return $self->redirect_to($route) if $self->service('staff')->login_process( $login_id, $password );

    # Set error class
    $form->field($_)->append_error_class for qw(login_id password);
    return $self->render( login_failure => 1 );
}

sub logout {
    my $self = shift;

    my $session = $self->server_session;
    $session->remove_session;

    return $self->redirect_to('RN_admin_login');
}

sub profile {
    my $self = shift;
    $self->render();
}

1;
