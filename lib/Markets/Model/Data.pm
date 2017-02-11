package Markets::Model::Data;
use Mojo::Base 'Markets::Model';

sub load_pref {
    my $self = shift;
    my @rows   = $self->app->dbic->resultset('Preference')->all;

    my $pref = {};
    foreach my $row (@rows) {
        $pref->{ $row->key } = $row->value ? $row->vallue : $row->default_value;
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
