package Markets::Controller::Catalog::Category;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
    $self->model('service-customer')->add_history($self);
}

1;
