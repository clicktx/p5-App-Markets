package Markets::Schema::Base::Result;
use Mojo::Base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

sub insert {
    my $self = shift;

    my $schema = $self->result_source->schema;
    my $now    = $schema->now;
    $self->created_at($now) if $self->can('created_at');
    $self->updated_at($now) if $self->can('updated_at');

    $self->next::method(@_);
}

sub update {
    my $self = shift;

    my $schema = $self->result_source->schema;
    if ( $self->can('updated_at') ) {
        $self->updated_at( $schema->now );
    }

    $self->next::method(@_);
}

1;
