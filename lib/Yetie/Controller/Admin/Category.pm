package Yetie::Controller::Admin::Category;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $self = shift;

    my $form = $self->form_set('admin-category');
    my $rs   = $self->app->schema->resultset('Category');
    $self->stash( rs => $rs );

    # Init form
    my $tree = $rs->get_category_choices;
    unshift @{$tree}, [ None => 0 ];
    $form->field('parent_id')->choices($tree);
    $self->init_form();

    return $self->render() unless $form->has_data;

    return $self->render() unless $form->validate;

    if ( $form->param('parent_id') ) {

        # Create children node
        my $parent = $rs->find( $form->param('parent_id') );
        $parent->add_to_children( { title => $form->param('title') } );
    }
    else {
        # Create root node
        $rs->create( { title => $form->param('title') } );
    }

    # redirect_to

    # my $root = $rs->create( { title => 'C' } );
    # my $child1 = $root->add_to_children( { title => 'D' } );
    # $rs->find(2)->add_to_children( { title => 'E' } )->add_to_children( { title => 'F' } );
    # $rs->find(2)->add_to_children( { title => 'G' } );
    # $rs->find(2)->create_leftmost_child( { title => 'H' } );

    # my @root_nodes = $rs->search( { level => 0 } );
    # foreach my $node (@root_nodes) {
    #     print "id=", $node->id, ", field1=", $node->title, "\n";
    #     my $desc_rs = $node->descendants;
    #     while ( my $desc = $desc_rs->next ) {
    #         print '**' x $desc->level, " id=", $desc->id, ", field1=", $desc->title, "\n";
    #     }
    # }

    $self->render();
}

1;
