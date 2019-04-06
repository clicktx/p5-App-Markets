package Yetie::Controller::Catalog::Dropin;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;
    $c->flash( ref => $c->flash('ref') );

    my $route = $c->flash('ref') || 'RN_home';
    return $c->redirect_to($route) if $c->is_logged_in;

    # Initialize form
    my $form = $c->form('customer-dropin');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() unless $form->do_validate;

    $c->service('email')->send_magic_link( $form->param('email'), $route );
}

1;
