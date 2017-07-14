package Markets::Schema::ResultSet::Addon;
use Mojo::Base 'Markets::Schema::Base::ResultSet';

sub configure {
    my $self = shift;

    my $itr = $self->search( {}, { prefetch => 'triggers' } );
    my $conf;
    while ( my $addon = $itr->next ) {
        $conf->{ $addon->name } = {
            triggers   => [],
            is_enabled => $addon->is_enabled,
        };
        my @triggers = $addon->triggers or next;
        foreach my $trigger (@triggers) {
            $conf->{ $addon->name }->{config}->{trigger_priorities}->{ $trigger->trigger_name } =
              $trigger->priority;
        }
    }
    return $conf;
}

1;
__END__
=encoding utf8

=head1 NAME

Markets::Schema::ResultSet::Addon

=head1 SYNOPSIS

    my $data = $schema->resultset('Addon')->method();

=head1 DESCRIPTION

=head1 METHODS

=head2 C<configure>

    # Loading indtalled Addons
    my $addon_config = $schema->resultset('addon')->configure;

load addon preferences from DB.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Schema::Base::ResultSet>, L<Markets::Schema>
