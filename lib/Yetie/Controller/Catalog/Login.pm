package Yetie::Controller::Catalog::Login;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );

    my $url = $c->flash('ref') || 'RN_home';
    return $c->redirect_to($url) if $c->is_logged_in;

    return $c->cookie('login_with_password')
      ? $c->redirect_to('RN_customer_login_with_password')
      : $c->redirect_to('RN_customer_login_magic_link');
}

sub callback {
    my $c     = shift;
    my $token = $c->stash('token');

    my %error_messages = (
        title         => $c->__('authorization.request.error.title'),
        error_message => $c->__('authorization.request.error.message')
    );

    my $auth_service  = $c->service('authorization');
    my $authorization = $auth_service->find($token);
    return $c->reply->error(%error_messages) unless $authorization;

    my $is_validated = $auth_service->validate($authorization);
    return $c->reply->error(%error_messages) unless $is_validated;

    # Customer
    my $email    = $authorization->email;
    my $customer = $c->service('customer')->find_customer( $email->value );
    return $c->reply->error(%error_messages) unless $customer->is_registered;

    # Login
    $c->service('customer')->login( $customer->id );

    my $redirect_route = $authorization->redirect || 'RN_home';
    return $c->redirect_to($redirect_route);
}

sub email_sended {
    my $c = shift;
    return $c->render();
}

# NOTE: メール送信リクエストに一定期間の時間制限をかける？
sub magic_link {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );

    # Initialize form
    my $form = $c->form('account-magic_link');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() unless $form->do_validate;

    my $email = $form->param('email');
    return $c->service('customer')->send_authorization_mail($email);
}

sub toggle {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );

    my $value = $c->cookie('login_with_password') ? 0 : 1;
    $c->cookie( login_with_password => $value );
    return $c->redirect_to('RN_customer_login');
}

sub with_password {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );

    # Initialize form
    my $form = $c->form('account-login');
    $form->field('remember_me')->checked( $c->cookie('default_remember_me') );

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() unless $form->do_validate;
    $c->cookie(
        default_remember_me => $form->param('remember_me') ? 1 : 0,
        { path => '/', expires => time + 60 * 60 * 24 * 365 }
    );

    # Login failure
    return $c->render( login_failure => 1 ) unless $c->service('customer')->login_process($form);

    # Login success
    my $route = $c->flash('ref') || 'RN_customer_home';
    return $c->redirect_to($route);
}

1;
