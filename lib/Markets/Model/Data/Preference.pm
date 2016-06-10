package Markets::Model::Data::Preference;
use Mojo::Base 'MojoX::Model';

sub load {
    my $self        = shift;
    my $db          = $self->app->db;
    my @rows        = $db->search( 'preferences', {} );
    my $preferences = {};

    foreach my $row (@rows) {
        my $data = $row->get_columns;
        $preferences->{ $data->{name} } =
          $data->{value} ? $data->{value} : $data->{default_value};
    }
    return $preferences;
}

1;
__END__

=head1 NAME

Markets::Model::Data::Preference

=head1 SYNOPSIS

App Controller.
Snake case or Package name.

    package Markets::Web::Controller::Example;
    use Mojo::Base 'Mojolicious::Controller';

    sub exsample {
        my $self = shift;

        my $preferences = $self->model('data-preference')->load;
        # or
        my $preferences = $self->model('Data::Preference')->load;
    }

=head1 DESCRIPTION

=head1 METHODS

=head2 load

load application preferences.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Mojolicious::Plugin::Model> L<MojoX::Model>
