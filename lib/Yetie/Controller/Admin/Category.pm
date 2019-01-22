package Yetie::Controller::Admin::Category;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;

    my $form = $c->form('admin-category');
    my $rs   = $c->app->schema->resultset('Category');
    $c->stash( rs => $rs );

    # Init form
    my $tree = $rs->get_category_choices;
    $form->field('parent_id')->choices($tree);
    $c->init_form();

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() unless $form->do_validate;

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
    $c->redirect_to('RN_admin_category');
}

sub edit {
    my $c = shift;

    my $category_id = $c->stash('category_id');

    # Initialize form
    my $form = $c->form('admin-category');
    my $entity = $c->service('category')->find_category( $category_id, $form );
    $form->fill_in($entity);

    return $c->reply->not_found() unless $entity->has_id;

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() unless $form->do_validate;

    $entity->title( $form->param('title') );
    return $c->render() unless $entity->is_modified;

    # update
    $c->schema->resultset('Category')->update_category( $entity, [] );

    # Logging
    $c->logging_info( 'admin.category.edited', category_id => $category_id );

    return $c->redirect_to( $c->current_route, category_id => $category_id );
}

1;
