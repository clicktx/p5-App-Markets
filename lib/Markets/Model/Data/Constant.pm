package Markets::Model::Data::Constant;
use Mojo::Base 'MojoX::Model';

sub load {
    my $self        = shift;
    my $db          = $self->app->db;
    my @rows        = $db->search( 'constants', {} );
    my $constants = {};

    foreach my $row (@rows) {
        my $data = $row->get_columns;
        $constants->{ $data->{name} } =
          $data->{value} ? $data->{value} : $data->{default_value};
    }
    return $constants;
}

1;
__END__

=head1 NAME

Markets::Model::Data::Constant

=head1 SYNOPSIS

App Controller.
Snake case or Package name.

    package Markets::Web::Controller::Example;
    use Mojo::Base 'Mojolicious::Controller';

    sub exsample {
        my $self = shift;

        my $constants = $self->model('data-constant')->load;
        # or
        my $constants = $self->model('Data::Constant')->load;
    }

=head1 DESCRIPTION

=head1 METHODS

=head2 load

load application preferences.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Mojolicious::Plugin::Model> L<MojoX::Model>
