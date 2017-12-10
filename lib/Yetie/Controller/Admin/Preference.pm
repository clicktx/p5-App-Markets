package Yetie::Controller::Admin::Preference;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $self = shift;
    $self->stash( preferences => $self->pref->properties );

    my $validation = $self->validation;
    $self->render() unless $validation->has_data;

    my $form = $self->form('admin-preference');
    if ( $form->do_validate ) {
        for my $name ( @{ $form->params->names } ) {
            $self->pref( $name => $form->param($name) );
        }
        $self->service('preference')->store;
    }
    $self->render();
}

1;
