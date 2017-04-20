package Markets::Schema::ResultSetCommon;
# use Mojo::Base 'DBIx::Class::ResultSet';
use Mojo::Base 'DBIx::Class::ResultSet::HashRef';

# ResultCommon::insertで対応しているので不要
# sub create {
#     my $self = shift;
#
#     my $schema = $self->result_source->schema;
#     my $table  = $self->result_source;
#     my $now    = $schema->now;
#     $_[0]->{created_at} = $now if $table->has_column('created_at');
#     $_[0]->{updated_at} = $now if $table->has_column('updated_at');
#
#     $self->next::method(@_);
# }

sub update {
    my $self = shift;

    my $schema = $self->result_source->schema;
    if ( $self->result_source->has_column('updated_at') ) {
        $_[0]->{updated_at} = $schema->now;
    }

    $self->next::method(@_);
}

1;
