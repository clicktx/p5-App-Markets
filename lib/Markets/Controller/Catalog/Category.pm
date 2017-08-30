package Markets::Controller::Catalog::Category;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;

    my $category_id   = $self->stash('category_id');
    my $category_name = $self->stash('category_name');

    my $rs = $self->app->schema->resultset('Category');
    $self->stash( rs => $rs );

    my $category = $rs->find( $category_id, { prefetch => { products => 'product' } } );
    return $self->reply->not_found() unless $category;

    my $form = $self->form_set();
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->validate;

    my $page = $form->param('page') || 1;

    # 下位カテゴリ取得
    my @category_ids = $category->descendant_ids;

    # 下位カテゴリに所属するproductsも全て取得
    # NOTE: SQLが非効率な可能性高い
    my $products = $self->schema->resultset('Product')->search(
        { 'product_categories.category_id' => { IN => \@category_ids } },
        {
            prefetch => 'product_categories',
            page     => $page,
            rows     => 3,
        },
    );
    my $pager = $products->pager;

    my $params = $form->params->to_hash;
    $self->stash(
        title    => $category->title,
        category => $category,
        products => $products,
        pager    => $pager,
        params   => $params
    );
    $self->render();
}

1;
