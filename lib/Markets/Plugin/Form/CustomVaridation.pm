package Markets::Plugin::Form::CustomVaridation;
use Mojo::Base -base;

has c          => sub { shift->{c} };
has formfields => sub { shift->{formfields} };

# From https://jqueryvalidation.org/documentation/
sub required {
    my ( $self, $name, $err_msg ) = @_;
    $err_msg ||= $self->c->__('Required');
    $self->formfields->is_required( $name, $err_msg );
}

sub min_length {
    my ( $self, $name, $length, $err_msg ) = @_;
    $err_msg ||= $self->c->__x( 'Must be at least {length} symbols',
        { length => $length } );
    $self->formfields->is_long_at_least( $name, $length, $err_msg );
}

sub max_length {
    my ( $self, $name, $length, $err_msg ) = @_;
    $err_msg ||= $self->c->__x( 'Must be at the most {length} symbols',
        { length => $length } );
    $self->formfields->is_long_at_most( $name, $length, $err_msg );
}

sub range_length {
    my ( $self, $name, $min, $max, $err_msg ) = @_;
    $err_msg ||= $self->c->__x( 'Must be between {min} and {max} symbols',
        { min => $min, max => $max } );
    $self->formfields->is_long_between( $name, $min, $max, $err_msg );
}

sub min {
    my ( $self, $name, $int, $err_msg ) = @_;
}

sub max {
    my ( $self, $name, $int, $err_msg ) = @_;
}

sub range {
    my ( $self, $name, $min, $max, $err_msg ) = @_;
}
sub step    { }
sub email   { }
sub url     { }
sub date    { }
sub dateISO { }
sub number  { }
sub digits  { }

sub equal_to {
    my ( $self, $name, $other, $err_msg ) = @_;
    $err_msg ||= $self->c->__('Invalid value');
    $self->formfields->is_equal( $name, $other, $err_msg );
}

# accept – Makes a file upload accept only specified mime-types.
# creditcard – Makes the element require a credit card number.
# extension – Makes the element require a certain file extension.
# phoneUS – Validate for valid US phone number.
# require_from_group – Ensures a given number of fields in a group are complete.

# Your custom validation for Validate::Tiny method.
package Validate::Tiny;

sub is_example {
    say "is_example";
    my $err_msg = shift || 'This is example validation';
    return sub {
        return if defined $_[0] && $_[0] ne '';
        return $err_msg;
    };
}

1;
