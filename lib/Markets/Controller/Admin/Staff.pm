package Markets::Controller::Admin::Staff;
use Mojo::Base 'Markets::Controller::Admin';

sub authorize {
    my $self = shift;
    say "authorize";    #debug
    return 1 if $self->is_logged_in;

    $self->flash( ref => $self->req->url->to_string );
    $self->redirect_to( $self->url_for('RN_admin_login') );
    return 0;
}

sub login_authen {
    my $self   = shift;
    my $params = $self->req->params;

    my $is_valid = $params->param('password');
    return $is_valid ? $self->_login_accept : $self->_login_failure;
}

sub login {
    my $self = shift;

    $self->flash( ref => $self->flash('ref') );
    $self->render();
}

sub logout {
    my $self = shift;
    $self->service('admin-staff')->logout;

    return $self->redirect_to('RN_admin_login');
}

sub profile {
    my $self = shift;
}

sub _login_accept {
    my $self = shift;

    # logging etc.

    my $staff_id = 456;    # debug staff_id example
    $self->service('admin-staff')->login($staff_id);

    my $route = $self->flash('ref') || 'RN_admin_dashboard';
    return $self->redirect_to($route);
}

sub _login_failure {
    my $self = shift;

    # logging etc.

    $self->flash( ref => $self->flash('ref') );
    $self->render( template => 'staff/login' );
}

1;
