package Yetie::Controller::Admin::Orders;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;

    my $form = $c->form('search');
    $c->init_form();

    # Validation form
    return $c->redirect_to( $c->current_route ) if !$form->do_validate;

    # Orders
    my ( $orders, $pager ) = $c->service('order')->search_orders($form);

    # Page
    my $page = $c->factory('entity-page')->construct(
        title => 'Orders',
        form  => $form,
        pager => $pager,
    );
    return $c->render( page => $page, orders => $orders );
}

1;
