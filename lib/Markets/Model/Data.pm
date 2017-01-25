package Markets::Model::Data;
use Mojo::Base 'MojoX::Model';

sub load_pref {
    my $self = shift;
    my @rows = $self->app->db->search( 'preferences', {} );

    my $pref = {};
    foreach my $row (@rows) {
        my $data = $row->get_columns;
        $pref->{ $data->{key} } = $data->{value} ? $data->{value} : $data->{default_value};
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

L<Mojolicious::Plugin::Model> L<MojoX::Model>
