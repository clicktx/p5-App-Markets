package Yetie::Controller::Admin::Preference;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;
    $c->stash( preferences => $c->pref->properties );

    my $validation = $c->validation;
    $c->render() unless $validation->has_data;

    my $form = $c->form('admin-preference');
    if ( $form->do_validate ) {
        for my $name ( @{ $form->params->names } ) {
            $c->pref( $name => $form->param($name) );
        }
        $c->service('preference')->store;
    }
    $c->render();
}

1;
