package Yetie::Controller::Catalog::Dropin;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;

    $c->continue_url( $c->continue_url );
    return $c->redirect_to( $c->continue_url ) if $c->is_logged_in;

    # Initialize form
    my $form = $c->form('auth-dropin');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # magic link
    my $settings = {
        email        => $form->param('email'),
        continue_url => $c->continue_url,
    };
    my $magic_link = $c->service('authentication')->create_magic_link($settings);

    # WIP: send email
    say $magic_link->to_abs;
    $c->flash( magic_link => $magic_link->to_abs );

    return $c->redirect_to('RN_email_sent_magic_link');
}

1;
