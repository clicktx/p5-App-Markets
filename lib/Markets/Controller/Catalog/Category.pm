package Markets::Controller::Catalog::Category;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
    use DDP;
    p $self->service('customer');    # debug
    $self->service('customer')->add_history;
}

1;
