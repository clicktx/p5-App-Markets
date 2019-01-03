package Yetie::Controller::Admin::Orders;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;

    my $form = $c->form('search');
    $c->init_form();

    # return $c->render() unless $form->has_data;
    return $c->render() unless $form->do_validate;

    my $orders = $c->service('order')->search_orders($form);
    $c->stash( entity => $orders );

    # Page Data
    $orders->page_title('Orders');

    $c->render();
}

1
