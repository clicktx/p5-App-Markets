package Markets::Controller::Admin::Staff;
use Mojo::Base 'Markets::Controller::Admin';

sub authen {
    my $self   = shift;
    my $params = $self->req->params;

    my $is_valid = $params->param('password');
    $self->render( template => 'staff/login' ) if !$is_valid;

    my $staff_id = 456;    # debug staff_id example
    $self->service('admin-staff')->login($staff_id);

    my $route = $self->flash('ref') || 'RN_admin_dashboard';
    return $self->redirect_to($route);
}

sub authorize {
    my $self = shift;
    say "authorize";       #debug
    return 1 if $self->service('admin-staff')->is_logged_in;

    $self->flash( ref => $self->current_route );
    $self->redirect_to( $self->url_for('RN_admin_login') );
    return 0;
}

sub login {
    my $self = shift;

    $self->flash( ref => $self->flash('ref') );
    $self->render();
}

#
# sub logout {
#     my $self = shift;
#     $self->service('admin-staff')->logout;
# }

sub profile {
    my $self = shift;
}

1;
