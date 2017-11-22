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

=head1 TAG HELPER METHODS

Return code refference.
All methods is L<Mojolicious::Plugin::TagHelpers> wrapper method.

=head2 C<checkbox>

    my $f = Yetie::Form::Field->new(
        name    => 'agreed',
        value   => 'yes',
        label   => 'I agreed',
        checked => 1,
    );
    say $f->checkbox($c);

    # HTML
    <label><input checked name="agreed" type="checkbox" value="yes">I agreed</label>

=head2 C<choice>

    my $f = Yetie::Form::Field->new( name => 'country' );
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ) ] );
    # Select field
    $f->multiple(0);
    $f->expanded(0);

    <select id="country" name="country">
        <optgroup label="EU">
            <option value="de">de</option>
            <option value="en">en</option>
        </optgroup>
        <optgroup label="Asia">
            <option value="cn">China</option>
            <option selected="selected" value="jp">Japan</option>
        </optgroup>
    </select>

    # Select field multiple
    my $f = Yetie::Form::Field->new( name => 'country[]' );
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ) ] );
    $f->multiple(1);
    $f->expanded(0);

    <select id="country" multiple name="country[]">
        <optgroup label="EU">
            <option value="de">de</option>
            <option value="en">en</option>
        </optgroup>
        <optgroup label="Asia">
            <option value="cn">China</option>
            <option selected="selected" value="jp">Japan</option>
        </optgroup>
    </select>

Rendering Select Field and Select Field multiple tag.
See L<Mojolicious::Plugin::TagHelpers/select_field>

    $f->choices( [ [ Japan => 'jp' ], [ Germany => 'de', checked => 1 ], 'cn' ] );

    # Radio button
    $f->multiple(0);
    $f->expanded(1);
    say $f->choice($c);

    # HTML
    <fieldset class="form-choice-group">
        <div class="form-choice-item">
            <label><input name="country" type="radio" value="jp">Japan</label>
        </div>
        <div class="form-choice-item">
            <label><input name="country" type="radio" value="de">Germany</label>
        </div>
        <div class="form-choice-item">
            <label><input name="country" type="radio" value="cn">cn</label>
        </div>
    </fieldset>

    # Check box
    my $f = Yetie::Form::Field->new( name => 'country[]' );
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ) ] );
    $f->multiple(1);
    $f->expanded(1);
    say $f->choice($c);

    # HTML
    <fieldset class="form-choice-group">
        <div class="form-choice-item">
            <label><input name="country[]" type="checkbox" value="jp">Japan</label>
        </div>
        <div class="form-choice-item">
            <label><input name="country[]" type="checkbox" value="de">Germany</label>
        </div>
        <div class="form-choice-item">
            <label><input name="country[]" type="checkbox" value="cn">cn</label>
        </div>
    </fieldset>

    # Group choices
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', checked => 1 ] ] ) ] );
    say $f->choice($c);

    # HTML
    <fieldset class="form-choice-groups">
        <fieldset class="form-choice-group">
            <legend>EU</legend>
            <div class="form-choice-item">
                <label><input name="country[]" type="checkbox" value="de">de</label>
            </div>
            <div class="form-choice-item">
                <label><input name="country[]" type="checkbox" value="en">en</label>
            </div>
        </fieldset>
        <fieldset class="form-choice-group">
            <legend>Asia</legend>
            <div class="form-choice-item">
                <label><input name="country[]" type="checkbox" value="cn">China</label>
            </div>
            <div class="form-choice-item">
                <label><input checked name="country[]" type="checkbox" value="jp">Japan</label>
            </div>
        </fieldset>
    </fieldset>

In case of C<multiple>, it is necessary to add "[]" after the field name.
This field always has multiple values.

    # eg.
    {
        'country[]' => [ 'value1' ]
        'city[]' => [ 'value1', 'value2' ]
    }

=head2 C<color>

=head2 C<date>

=head2 C<datetime>

=head2 C<email>

=head2 C<file>

=head2 C<help_block>

    # plain text
    my $f = Yetie::Form::Field->new(
        name    => 'name',
        help   => 'Your name.',
    );
    say $f->help_block($c);

    # HTML
    <span class="">Your name.</span>

    # code refference
    my $f = Yetie::Form::Field->new(
        name    => 'password',
        help   => sub {
            shift->__x(
                'Must be {low}-{high} characters long.',
                { low => 4, high => 8 },
            )
        },
    );
    say $f->help_block($c);

    # HTML
    <span class="">Must be 4-8 characters long.</span>

Render help block.

C<I18N>

Default $c->__($text) or code refference $code($c)
See L<Mojolicious::Plugin::LocaleTextDomainOO>

=head2 C<label_for>

=head2 C<month>

=head2 C<number>

=head2 C<hidden>

=head2 C<password>

=head2 C<radio>

    my $f = Yetie::Form::Field->new(
        name    => 'agreed',
        value   => 'yes',
        label   => 'I agreed',
        checked => 1,
    );
    say $f->radio($c);

    # HTML
    <label><input checked name="agreed" type="radio" value="yes">I agreed</label>

=head2 C<range>

=head2 C<search>

=head2 C<select>

=head2 C<tel>

=head2 C<text>

=head2 C<textarea>

    my $f = Yetie::Form::Field->new(
        name          => 'description',
        label         => 'Description',
        cols          => 40,
        default_value => 'default text',
    );

    say $f->textarea($c);

    # HTML
    <textarea name="description" cols="40">default text</textarea>

    $f->value('text text text');
    say $f->textarea($c);

    # HTML
    <textarea name="description" cols="40">text text text</textarea>

In textarea, "default_value" and "value" is treated as content text.

=head2 C<time>

=head2 C<url>

=head2 C<week>

=head1 SEE ALSO

L<Mojolicious::Plugin::TagHelpers>, L<Yetie::Form>, L<Yetie::Form::Base>, L<Yetie::Form::FieldSet>

=cut
