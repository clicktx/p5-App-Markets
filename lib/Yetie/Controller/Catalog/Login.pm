package Yetie::Controller::Catalog::Login;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;

    $c->continue_url( $c->continue_url );
    return $c->redirect_to( $c->continue_url ) if $c->is_logged_in;

    # Link login
    return $c->redirect_to('RN_customer_dropin') if !$c->cookie('login_with_password');

    # Initialize form
    my $form = $c->form('auth-login');
    $form->field('remember_me')->checked( $c->cookie('remember_me') );

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    my $remember_me = $form->param('remember_me') ? 1 : 0;
    $c->cookie(
        remember_me => $remember_me,
        { expires => time + $c->pref('cookie_expires_long') }
    );

    # Login failure
    return $c->render( login_failure => 1 ) if !$c->service('customer')->login_process_with_password($form);

    # Login success
    if ($remember_me) { $c->service('authentication')->remember_me_token( $form->param('email') ) }
    return $c->redirect_to( $c->continue_url );
}

sub remember_me {
    my $c       = shift;
    my $service = $c->service('customer');

    # Auto login
    my $token         = $service->remember_me_token;
    my $authorization = $c->service('authorization')->validate($token);

    # NOTE: ADD logging??
    if   ( $authorization->is_valid ) { $service->login_process_remember_me( $authorization->email ) }
    else                              { $service->remove_remember_me_token }

    my $return_path = $c->flash('return_path') // 'RN_home';
    return $c->redirect_to($return_path);
}

sub toggle {
    my $c = shift;
    $c->continue_url( $c->continue_url );

    my $value = $c->cookie('login_with_password') ? 0 : 1;
    $c->cookie( login_with_password => $value, { expires => time + $c->pref('cookie_expires_long') } );
    return $c->redirect_to('RN_customer_login');
}

sub with_link {
    my $c = shift;
    $c->stash( action => 'with_link' );

    $c->continue_url( $c->continue_url );
    return $c->redirect_to( $c->continue ) if $c->is_logged_in;

    # Initialize form
    my $form = $c->form('auth-dropin');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # magic link
    my $settings = {
        email        => $form->param('email'),
        continue_url => $c->continue,
    };
    my $magic_link = $c->service('authentication')->create_magic_link($settings);

    # WIP: send email
    say $magic_link->to_abs;
    $c->flash( magic_link => $magic_link->to_abs );

    return $c->redirect_to('RN_email_sent_magic_link');
}

# NOTE: remember_me はどうするか
sub _with_link_auth {
    my $c     = shift;
    my $token = $c->stash('token');

    my %error_messages = (
        title         => 'auth.request.error.title',
        error_message => 'auth.request.error.message'
    );

    my $authorization = $c->service('authorization')->validate($token);
    return $c->reply->error(%error_messages) unless $authorization->is_valid;

    # Customer
    my $email    = $authorization->email;
    my $customer = $c->service('customer')->find_customer( $email->value );
    return $c->reply->error(%error_messages) unless $customer->is_member;

    # Login
    $c->service('customer')->login( $customer->id );

    my $redirect_route = $authorization->redirect || 'RN_home';
    return $c->redirect_to($redirect_route);
}

sub _with_password {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );
    $c->stash( action => 'with_password' );

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
    $c->service('customer')->remember_me_token( $form->param('email') ) if $form->param('remember_me');

    my $route = $c->flash('ref') || 'RN_home';
    return $c->redirect_to($route);
}

sub with_password {
    my $c = shift;
    $c->continue_url( $c->continue_url );

    # Set a cookie
    $c->cookie( login_with_password => 1, { expires => time + $c->pref('cookie_expires_long') } );
    return $c->redirect_to('RN_customer_login');
}

1;
