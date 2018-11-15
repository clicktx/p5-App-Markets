package Yetie::Controller::Catalog::Signup;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;

    my $form = $c->form('signup');
    return $c->render() unless $form->has_data;

    # Validation form
    return $c->render() unless $form->do_validate;

    my $email = $form->param('email');
    my $token = $c->service('authorization_request')->generate_token($email);

    # NOTE: 登録済みならurlをloginにする。またメールの内容も変える。
    my $url = $c->url_for( 'RN_callback_customer_signup', email => $email, token => $token );
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

sub callback {
    my $c = shift;

    my $email = $c->stash('email');
    my $token = $c->stash('token');
    my $bool  = $c->service('authorization_request')->is_verify( $email, $token );

    use DDP;
    p $email;
    p $token;
    p $bool;

    # die $email ? 'ok' : 'ng';
    die 'die';

    return $c->redirect_to('RN_customer_signup_done');
}

sub done {
    my $c = shift;
    return $c->render();
}

1;
