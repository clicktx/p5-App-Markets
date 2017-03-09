package Markets::Controller::Admin::Staff;
use Mojo::Base 'Markets::Controller::Admin';

sub authorize {
    my $self = shift;
    return 1 if $self->is_logged_in;

    $self->flash( ref => $self->req->url->to_string );
    $self->redirect_to( $self->url_for('RN_admin_login') );
    return 0;
}

sub login_authen {
    my $self = shift;

    # validation
    my $params   = $self->req->params;
    my $is_valid = $params->param('password');

    if ($is_valid) {

        # logging etc.

        my $session  = $self->server_session;
        my $staff_id = 456;                     # debug staff_id example

        # Set staff id
        $session->staff_id($staff_id);

        # Regenerate sid
        $session->regenerate_sid;

        my $route = $self->flash('ref') || 'RN_admin_dashboard';
        $self->redirect_to($route);
    }
    else {
        # logging etc.

        $self->flash( ref => $self->flash('ref') );
        $self->render( template => 'staff/login' );
    }
}

sub login {
    my $self = shift;

    $self->flash( ref => $self->flash('ref') );
    $self->render();
}

sub logout {
    my $self = shift;

    my $session = $self->server_session;
    $self->model('account')->remove_session($session);

    return $self->redirect_to('RN_admin_login');
}

sub profile {
    my $self = shift;
}

1;
