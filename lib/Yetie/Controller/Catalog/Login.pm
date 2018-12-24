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

# NOTE: メール送信リクエストに一定期間の時間制限をかける？
sub magic_link {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );

    # Initialize form
    my $form = $c->form('base-email');
    return $c->render() unless $form->has_data;
    return $c->render() unless $form->do_validate;

    my $email    = $form->param('email');
    my $customer = $c->service('customer')->find_customer($email);

    # NOTE: 未登録の場合は登録確認のメールを送信する
    die 'Not registered' unless $customer->is_registered;

    my $redirect = $c->flash('ref') || 'RN_customer_home';
    my $token = $c->service('authorization')->generate_token( $email, { redirect_to => $redirect } );
    my $url = $c->url_for( 'RN_callback_customer_login', token => $token );

    $c->flash( callback_url => $url->to_abs );
    $c->redirect_to('RN_customer_login_email_sended');
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
    return $c->render() unless $form->has_data;
    return $c->render() unless $form->do_validate;

    my $email    = $form->param('email');
    my $password = $form->param('password');
    my $route    = $c->flash('ref') || 'RN_customer_home';
    return $c->redirect_to($route) if $c->service('customer')->login_process( $email, $password );

    # Login failure
    $form->field($_)->append_error_class for qw(email password);
    return $c->render( login_failure => 1 );
}

1;
