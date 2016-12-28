package Markets::Controller::Catalog::Account;
use Mojo::Base 'Markets::Controller::Catalog';

sub authorize {
    my $self = shift;
    say "authorize";    #debug
    my $session      = $self->db_session;
    my $referer      = $self->current_route;
    my $redirect_url = $self->url_for('customer_login')->query( ref => $referer );
    $self->redirect_to($redirect_url) and return 0 unless $self->is_logged_in;
    return 1;
}

sub login {
    my $self    = shift;
    my $session = $self->db_session;
    my $params  = $self->req->params;

    $self->render( ref => $params->param('ref') );
}

sub login_authen {
    my $self    = shift;
    my $params  = $self->req->params;
    my $session = $self->db_session;

    my $is_valid = $params->param('password');
    if ($is_valid) {
        $self->db_session->data( customer_id => 1 );

        # Regenerate session id
        my $sid = $session->regenerate_sid;
        say "  .. regenerate_sid: " . $sid;    #debug

        my $redirect_route = $params->param('ref') || 'customer_home';
        return $self->redirect_to($redirect_route);
    }
    else {
        say "don't loged in.";                 #debug
    }
    $self->render( template => 'account/login', ref => $params->param('ref') );
}

sub logout {
    my $self = shift;

    my $session = $self->db_session;
    $self->model('account')->remove_session($session);
}

sub home {
    my $self = shift;
}

sub favorite {
    my $self = shift;
}

1;
