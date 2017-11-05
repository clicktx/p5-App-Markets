package Yetie::Schema::ResultSet::Addon;
use Mojo::Base 'Yetie::Schema::Base::ResultSet';

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

Yetie::Schema::ResultSet::Addon

=head1 SYNOPSIS

    my $data = $schema->resultset('Addon')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Addon> inherits all attributes from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Addon> inherits all methods from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<configure>

    # Loading indtalled Addons
    my $addon_config = $schema->resultset('addon')->configure;

load addon preferences from DB.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Base::ResultSet>, L<Yetie::Schema>
