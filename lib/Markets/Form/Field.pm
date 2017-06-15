package Markets::Form::Field;
use Mojo::Base -base;

has [qw/name type label help error_message default_value value/];

1;

=encoding utf8

=head1 NAME

Markets::Form::Field

=head1 SYNOPSIS

    package MyForm::Field::User;
    use Markets::Form::Field;

    has_field 'name';

=head1 DESCRIPTION

=head1 SEE ALSO

=cut
