package Markets::Controller::Catalog::Category;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;

    my $category_id   = $self->stash('category_id');
    my $category_name = $self->stash('category_name');

    my $rs = $self->app->schema->resultset('Category');
    $self->stash( rs => $rs );

    my $category;
    $category = $rs->find($category_id);
    return $self->reply->not_found() unless $category;

    my $form = $self->form_set();
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->validate;

    my $page = $form->param('page') || 1;


    my $products = $self->schema->resultset('Product')->search(
        { 'product_categories.category_id' => $category_id },
        {
            prefetch => { product_categories => 'detail' },
            page     => 1,
            rows     => 3,
        },
    );
    my $pager = $products->pager;

    my $params = $form->params->to_hash;
    $self->stash( title => $category->title, products => $products, pager => $pager, params => $params );
    $self->render();
}

1;
