package Yetie::Form::Field;
use Mojo::Base -base;

has error_messages => sub { +{} };
has [qw(field_key default_value choices help label multiple expanded required)];
has [qw(name type value placeholder checked selected choiced)];

sub append_class {
    my ( $self, $class ) = @_;
    $self->{class} .= $self->{class} ? " $class" : $class;
}

sub append_error_class { shift->append_class('field-with-error') }

sub data {
    my $self = shift;
    @_ > 1 ? my %pair = @_ : return $self->{ 'data-' . $_[0] };
    $self->{ 'data-' . $_ } = $pair{$_} for keys %pair;
}

sub error_message {
    my $self = shift;

    # Getter
    return $self->error_messages unless @_;
    my %args = @_ > 1 ? @_ : ref $_[0] eq 'HASH' ? %{ $_[0] } : return $self->error_messages->{ $_[0] };

    # Setter
    my %messages = %{ $self->error_messages };
    $messages{$_} = $args{$_} for keys %args;
    $self->error_messages( \%messages );
}

1;
__END__

=encoding utf8

=head1 NAME

Yetie::Form::Field

=head1 SYNOPSIS

    my $field = Yetie::Form::Field->new(
        field_key     => 'email',
        name          => 'email',
        label         => 'E-mail',
    );

    say $field->label($c);
    say $field->text($c);

    # Rendering HTML
    # <label for="email">E-mail</label>
    # <input id="email" type="text" name="email">


    # In templetes using helpers
    %= form_label('example#password_again')
    %= form_widget('example#password_again')
    %= form_help('example#password_again')
    %= form_error('example#password_again')

    # Or more smart!
    %= form_field('example#password_again')
    %= form_label
    %= form_widget
    %= form_help
    %= form_error


=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<id>

=head2 C<field_key>

=head2 C<default_value>

=head2 C<choices>

=head2 C<help>

=head2 C<label>

=head2 C<error_messages>

=head2 C<multiple>

In case of C<multiple>, it is necessary to add "[]" after the field name.
This field always has multiple values.

    # eg.
    {
        'country[]' => [ 'value1' ]
        'city[]' => [ 'value1', 'value2' ]
    }

=head2 C<expanded>

=head2 C<required>

=head2 C<name>

=head2 C<type>

=head2 C<value>

=head2 C<placeholder>

=head2 C<checked>

=head2 C<selected>

=head2 C<choiced>

Alias C<checked> and C<selected>.

If set C<checked> or C<selected> together, this parameter takes precedence.

=head1 METHODS

L<Yetie::Form::Field> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<append_class>

    $field->append_class('foo');

Append class to field.

=head2 C<append_error_class>

    $field->append_error_class;

    # Longer version
    $field->append_class('field-with-error');

Append class "field-with-error" to field.

=head2 C<data>

    # Get value from "data-foo" attribute
    my $data_foo = $field->data('foo');

    # Set attributes data-*
    $field->data( foo => 'bar', baz => 'bar', ... );

=head2 C<error_message>

    # Getter
    my $hashref = $field->error_message();
    my $string = $field->error_message('foo');

    # Setter
    $field->error_message( foo => 'foo', bar => 'bar' );
    $field->error_message( { foo => 'foo', bar => 'bar' } );

Get / Set error messages.

    # In controller example
    $form_set->field('foo')->error_message('error message {0} and {1}');
    $form_set->field('foo')->error_message( bar_error => sub { ... } );

=head1 SEE ALSO

L<Yetie::Form>, L<Yetie::Form::Base>, L<Yetie::Form::FieldSet>, L<Yetie::Form::TagHelpers>

=cut
