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

# NOTE: remember_me はどうするか
sub callback {
    my $c     = shift;
    my $token = $c->stash('token');

    my %error_messages = (
        title         => 'authorization.request.error.title',
        error_message => 'authorization.request.error.message'
    );

    my $authorization = $c->service('authorization')->validate($token);
    return $c->reply->error(%error_messages) unless $authorization->is_valid;

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

    return $c->service('customer')->send_authorization_mail($form);
}

sub remember_me {
    my $c       = shift;
    my $service = $c->service('customer');

    # Auto login
    my $token         = $service->remember_me;
    my $authorization = $c->service('authorization')->validate($token);

    # NOTE: ADD logging??
    if   ( $authorization->is_valid ) { $service->login_process_remember_me( $authorization->email ) }
    else                              { $service->remove_remember_me }

    my $return_path = $c->flash('return_path') // 'RN_home';
    return $c->redirect_to($return_path);
}

sub toggle {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );

    my $value = $c->cookie('login_with_password') ? 0 : 1;
    $c->cookie( login_with_password => $value, { expires => time + $c->pref('cookie_expires_long') } );
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
        { expires => time + $c->pref('cookie_expires_long') }
    );

    # Login failure
    return $c->render( login_failure => 1 ) unless $c->service('customer')->login_process_with_password($form);

    # Login success
    $c->service('customer')->remember_me( $form->param('email') ) if $form->param('remember_me');

    my $route = $c->flash('ref') || 'RN_customer_home';
    return $c->redirect_to($route);
}

1;
