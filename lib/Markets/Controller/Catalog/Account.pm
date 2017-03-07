package Markets::Controller::Catalog::Account;
use Mojo::Base 'Markets::Controller::Catalog';

sub authorize {
    my $self = shift;
    say "authorize";    #debug
    return 1 if $self->is_logged_in;

    $self->flash( ref => $self->$self->req->url->to_string );
    $self->redirect_to( $self->url_for('RN_customer_login') );
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

sub _login_accept {
    my $self = shift;

    # logging etc.

    my $customer_id = 123;    # debug customer_id example
    $self->service('customer')->login($customer_id);

    my $route = $self->flash('ref') || 'RN_customer_home';
    return $self->redirect_to($route);
}

sub _login_failure {
    my $self = shift;

    # logging etc.

    $self->flash( ref => $self->flash('ref') );
    $self->render( template => 'account/login' );
}

1;
