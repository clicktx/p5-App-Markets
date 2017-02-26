package Markets::Model::Data;
use Mojo::Base 'Markets::Model';

sub load_pref {
    my $self = shift;

    my $rs   = $self->app->schema->resultset('Preference');
    my $pref = {};
    while ( my $row = $rs->next ) {
        $pref->{ $row->key_name } = $row->value ? $row->vallue : $row->default_value;
    }
    return $pref;
}

1;
__END__

=head1 NAME

Markets::Model::Data - Data Access Layer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Model> L<Mojolicious::Plugin::Model> L<MojoX::Model>
