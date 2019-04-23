package Yetie::Controller::Catalog::Auth::MagicLink;
use Mojo::Base 'Yetie::Controller::Catalog';

#   email追加の場合
#       - find_customerでは取得できない必要がある
#       - create_customerしてはならない
#       - customer_idを知っている必要がある。
# sub action_add_email {
#     my ( $c, $auth ) = @_;
#     use DDP;
#     p $auth;

#     # Email to vefified
#     my $email = $auth->email;
#     $c->service('email')->to_verified($email);

#     # Add email to customer
#     my $customer = $c->service('customer')->find_customer( $email->value );
#     $c->service('customer')->add_email( $customer->id, $email );
#     return;
# }

sub action_login {
    my ( $c, $auth ) = @_;

    my $customer = $c->service('customer')->find_customer( $auth->email->value );
    $c->service('customer')->login( $customer->id );
    return;
}

sub action_signup {
    my ( $c, $auth ) = @_;

    # Email to vefified
    my $email = $auth->email;
    $c->service('email')->to_verified($email);

    # Create customer & login
    my $customer = $c->service('customer')->create_customer( $email->value );
    $c->service('customer')->login( $customer->id );
    return;
}

sub verify {
    my $c              = shift;
    my %error_messages = (
        title         => 'auth.request.error.title',
        error_message => 'auth.request.error.message'
    );

    # Verify token
    my $auth = $c->service('authentication')->verify( $c->stash('token') );
    return $c->reply->error(%error_messages) if !$auth->is_verified;

    # Run the action
    my $action = 'action_' . $auth->action;
    $c->$action($auth);
    return $c->redirect_to( $auth->continue );
}

1;
