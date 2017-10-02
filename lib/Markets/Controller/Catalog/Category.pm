package Markets::Controller::Catalog::Category;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;

    my $category_id = $self->stash('category_id');
    my $form        = $self->form_set();
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->validate;

    my $rs       = $self->app->schema->resultset('Category');
    my $category = $rs->find($category_id);
    return $self->reply->not_found() unless $category;

    # Category tree
    # NOTE: 階層やカテゴリ数によってSQLが多く実行されるためキャッシュした方が良い
    my $category_tree = $self->service('category_tree')->create_entity();
    $self->stash( category_tree => $category_tree );

    # 下位カテゴリ取得
    my @category_ids = $category->descendant_ids;

    # 下位カテゴリに所属するproductsも全て取得
    # NOTE: SQLが非効率な可能性高い
    my $products = $self->schema->resultset('Product')->search(
        { 'product_categories.category_id' => { IN => \@category_ids } },
        {
            prefetch => 'product_categories',
            page     => $form->param('p') || 1,
            rows     => 3,
        },
    );

    my @breadcrumb;
    my $itr = $category->ancestors;
    while ( my $ancestor = $itr->next ) {
        push @breadcrumb,
          {
            title => $ancestor->title,
            uri   => $self->url_for(
                'RN_category_name_base' => { category_name => $ancestor->title, category_id => $ancestor->id }
            )
          };
    }
    push @breadcrumb,
      {
        title => $category->title,
        uri   => $self->url_for(
            'RN_category_name_base' => { category_name => $category->title, category_id => $category_id }
        )
      };

    # content entity
    my $content = $self->app->factory('entity-content')->create(
        {
            title      => $category->title,
            breadcrumb => \@breadcrumb,
            pager      => $products->pager,
            params     => $form->params->to_hash,
        }
    );

    $self->stash(
        content  => $content,
        products => $products,
    );

    return $self->render();
}

1;
