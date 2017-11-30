package Yetie::Controller::Admin::Category;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $self = shift;

    my $form = $self->form('admin-category');
    my $rs   = $self->app->schema->resultset('Category');
    $self->stash( rs => $rs );

    # Init form
    my $tree = $rs->get_category_choices;
    unshift @{$tree}, [ None => 0 ];
    $form->field('parent_id')->choices($tree);
    $self->init_form();

    return $self->render() unless $form->has_data;

    return $self->render() unless $form->validate;

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
    return $self->render();
}

1;
