package Markets::Controller::Admin::Orders;
use Mojo::Base 'Markets::Controller::Admin';

sub index {
    my $self = shift;

    my $form = $self->form_set('search-order');
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->validate;

    my $page_no = $form->param('p') || 1;
    my $rows = 5;

    # bad!
    my $schema = $self->app->schema;
    my $orders = $schema->resultset('Sales::Order::Shipment')->search(
        {},
        {
            page => $page_no,
            rows  => $rows,
            order_by => { -desc => 'order_header_id' },
            prefetch => [ 'shipping_address', { order_header => 'billing_address' }, ],
        }
    );

    # content entity
    my $content = $self->app->factory('entity-content')->create(
        {
            # title      => $xx->title,
            # breadcrumb => $xx->breadcrumb,
            pager  => $orders->pager,
            params => $form->params->to_hash,
        }
    );

    $self->stash(
        content => $content,
        orders  => $orders,
    );
    $self->render();
}

1;
