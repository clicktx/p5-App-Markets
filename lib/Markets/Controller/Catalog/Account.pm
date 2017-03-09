package Markets::Controller::Catalog::Account;
use Mojo::Base 'Markets::Controller::Catalog';

sub authorize {
    my $self = shift;
    return 1 if $self->is_logged_in;

    $self->flash( ref => $self->req->url->to_string );
    $self->redirect_to( $self->url_for('RN_customer_login') );
    return 0;
}

sub login_authen {
    my $self = shift;

    # validation
    my $params   = $self->req->params;
    my $is_valid = $params->param('password');

    if ($is_valid) {

        # logging etc.

        my $customer_id = 123;    # debug customer_id example
        $self->service('customer')->login($customer_id);

        my $route = $self->flash('ref') || 'RN_customer_home';
        return $self->redirect_to($route);
    }
    else {
        # logging etc.

        $self->flash( ref => $self->flash('ref') );
        $self->render( template => 'account/login' );
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
}

sub home {
    my $self = shift;
}

sub orders {
    my $self = shift;
}

sub wishlist {
    my $self = shift;
}

1;
