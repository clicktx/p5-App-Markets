package Markets::Controller::Admin::Category;
use Mojo::Base 'Markets::Controller::Admin';

sub index {
    my $self = shift;

    my $rs = $self->app->schema->resultset('Category');

    # my $root = $rs->create( { name => 'C' } );
    # my $child1 = $root->add_to_children( { name => 'D' } );
    # $rs->find(2)->add_to_children( { name => 'E' } )->add_to_children( { name => 'F' } );
    # $rs->find(2)->add_to_children( { name => 'G' } );
    # $rs->find(2)->create_leftmost_child( { name => 'H' } );

    use DDP;
    # my @root_nodes = $rs->search( { level => 0 } );
    # foreach my $node (@root_nodes) {
    #     print "id=", $node->id, ", field1=", $node->name, "\n";
    #     my $desc_rs = $node->descendants;
    #     while ( my $desc = $desc_rs->next ) {
    #         print '**' x $desc->level, " id=", $desc->id, ", field1=", $desc->name, "\n";
    #     }
    # }

    $self->render(rs=>$rs);
}

1;
