package Markets::Controller::Admin::Preference;
use Mojo::Base 'Markets::Controller::Admin';

sub index {
    my $self = shift;
    $self->stash( preferences => $self->pref->items );

    my $validation = $self->validation;
    $self->render() unless $validation->has_data;

    my $form = $self->form_set('admin-preference');
    if ( $form->validate ) {
        for my $name ( @{ $form->params->names } ) {
            $self->pref( $name => $form->param($name) );
        }
        $self->service('preference')->store;
    }
    $self->render();
}

1;
