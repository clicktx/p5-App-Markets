package Markets::Model::Common;
use Mojo::Base 'Markets::Model';

sub load_pref {
    my $self = shift;
    my $pref = $self->app->defaults('pref') || {};
    return $pref if %$pref;

    # Load from DB
    my $rs   = $self->app->schema->resultset('Preference');
    while ( my $row = $rs->next ) {
        $pref->{ $row->key_name } = $row->value ? $row->vallue : $row->default_value;
    }

    $self->app->defaults( pref => $pref );
    return $pref;
}

1;
__END__

=head1 NAME

Markets::Model::Common

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 C<load_pref>

    my $preferences = $app->model('common')->load_pref;

Return %$preferences

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Model> L<Mojolicious::Plugin::Model> L<MojoX::Model>
