package Yetie::Controller::Catalog::Signup;
use Mojo::Base 'Yetie::Controller::Catalog';

# NOTE: リクエストに一定期間の時間制限をかける
sub index {
    my $c = shift;

    my $form = $c->form('base-email');
    return $c->render() unless $form->has_data;

    # Validation form
    return $c->render() unless $form->do_validate;

    my $email = $form->param('email');
    return $c->service('customer')->send_authorization_mail($email);
}

sub email_sended {
    my $c = shift;
    return $c->render();
}

# Create account, login, and disable token after validate.
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

    # Validated
    my $email            = $authorization->email;
    my $customer_service = $c->service('customer');

    # 登録済みのemailの場合は不正なリクエスト
    my $customer = $customer_service->find_customer( $email->value );
    return $c->reply->error(%error_messages) if $customer->is_registered;

    # Create customer
    my $new_customer = $customer_service->create_new_customer($email);

    # Login
    $c->service('customer')->login( $new_customer->id );
    return $c->redirect_to('RN_customer_signup_done');
}

sub done {
    my $c = shift;
    return $c->render();
}

1;
