package Markets::Model::Data::Configure;
use Mojo::Base 'MojoX::Model';

sub addons {
    my $self = shift;
    my $db   = $self->app->db;

    my @rows = $db->search_by_sql(
        q{
            SELECT addons.id, addons.name, addons.is_enabled, GROUP_CONCAT(addon_hooks.hook_name) AS hooks , GROUP_CONCAT(addon_hooks.priority) AS priorities
            FROM addons
            LEFT JOIN addon_hooks on addons.id = addon_hooks.addon_id
            GROUP BY addons.id
        },
    );
    my $result = {};
    foreach my $row (@rows) {
        my $data = $row->get_columns;
        $result->{ $data->{name} } = {
            is_enabled => $data->{is_enabled},
            hooks      => [],
        };

        if ( $data->{hooks} ) {
            my @hooks      = split( /,/, $data->{hooks} );
            my @priorities = split( /,/, $data->{priorities} );
            foreach ( my $i = 0 ; $i < @hooks ; $i++ ) {
                $result->{ $data->{name} }->{config}->{hook_priorities}
                  ->{ $hooks[$i] } = $priorities[$i];
            }
        }
    }
    return $result;
}

1;

__END__

=head1 NAME

Markets::Model::Data::Configure

=head1 SYNOPSIS

App Controller.
Snake case or Package name.

    package Markets::Web::Controller::Example;
    use Mojo::Base 'Mojolicious::Controller';

    sub example {
        my $self = shift;

        my $data = $self->model('data-configure')->method;
        # or
        my $data = $self->model('Data::Configure')->method;
    }

=head1 DESCRIPTION

=head1 METHODS

=head2 addons

    # Loading indtalled Addons
    my $addon_config = $app->model('data-configure')->addons;

load addon preferences from DB.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Mojolicious::Plugin::Model> L<MojoX::Model>
