package Markets::Model::Addon;
use Mojo::Base 'Markets::Model';

sub configure {
    my $self   = shift;

    my $schema = $self->app->schema;
    my $rs = $schema->resultset('Addon')->search( {}, { prefetch => 'triggers' } );

    my $conf;
    while ( my $addon = $rs->next ) {
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

=head1 NAME

Markets::Model::Addon

=head1 SYNOPSIS

Snake case or Package name.

    my $data = $app->model('addon')->method;
    # or
    my $data = $app->model('Addon')->method;

=head1 DESCRIPTION

=head1 METHODS

=head2 C<configure>

    # Loading indtalled Addons
    my $addon_config = $app->model('addon')->configure;

load addon preferences from DB.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Model> L<Mojolicious::Plugin::Model> L<MojoX::Model>
