package Markets::Controller::Catalog::Account;
use Mojo::Base 'Markets::Controller::Catalog';

sub authorize {
    my $self = shift;
    return 1 if $self->is_logged_in;

    $self->flash( ref => $self->req->url->to_string );
    $self->redirect_to( $self->url_for('RN_customer_login') );
    return 0;
}

sub login {
    my $self = shift;

    $self->flash( ref => $self->flash('ref') );

    # Initialize form
    my $form = $self->form_set('account-login');

    # $self->init_form( $form );

    return $self->render() unless $form->has_data;

    return $self->render() unless $form->validate;

    my $email    = $form->param('email');
    my $password = $form->param('password');
    my $customer = $self->factory('customer')->build($email);

    if ( $customer->id ) {
        if ( $self->scrypt_verify( $password, $customer->password->hash ) ) {

            # Login success
            # logging etc.

            $self->service('customer')->login( $customer->id );

            my $route = $self->flash('ref') || 'RN_customer_home';

# NOTE: redirect する前にURLを検証する必要がある？
# [高木浩光＠自宅の日記 - ログイン成功時のリダイレクト先として任意サイトの指定が可能であってはいけない](http://takagi-hiromitsu.jp/diary/20070512.html)
# session cookieの改竄は可能？
            return $self->redirect_to($route);
        }
        else {
            $self->app->log->warn( 'Customer login failed: password mismatch at email: ' . $email );
        }
    }
    else {
        $self->app->log->warn( 'Customer login failed: not found email: ' . $email );
    }

    # Login failure
    $form->field('email')->append_error_class;
    $form->field('password')->append_error_class;

    $self->render( login_failure => 1 );
}

sub logout {
    my $self = shift;

    my $session = $self->server_session;
    $self->model('account')->remove_session($session);
    $self->render();
}

sub home {
    my $self = shift;
    $self->render();
}

sub orders {
    my $self = shift;
    $self->render();
}

sub wishlist {
    my $self = shift;
    $self->render();
}

1;
