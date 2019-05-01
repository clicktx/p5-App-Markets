package Yetie::Controller::Catalog::Signup;
use Mojo::Base 'Yetie::Controller::Catalog';

# NOTE: リクエストに一定期間の時間制限をかける
sub index {
    my $c = shift;

    # Initialize form
    my $form = $c->form('auth-magic_link');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # magic link
    my $settings = {
        email        => $form->param('email'),
        action       => 'signup',
        continue_url => 'rn.signup.done',
    };
    my $magic_link = $c->service('authentication')->create_magic_link($settings);

    # WIP: send email
    say $magic_link->to_abs;
    $c->flash( magic_link => $magic_link->to_abs );

    return $c->redirect_to('rn.email.sent.magic_link');
}

sub done {
    my $c = shift;
    return $c->render();
}

sub password {
    my $c = shift;
    return $c->reply->message();
}

# Create account, login, and disable token after validate.
sub with_link {
    my $c     = shift;
    my $token = $c->stash('token');

    my %error_messages = (
        title         => $c->__('auth.request.error.title'),
        error_message => $c->__('auth.request.error.message')
    );

    my $authorization = $c->service('authorization')->validate($token);
    return $c->reply->error(%error_messages) unless $authorization->is_valid;

    # Validated
    my $email            = $authorization->email;
    my $customer_service = $c->service('customer');

    # 登録済みのemailの場合は不正なリクエスト
    my $customer = $customer_service->find_customer( $email->value );
    return $c->reply->error(%error_messages) if $customer->is_member;

    # Create customer
    my $new_customer = $customer_service->create_customer( $email->value );

    # Login
    $c->service('customer')->login( $new_customer->id );
    return $c->redirect_to('rn.signup.done');
}

1;
