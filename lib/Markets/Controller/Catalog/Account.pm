package Markets::Controller::Catalog::Account;
use Mojo::Base 'Markets::Controller::Catalog';

sub authorize {
    my $self = shift;
    return 1 if $self->is_logged_in;

    $self->flash( ref => $self->req->url->to_string );
    $self->redirect_to( $self->url_for('RN_customer_login') );
    return 0;
}

sub login_authen {
    my $self = shift;

    # validation
    my $email    = $self->param('email');
    my $password = $self->param('password');
    my $customer = $self->service('customer')->create_entity( email => $email );

    if ( !$customer->id ) {

        # logging
        say "not find customer";
    }

    # use DDP;p $customer;
    # p $customer->id;
    # p $customer->password;
    # p $customer->password->hash;
    # p $customer->emails;
    # say $customer->created_at->time_zone->name;

    my $is_valid;
    if ($is_valid) {

        # logging etc.

        my $customer_id = 123;    # debug customer_id example
        $self->service('customer')->login($customer_id);

        my $route = $self->flash('ref') || 'RN_customer_home';

# NOTE: redirect する前にURLを検証する必要がある？
# [高木浩光＠自宅の日記 - ログイン成功時のリダイレクト先として任意サイトの指定が可能であってはいけない](http://takagi-hiromitsu.jp/diary/20070512.html)
# session cookieの改竄は可能？
        return $self->redirect_to($route);
    }
    else {
        # logging etc.

        $self->flash( ref => $self->flash('ref') );
        $self->render( template => 'account/login' );
    }
}

sub login {
    my $self = shift;

    $self->flash( ref => $self->flash('ref') );
    $self->render();
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
