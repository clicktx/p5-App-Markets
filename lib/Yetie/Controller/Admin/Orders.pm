package Yetie::Controller::Admin::Orders;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;

    my $form = $c->form('search');
    $c->init_form();

    # Validation form
    return $c->redirect_to( $c->current_route ) if !$form->do_validate;

    # Orders
    my $conditions = {
        where    => '',
        order_by => '',
        page_no  => $form->param('page'),
        per_page => $form->param('per_page') || 5,
    };
    my ( $orders, $pager ) = $c->service('order')->search_orders($conditions);

    # Page
    my $page = $c->factory('entity-page')->construct(
        title => 'Orders',
        form  => $form,
        pager => $pager,
    );
    return $c->render( page => $page, orders => $orders );
}

1;
