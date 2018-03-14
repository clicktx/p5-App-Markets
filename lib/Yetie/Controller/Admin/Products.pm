package Yetie::Controller::Admin::Products;
use Mojo::Base 'Yetie::Controller::Admin';

# sub init_form {
#     my ( $self, $form, $rs ) = @_;
#
#     $form->field('product_id')->value('111');
#     return $self->SUPER::init_form();
# }

sub index {
    my $self = shift;

    my $form = $self->form('search');
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->do_validate;

    my $page     = $form->param('page')     || 1;
    my $per_page = $form->param('per_page') || 5;

    # 1page当たりの表示件数
    # cookieに保存する
    #limit -dmm
    #items_per_page cs
    #page_count

    my $rs          = $self->app->schema->resultset('Product');
    my $products_rs = $rs->search(
        {},
        {
            order_by => { -desc => [ 'updated_at', 'created_at' ] },
            page     => $page,
            rows     => $per_page,
        }
    );

    my $data = {
        meta_title   => '',
        breadcrumbs  => [],
        form         => $form,
        product_list => $products_rs->to_data( { no_relation => 1 } ),
        pager        => $products_rs->pager,
    };
    my $products = $self->factory('entity-products')->create($data);

    $self->stash( content => $products );
    $self->render();
}

1;
