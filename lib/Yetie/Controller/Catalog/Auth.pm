package Yetie::Controller::Catalog::Auth;
use Mojo::Base 'Yetie::Controller::Catalog';

sub logout {
    my $c = shift;
    $c->template('logout');

  # logout時にカスタマーカートの削除処理を入れるか？
  # e.g. ３日間経過していたら後で買うリストにカート商品を移動して、カートを空にする

    # logoutは自分の意志で行い、ブラウザから完全に個人情報を削除したい意思がある
    # カート内のアイテムも削除　又は　後で買うリストに移動?
    # lohaco toLaterBuyFromCart

 # Amazonはサインアウトでカート内のアイテムを削除しない（日数が経過した場合は不明）

# Remove server session
# カートセッションを削除するとDBに残っている無効なセッションも削除されるので良いが...
# $session->cart_session->remove;
    my $session = $c->server_session;
    return $c->render() if !$session->remove_session;

    # Remove auto login cookie & token
    $c->service('authentication')->remove_remember_token;

    # Remove cookie session
    $c->cookie_session( expires => 1 );

    # Logging
    # Activity
    my $customer_id = $c->server_session->customer_id;
    $c->service('activity')->add( logout => { customer_id => $customer_id } );

    return $c->render();
}

1;
