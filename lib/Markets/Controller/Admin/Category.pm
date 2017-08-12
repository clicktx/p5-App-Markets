package Markets::Controller::Admin::Category;
use Mojo::Base 'Markets::Controller::Admin';

sub form_choices {
    my ( $self, $form, $rs ) = @_;

    my @tree = ( [ None => 0 ] );
    my @root_nodes = $rs->search( { level => 0 } );
    foreach my $node (@root_nodes) {
        push @tree, [ $node->title => $node->id ];
        my $itr = $node->descendants;
        while ( my $desc = $itr->next ) {
            push @tree, [ '¦   ' x $desc->level . $desc->title => $desc->id ];
        }
    }

    # Parent category
    $form->field('parent_id')->choices( \@tree );
}

sub index {
    my $self = shift;

    my $rs = $self->app->schema->resultset('Category');
    $self->stash( rs => $rs );

    my $form = $self->form_set();
    $self->form_choices( $form, $rs );
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
