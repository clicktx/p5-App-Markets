package Markets::Controller::Admin::Product;
use Mojo::Base 'Markets::Controller::Admin';

sub index {
    my $self = shift;

    # my $form = $self->form_set();
    # return $self->render() unless $form->has_data;

    my $rs = $self->app->schema->resultset('Product');
    my $itr = $rs->search( {} );

    $self->render( itr => $itr );
}

1;
