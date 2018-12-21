package Yetie::Controller::Catalog::Signup;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;

    my $form = $c->form('base-email');
    return $c->render() unless $form->has_data;

    # Validation form
    return $c->render() unless $form->do_validate;

    my $email = $form->param('email');
    my $token = $c->service('authorization')->generate_token($email);

    # NOTE: 登録済みならurlをloginにする。またメールの内容も変える。
    my $url = $c->url_for( 'RN_callback_customer_signup', token => $token )->query( redirect => 'RN_customer_home' );

    $c->flash( callback_url => $url->to_abs );
    $c->redirect_to('RN_customer_signup_email_sended');

# 1. email checking
# emailチェック用テーブルにtokenと有効期限をセット
#   email,token,expires,ip?
#   同じemailは上書き
#   登録済みemailが入力されたときの動作。「登録済みです」と表示するのは良くないか？
#   （登録済みかチェック出来てしまう）
# emailを送信
# 2. set password

    # Web サービスにパスワードは必要ない - Frasco
    # https://frasco.io/your-users-dont-need-a-password-8527a891e224

    # Registration – Activate a New Account by Email
    # Verification Token
    # The VerificationToken Entity
    # Add the enabled Field to User
    # Using a Spring Event to Create the Token and Send the Verification Email
    #
    # The Event and The Listener
    # The RegistrationListener Handles the OnRegistrationCompleteEvent
    # Processing the Verification Token Parameter
    # RegistrationController Processing the Registration Confirmation
    # Adding Account Activation Checking to the Login Process
    # CustomAuthenticationFailureHandler:

    # Registration customer data
    # Create login session
}

sub email_sended {
    my $c = shift;
    return $c->render();
}

# Create account, login, and disable token after validate.
sub callback {
    my $c     = shift;
    my $token = $c->stash('token');

    my $auth_service  = $c->service('authorization');
    my $authorization = $auth_service->find($token);
    return $c->_callback_error() unless $authorization;

    my $is_validated = $auth_service->validate($authorization);
    return $c->_callback_error() unless $is_validated;

    # Validated
    my $email            = $authorization->email;
    my $customer_service = $c->service('customer');

    # 登録済みのemailの場合は不正なリクエスト
    my $customer = $customer_service->find_customer( $email->value );
    return $c->_callback_error() if $customer->is_registered;

    # Create customer
    my $customer_id = $customer_service->create_new_customer($email);

    # Logged-in
    $c->service('customer')->logged_in($customer_id);
    return $c->redirect_to('RN_customer_signup_done');
}

sub _callback_error {
    my $c = shift;
    $c->reply->error(
        title         => $c->__('authorization.request.error.title'),
        error_message => $c->__('authorization.request.error.message')
    );
}

sub done {
    my $c = shift;
    return $c->render();
}

1;
