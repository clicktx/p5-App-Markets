package Yetie::Controller::Catalog::Signup;
use Mojo::Base 'Yetie::Controller::Catalog';

# NOTE: リクエストに一定期間の時間制限をかける
sub index {
    my $c = shift;

    # Initialize form
    my $form = $c->form('auth-magic_link');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # magic link
    my $settings = {
        email        => $form->param('email'),
        action       => 'signup',
        continue_url => 'rn.signup.done',
    };
    my $magic_link = $c->service('authentication')->create_magic_link($settings);

    # WIP: send email
    say $magic_link->to_abs;
    $c->flash( magic_link => $magic_link->to_abs );

    return $c->redirect_to('rn.email.sent.magic_link');
}

sub done {
    my $c = shift;
    return $c->render();
}

sub password {
    my $c = shift;
    return $c->reply->message();
}

1;
