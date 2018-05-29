package Yetie::Controller::Admin::Customers;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $self = shift;

    my $form = $self->form('search');
    $self->init_form();    # hook point
    return $self->render() unless $form->do_validate;

    # my $orders = $self->service('orders')->search_orders($form);
    my $customers = $self->factory('customers')->create( { form => $form } );
    $self->stash( entity => $customers );

    # Page data
    $customers->page_title('Customers');

    $self->render();
}

1;
