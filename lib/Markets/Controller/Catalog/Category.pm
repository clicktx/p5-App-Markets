package Markets::Controller::Catalog::Category;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
    # $self->model('service-customer')->add_history($self);
    use DDP;
    p $self->model('service-customer');
    p $self->service('customer');
    # p $self->app;
    $self->service('customer')->add_history;
}

1;
