package Yetie::Controller::Admin::Preference;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;
    $c->stash( preferences => $c->pref->properties );

    # Initialize form
    my $form = $c->form('admin-preference');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() unless $form->do_validate;

    for my $name ( @{ $form->params->names } ) {
        $c->pref( $name => $form->param($name) );
    }
    $c->service('preference')->store;

    return $c->render();
}

1;
