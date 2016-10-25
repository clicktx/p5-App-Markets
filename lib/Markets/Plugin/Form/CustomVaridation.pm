package Markets::Plugin::Form::CustomVaridation;
use Mojo::Base -base;

has c          => sub { shift->{c} };
has formfields => sub { shift->{formfields} };

# [WIP] 言語で切り替えるのではなく地域で切り替えるべき
our %NUMBER_RE = (
    en => '^(?:-?\d+|-?\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$',
    de => '^-?(?:\d+|\d{1,3}(?:\.\d{3})+)(?:,\d+)?$',
    ru => '^-?(?:\d+|\d{1,3}(?:\ \d{3})+)(?:,\d+)?$',
    fr => '^-?(?:\d+|\d{1,3}(?:\ \d{3})+)(?:,\d+)?$',
);

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
    $err_msg ||= $self->c->__x( 'Enter a value greater than or equal to {int}',
        { int => $int } );
    $self->formfields->is_minimal( $name, $int, $err_msg );
}

sub max {
    my ( $self, $name, $int, $err_msg ) = @_;
    $err_msg ||= $self->c->__x( 'Enter a value less than or equal to {int}',
        { int => $int } );
    $self->formfields->is_maximum( $name, $int, $err_msg );
}

sub range {
    my ( $self, $name, $min, $max, $err_msg ) = @_;
    $err_msg ||= $self->c->__x( 'Enter a value between {min} and {max}',
        { min => $min, max => $max } );
    $self->formfields->is_range( $name, $min, $max, $err_msg );
}

sub step    { }
sub email   { }
sub url     { }
sub date    { }
sub dateISO { }

# 数字（正負、桁区切り、小数点含む）
# [世界各国での数字の区切り方](http://coliss.com/articles/build-websites/operation/writing/53.html)
sub number {
    my ( $self, $name, $value, $err_msg ) = @_;
    $err_msg ||= $self->c->__('Invalid number');
    my $lang = $self->c->language;
    my $regexp = $NUMBER_RE{$lang} || $NUMBER_RE{en};

    $self->formfields->is_number( $name, $value, $regexp, $err_msg );
}

# 整数のみ
sub digits {
    my ( $self, $name, $value, $err_msg ) = @_;
    $err_msg ||= $self->c->__('Only digits');
    $self->formfields->is_digits( $name, $value, $err_msg );
}

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

sub is_minimal {
    my ( $int, $err_msg ) = @_;
    $err_msg ||= "Enter a value greater than or equal to $int";
    return sub {
        return if !defined( $_[0] ) || $_[0] eq '';
        return if $_[0] >= $int;
        return $err_msg;
    };
}

sub is_maximum {
    my ( $int, $err_msg ) = @_;
    $err_msg ||= "Enter a value less than or equal to $int";
    return sub {
        return if !defined( $_[0] ) || $_[0] eq '';
        return if $_[0] <= $int;
        return $err_msg;
    };
}

sub is_range {
    my ( $min, $max, $err_msg ) = @_;
    $err_msg ||= "Enter a value between $min and $max";
    return sub {
        return if !defined( $_[0] ) || $_[0] eq '';
        return if $_[0] >= $min && $_[0] <= $max;
        return $err_msg;
    };
}

sub is_number {
    my ( $value, $regexp, $err_msg ) = @_;
    $err_msg ||= 'Invalid number';
    return sub {
        return if !defined( $_[0] ) || $_[0] eq '';
        return
          if defined $_[0]
          && $_[0] =~ /$regexp/;
        return $err_msg;
    };
}

sub is_digits {
    my ( $value, $err_msg ) = @_;
    $err_msg ||= 'Only digits';
    return sub {
        return if !defined( $_[0] ) || $_[0] eq '';
        return if defined $_[0] && $_[0] =~ /^\d+$/;
        return $err_msg;
    };
}

1;
