package Markets::Controller::Catalog::Account;
use Mojo::Base 'Markets::Controller::Catalog';

sub authorize {
    my $self = shift;
    say "authorize";    #debug
    my $referer = $self->current_route;

    $self->flash( ref => $referer );
    $self->redirect_to( $self->url_for('RN_customer_login') ) and return 0
      unless $self->service('customer')->is_logged_in;
    return 1;
}

sub login {
    my $self = shift;

    $self->flash( ref => $self->flash('ref') );
    $self->render();
}

sub login_authen {
    my $self   = shift;
    my $params = $self->req->params;

    my $is_valid = $params->param('password');
    if ($is_valid) {
        my $customer_id = 123;    # debug customer_id example
        $self->service('customer')->login($customer_id);

        my $redirect_route = $self->flash('ref') || 'RN_customer_home';
        return $self->redirect_to($redirect_route);
    }
    else {
        say "don't loged in.";    #debug
    }

    $self->render( template => 'account/login' );
}

sub logout {
    my $self = shift;
    $self->service('customer')->logout;
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
