package Markets::Controller::Admin::Products;
use Mojo::Base 'Markets::Controller::Admin';

# sub init_form {
#     my ( $self, $form, $rs ) = @_;
#
#     $form->field('product_id')->value('111');
#     return $self->SUPER::init_form();
# }

sub index {
    my $self = shift;

    # my $form = $self->form_set();
    # return $self->render() unless $form->has_data;

    my $rs = $self->app->schema->resultset('Product');
    my $itr = $rs->search( {} );

    $self->render( itr => $itr );
}

1;
