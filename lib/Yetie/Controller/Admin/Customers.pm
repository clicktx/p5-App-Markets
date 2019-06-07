package Yetie::Controller::Admin::Customers;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;

    my $form = $c->form('search');
    $c->init_form();    # hook point

    # FIXME: bug
    return $c->render() if !$form->do_validate;

    my ( $customers, $pager ) = $c->service('customer')->search_customers($form);

    # Page
    my $page = $c->factory('entity-page')->construct(
        title => 'Customers',
        form  => $form,

        # breadcrumbs => $breadcrumbs,
        pager => $pager,
    );
    return $c->render( page => $page, customers => $customers );
}

1;
