package Yetie::Controller::Catalog::Register;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;

    my $form = $c->form('catalog-register');
    return $c->render() unless $form->has_data;

    # Validation form
    return $c->render() unless $form->do_validate;

    # Registration customer data
    # Create login session
    $c->redirect_to('RN_customer_register_done');

    #Registration – Activate a New Account by Email
    # Verification Token
    # The VerificationToken Entity
    # Add the enabled Field to User
    # Using a Spring Event to Create the Token and Send the Verification Email
    #
    # The Event and The Listener
    # The RegistrationListener Handles the OnRegistrationCompleteEvent
    # Processing the Verification Token Parameter
    # RegistrationController Processing the Registration Confirmation
    # Adding Account Activation Checking to the Login Process
    # CustomAuthenticationFailureHandler:
}

sub done {
    my $c = shift;
    return $c->render();
}

1;
