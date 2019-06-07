package Yetie::Controller::Admin::Products;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;

    my $form = $c->form('search');
    $c->init_form();
    $form->do_validate;

    # Products
    my ( $products, $pager ) = $c->service('product')->search_products($form);

    # Page
    my $page = $c->factory('entity-page')->construct(
        title => 'Products',
        form  => $form,
        pager => $pager,
    );
    return $c->render( page => $page, products => $products );
}

1;
