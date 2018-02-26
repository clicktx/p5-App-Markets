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

    # $self->init_form( $form );

    return $self->render() unless $form->has_data;

    return $self->render() unless $form->do_validate;

    my $login_id = $form->param('login_id');
    my $password = $form->param('password');
    my $staff    = $self->service('staff')->find_staff($login_id);

    if ( $staff->id ) {
        if ( $self->scrypt_verify( $password, $staff->password->hash ) ) {

            # Login success
            # logging etc.

            $self->service('staff')->login( $staff->id );

            my $route = $self->flash('ref') || 'RN_admin_dashboard';
            return $self->redirect_to($route);
        }
        else {
            $self->stash( status => 401 );
            $self->app->admin_log->warn( 'Staff login failed: password mismatch at login id: ' . $login_id );
        }
    }
    else {
        $self->stash( status => 401 );
        $self->app->admin_log->warn( 'Staff login failed: not found login id: ' . $login_id );
    }

    # Login failure
    $form->field('login_id')->append_error_class;
    $form->field('password')->append_error_class;

    $self->render( login_failure => 1 );
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
