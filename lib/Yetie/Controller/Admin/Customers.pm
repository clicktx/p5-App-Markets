package Yetie::Controller::Admin::Customers;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;

    my $form = $c->form('search');
    $c->init_form();    # hook point
    return $c->render() unless $form->do_validate;

    my $customers = $c->service('customer')->search_customers($form);
    $c->stash( entity => $customers );

    # Page data
    $customers->page_title('Customers');

    $c->render();
}

1;
