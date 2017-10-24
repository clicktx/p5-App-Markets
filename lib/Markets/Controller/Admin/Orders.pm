package Markets::Controller::Admin::Orders;
use Mojo::Base 'Markets::Controller::Admin';

sub index {
    my $self = shift;

    my $form = $self->form_set('search-order');
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->validate;

    my $conditions = {
        where    => '',
        order_by => '',
        page_no  => $form->param('p') || 1,
        rows     => 5,
    };

    my $rs     = $self->app->schema->resultset('Sales::Order::Shipment');
    my $orders = $rs->search_sales_list($conditions);

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
