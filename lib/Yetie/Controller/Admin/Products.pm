package Yetie::Controller::Admin::Products;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;

    my $form = $c->form('search');
    $c->init_form();

    # return $c->render() unless $form->has_data;
    $form->do_validate;

    # use service
    my $products = $c->service('products')->search_products($form);
    $c->stash( entity => $products );

    # Page Data
    $products->page_title('Products');

    $c->render();
}

1;
