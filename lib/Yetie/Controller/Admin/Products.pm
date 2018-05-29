package Yetie::Controller::Admin::Products;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $self = shift;

    my $form = $self->form('search');
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->do_validate;

    # use service
    my $products = $self->service('products')->search_products($form);
    $self->stash( entity => $products );

    # Page Data
    $products->page_title('Products');

    $self->render();
}

1;
