package Yetie::Controller::Admin::Category;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $self = shift;

    my $form = $self->form('admin-category');
    my $rs   = $self->app->schema->resultset('Category');
    $self->stash( rs => $rs );

    # Init form
    my $tree = $rs->get_category_choices;
    $form->field('parent_id')->choices($tree);
    $self->init_form();

    return $self->render() unless $form->has_data;

    return $self->render() unless $form->do_validate;

    # Validation
    # 同階層の同名カテゴリを作成しない
    my ( $title, $parent_id ) = ( $form->param('title'), $form->param('parent_id') );
    if ( $rs->has_title( $title, $parent_id ) ) {
        $form->validation->error( title => ['duplicate_title'] );
        return $self->render( status => 409 );
    }

    # Create category
    $rs->create_category( $title, $parent_id );
    $self->redirect_to('RN_admin_category');
}

sub edit {
    my $self = shift;

    my $category_id = $self->stash('category_id');

    my $form = $self->form('admin-category');
    my $entity = $self->service('category')->find_category( $category_id, $form );
    return $self->reply->not_found() unless $entity->has_data;

    $form->fill_in($entity);
    return $self->render() unless $form->has_data;
    return $self->render() unless $form->do_validate;

    $entity->title( $form->param('title') );
    return $self->render() unless $entity->is_modified;

    # update
    $self->schema->resultset('Category')->update_category( $entity, [] );

    my $staff_id = $self->server_session->staff_id;
    $self->app->admin_log->info("ID: $staff_id updated category_id: $category_id");

    return $self->redirect_to( $self->current_route, category_id => $category_id );
}

1;
