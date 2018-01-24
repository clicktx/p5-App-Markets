package Yetie::Controller::Admin::Orders;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $self = shift;

    my $form = $self->form('search');
    $self->init_form();

    # return $self->render() unless $form->has_data;
    return $self->render() unless $form->do_validate;

    my $orders = $self->service('orders')->content($form);
    $self->stash( content => $orders );

    $self->render();
}

1;
