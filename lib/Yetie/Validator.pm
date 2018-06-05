package Yetie::Validator;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Util qw(monkey_patch);
use FormValidator::Simple::Validator;

# 数字（正負、桁区切り、小数点含む）
# [世界各国での数字の区切り方](http://coliss.com/articles/build-websites/operation/writing/53.html)
# [WIP] 言語で切り替えるのではなく地域で切り替えるべき
our $NUMBER_RE = {
    US => '^(?:-?\d+|-?\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$',
    JP => '^(?:-?\d+|-?\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$',
    DE => '^-?(?:\d+|\d{1,3}(?:\.\d{3})+)(?:,\d+)?$',
    RU => '^-?(?:\d+|\d{1,3}(?:\ \d{3})+)(?:,\d+)?$',
    FR => '^-?(?:\d+|\d{1,3}(?:\ \d{3})+)(?:,\d+)?$',
};

# messages from [jQuery Validation Plugin](https://github.com/jquery-validation/jquery-validation/blob/master/src/core.js#L344)
# messages: {
#     required: "This field is required.",
#     remote: "Please fix this field.",
#     email: "Please enter a valid email address.",
#     url: "Please enter a valid URL.",
#     date: "Please enter a valid date.",
#     dateISO: "Please enter a valid date (ISO).",
#     number: "Please enter a valid number.",
#     digits: "Please enter only digits.",
#     equalTo: "Please enter the same value again.",
#     maxlength: $.validator.format( "Please enter no more than {0} characters." ),
#     minlength: $.validator.format( "Please enter at least {0} characters." ),
#     rangelength: $.validator.format( "Please enter a value between {0} and {1} characters long." ),
#     range: $.validator.format( "Please enter a value between {0} and {1}." ),
#     max: $.validator.format( "Please enter a value less than or equal to {0}." ),
#     min: $.validator.format( "Please enter a value greater than or equal to {0}." ),
#     step: $.validator.format( "Please enter a multiple of {0}." )
# },

my @methods = (qw(ascii between date datetime decimal email int length max min range time uint url));

# Message for Mojolicious::Validator default validators
my $MESSAGES = {
    ascii    => 'Please enter only as ASCII.',
    between  => 'Please enter a value between {0} and {1}.',
    date     => '',
    datetime => '',
    decimal  => '',
    email    => '',
    equal_to => 'Please enter the same value again.',
    in       => 'Vaule is not a choice.',
    int      => 'Please enter only integer.',
    length   => sub {
        return @_ > 1
          ? 'Please enter a value between {0} and {1} characters long.'
          : 'Please enter a value {0} characters long.';
    },
    like     => 'This field is invalid.',
    max      => 'Please enter a value less than or equal to {0}.',
    min      => 'Please enter a value greater than or equal to {0}.',
    number   => 'Invalid way to divide numbers.',
    time     => '',
    size     => 'Please enter a value between {0} and {1} characters long.',
    uint     => 'Please enter only unsigined integer.',
    upload   => 'This field is invalid.',
    url      => '',
    required => 'This field is required.',
};
$MESSAGES->{range} = $MESSAGES->{between};

sub register {
    my ( $self, $app ) = @_;

    # Add method for Mojolicious::Validator::Validation
    monkey_patch 'Mojolicious::Validator::Validation', 'error_message' => sub {
        my $self = shift;
        my $name = shift;

        my $error = $self->error($name);
        return unless $error;

        my ( $check, $result, @args ) = @{$error};
        my $message = $MESSAGES->{$check};
        return ref $message eq 'CODE' ? $message->(@args) : $message;
    };

    $app->validator->add_check( $_ => \&{ '_' . $_ } ) for @methods;

    my $country = $app->pref('locale_country') || 'US';
    $app->validator->add_check( number => sub { _number( $country, @_ ) } );
}

sub _ascii {
    my ( $validation, $name, $value, @args ) = @_;
    return FormValidator::Simple::Validator->ASCII( [$value], \@args ) ? undef : 1;
}

sub _between {
    my ( $validation, $name, $value, @args ) = @_;
    return FormValidator::Simple::Validator->BETWEEN( [$value], \@args ) ? undef : 1;
}

sub _date { }

sub _datetime { }

sub _decimal { }

sub _email { }

sub _int {
    my ( $validation, $name, $value, @args ) = @_;
    return FormValidator::Simple::Validator->INT( [$value], \@args ) ? undef : 1;
}

sub _length {
    my ( $validation, $name, $value, @args ) = @_;
    return FormValidator::Simple::Validator->LENGTH( [$value], \@args ) ? undef : 1;
}

sub _max {
    my ( $validation, $name, $value, @args ) = @_;
    if ( $value == $args[0] ) { return }
    return FormValidator::Simple::Validator->LESS_THAN( [$value], \@args ) ? undef : 1;
}

sub _min {
    my ( $validation, $name, $value, @args ) = @_;
    if ( $value == $args[0] ) { return }
    return FormValidator::Simple::Validator->GREATER_THAN( [$value], \@args ) ? undef : 1;
}

sub _number {
    my ( $country, $validation, $name, $value ) = @_;
    my $regex = $NUMBER_RE->{$country};
    return FormValidator::Simple::Validator->REGEX( [$value], [$regex] ) ? undef : 1;
}

*_range = \&_between;

sub _time { }

sub _uint {
    my ( $validation, $name, $value, @args ) = @_;
    return FormValidator::Simple::Validator->UINT( [$value], \@args ) ? undef : 1;
}

sub _url { }

1;
__END__
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
    $self->formfields->equal( $name, $other, $err_msg );
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
=encoding utf8

=head1 NAME

Yetie::Validator - Validate values

=head1 SYNOPSIS

=head1 DESCRIPTION

L<Yetie::Validator> validates values for L<Yetie>.

=head1 CHECKS

L<Yetie::Validator> adds all the checks to L<Mojolicious::Validator>.

These validation checks are available.

=head2 C<ascii>

    $validation = $validation->ascii();

=head2 C<between>

    $validation = $validation->between(2, 5);

    # valid 2 or 3 or 4 or 5

Value needs to be between these two values.

=head2 C<date>

=head2 C<datetime>

=head2 C<decimal>

=head2 C<email>

=head2 C<equal_to>

See L<Mojolicious::Validator/equal_to>.

=head2 C<in>

See L<Mojolicious::Validator/in>.

=head2 C<int>

    $validation = $validation->int();

    # valid   1, -5
    # invalid 3.3, a

=head2 C<length>

    $validation = $validation->length(2, 5);
    $validation = $validation->length(3);

String value length in bytes needs to be between these two values.

=head2 C<like>

See L<Mojolicious::Validator/like>.

=head2 C<max>

numeric comparison

    $validation = $validation->max(3);

A value less than or equal.

=head2 C<min>

numeric comparison

    $validation = $validation->min(3);

A value greater than or equal.

=head2 C<number>

    $validation = $validation->number();

It will be affected by application preferences C<locale-country>.

    # e.g. locale-country: US

    # valid
    # 1,000,000.50

    # invalid
    # 1.000.000,50
    # 1 000 000,50

=head2 C<range>

    $validation = $validation->range(2, 5);

Alias L</between> method.

=head2 C<size>

See L<Mojolicious::Validator/size>.

=head2 C<time>

=head2 C<uint>

    $validation = $validation->uint();

    # valid     1, 123
    # invalid   3.3, a, -5

=head2 C<upload>

See L<Mojolicious::Validator/upload>.

=head2 C<url>

=head1 ATTRIBUTES

L<Yetie::Validator> adds all the attributes to L<Mojolicious::Validator>.

=head1 METHODS

L<Yetie::Validator> adds all the methods to L<Mojolicious::Validator>.

=head2 C<error_message>

    say $validator->error_message('foo');

=head1 SEE ALSO

L<FormValidator::Simple::Validator>, L<Mojolicious::Validator>, L<Yetie::Form::FieldSet>

=cut
