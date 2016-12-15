package Markets::DB;
use Mojo::Base 'Teng';
use Carp qw(croak);

sub merge_schema {
    my ( $self, $classes ) = @_;
    my $dbh = $self->dbh;
    unless ($dbh) {
        croak "missing mandatory parameter 'dbh' or 'connect_info'";
    }

    foreach my $schema_class (@$classes) {
        Class::Load::load_class($schema_class);
        my $schema = $schema_class->instance;
        if (!$schema){
            croak "schema object was not passed, and could not get schema instance from $schema_class";
        }
        $schema->prepare_from_dbh($dbh);
        my $tables = $schema->tables;
        map { $self->schema->tables->{$_} = $tables->{$_} } keys %{$tables};
        # foreach my $name(keys %$tables){
        #     $self->schema->add_table($tables->{$name});
        # }
    }
}

1;
