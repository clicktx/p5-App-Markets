package Markets::Controller::Admin::Category;
use Mojo::Base 'Markets::Controller::Admin';

sub init_form {
    my ( $self, $form, $rs ) = @_;

    my @tree = ( [ None => 0 ] );
    my @root_nodes = $rs->search( { level => 0 } );
    foreach my $node (@root_nodes) {
        push @tree, [ $node->name => $node->id ];
        my $itr = $node->descendants;
        while ( my $desc = $itr->next ) {
            push @tree, [ '¦   ' x $desc->level . $desc->name => $desc->id ];
        }
    }

    # Parent category
    $form->field('parent_id')->choices( \@tree );

    return $self->SUPER::init_form();
}

sub index {
    my $self = shift;

    my $rs = $self->app->schema->resultset('Category');
    $self->stash( rs => $rs );

    my $form = $self->form_set();
    $self->init_form( $form, $rs );

    return $self->render() unless $form->has_data;

    return $self->render() unless $form->validate;

    if ( $form->param('parent_id') ) {

        # Create children node
        my $parent = $rs->find( $form->param('parent_id') );
        $parent->add_to_children( { name => $form->param('name') } );
    }
    else {
        # Create root node
        $rs->create( { name => $form->param('name') } );
    }

    # redirect_to

    # my $root = $rs->create( { name => 'C' } );
    # my $child1 = $root->add_to_children( { name => 'D' } );
    # $rs->find(2)->add_to_children( { name => 'E' } )->add_to_children( { name => 'F' } );
    # $rs->find(2)->add_to_children( { name => 'G' } );
    # $rs->find(2)->create_leftmost_child( { name => 'H' } );

    # my @root_nodes = $rs->search( { level => 0 } );
    # foreach my $node (@root_nodes) {
    #     print "id=", $node->id, ", field1=", $node->name, "\n";
    #     my $desc_rs = $node->descendants;
    #     while ( my $desc = $desc_rs->next ) {
    #         print '**' x $desc->level, " id=", $desc->id, ", field1=", $desc->name, "\n";
    #     }
    # }

    $self->render();
}

1;
