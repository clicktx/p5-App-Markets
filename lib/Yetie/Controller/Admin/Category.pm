package Yetie::Controller::Admin::Category;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;

    my $form = $c->form('admin-category');
    my $rs   = $c->app->schema->resultset('Category');
    $c->stash( rs => $rs );

    # Init form
    my $tree    = $c->service('category')->get_category_tree;
    my $choices = $tree->get_attributes_for_choices_form();
    unshift @{$choices}, [ 'None(root)' => '' ];
    $form->field('parent_id')->choices($choices);
    $c->init_form();

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Validation
    # 同階層の同名カテゴリを作成しない
    my ( $title, $parent_id ) = ( $form->param('title'), $form->param('parent_id') );
    if ( $rs->has_title( $title, $parent_id ) ) {
        $form->validation->error( title => ['duplicate_title'] );
        return $c->render( status => 409 );
    }

    # Create category
    $rs->create_category( $title, $parent_id );

    # Logging
    $c->logging_info('admin.category.created');
    return $c->redirect_to('rn.admin.category');
}

sub edit {
    my $c = shift;

    my $category_id = $c->stash('category_id');

    # Initialize form
    my $form = $c->form('admin-category');
    my $entity = $c->service('category')->find_category( $category_id, $form );
    $form->fill_in($entity);

    return $c->reply->not_found() if !$entity->has_id;

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    $entity->title( $form->param('title') );
    return $c->render() if !$entity->is_modified;

    # update
    $c->schema->resultset('Category')->update_category( $entity, [] );

    # Logging
    $c->logging_info( 'admin.category.edited', category_id => $category_id );

    return $c->redirect_to( $c->current_route, category_id => $category_id );
}

1;
