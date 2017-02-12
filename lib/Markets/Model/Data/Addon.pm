package Markets::Model::Data::Addon;
use Mojo::Base 'Markets::Model';

sub configure {
    my $self = shift;
    my $db = $self->app->dbic;

    my $addons = $db->resultset('Addon')->search(
        {},
        {
            join     => 'hooks',
            prefetch => 'hooks',
        }
    );

    my $conf;
    while ( my $addon = $addons->next ) {
        $conf->{ $addon->name } = {
            hooks      => [],
            is_enabled => $addon->is_enabled,
        };
        my @hooks = $addon->hooks or next;
        foreach my $hook (@hooks) {
            $conf->{ $addon->name }->{config}->{hook_priorities}->{ $hook->hook_name } =
              $hook->priority;
        }
    }

    return $conf;
}

1;

__END__

=head1 NAME

Markets::Model::Data::Addon

=head1 SYNOPSIS

App Controller.
Snake case or Package name.

    package Markets::Controller::Catalog::Example;
    use Mojo::Base 'Markets::Controller::Catalog';

    sub example {
        my $self = shift;

        my $data = $self->model('data-addon')->method;
        # or
        my $data = $self->model('Data::Addon')->method;
    }

=head1 DESCRIPTION

=head1 METHODS

=head2 configure

    # Loading indtalled Addons
    my $addon_config = $app->model('data-addon')->configure;

load addon preferences from DB.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Model> L<Mojolicious::Plugin::Model> L<MojoX::Model>
