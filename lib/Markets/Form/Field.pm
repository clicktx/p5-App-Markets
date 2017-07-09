package Markets::Form::Field;
use Mojo::Base -base;
use Carp qw/croak/;
use Scalar::Util qw/blessed/;
use Mojo::Collection 'c';

our $error_class    = 'form-error-block';
our $help_class     = 'form-help-block';
our $required_class = 'form-required-field-icon';
our $required_icon  = '*';

has id => sub { $_ = shift->name; s/\./_/g; $_ };
has [qw(field_key default_value choices help label error_messages multiple expanded)];
has [qw(name type value placeholder checked)];

sub AUTOLOAD {
    my $self = shift;
    my $c    = shift;
    my ( $package, $method ) = our $AUTOLOAD =~ /^(.+)::(.+)$/;

    my %attrs = %{$self};
    delete $attrs{$_} for qw(filters validations);
    $attrs{id} = $self->id;
    $attrs{required} ? $attrs{required} = undef : delete $attrs{required};

    my $help           = delete $attrs{help};
    my $error_messages = delete $attrs{error_messages};

    # help
    return _help( $c, $help ) if $method eq 'help_block';

    # error message
    return _error( $c, $attrs{name}, $error_messages ) if $method eq 'error_block';

    # label
    return _label( $c, %attrs ) if $method eq 'label_for';

    delete $attrs{$_} for qw(field_key type label);

    # hidden
    return _hidden( $c, %attrs, @_ ) if $method eq 'hidden';

    # textarea
    return _textarea( $c, %attrs, @_ ) if $method eq 'textarea';

    # select
    return _select( $c, %attrs, @_ ) if $method eq 'select';

    # choice
    return _choice_list_widget( $c, %attrs, @_ ) if $method eq 'choice';

    # checkbox/radio
    if ( $method eq 'checkbox' || $method eq 'radio' ) {
        delete $attrs{id};
        $attrs{type} = $method;

        my %values = map { $_ => 1 } @{ $c->every_param( $attrs{name} ) };
        return _choice_field( $c, \%values, $self->label, %attrs, @_ );
    }

    # input
    for my $name (qw(email number search tel text url password)) {
        return _input( $c, "${name}_field", %attrs, @_ ) if $method eq $name;
    }
    for my $name (qw(color range date month time week file datetime)) {
        if ( $method eq $name ) {
            delete $attrs{$_} for qw(placeholder);
            return _input( $c, "${name}_field", %attrs, @_ );
        }
    }

    Carp::croak "Undefined subroutine &${package}::$method called";
}

# check_box or radio_button into the label
sub _choice_field {
    my ( $c, $values, $pair ) = ( shift, shift, shift );

    $pair = [ $pair, $pair ] unless ref $pair eq 'ARRAY';
    my %attrs = ( value => $pair->[1], @$pair[ 2 .. $#$pair ], @_ );

    if ( keys %$values ) { delete $attrs{checked} }
    else {    # default checked(bool)
        $attrs{checked} ? $attrs{checked} = undef : delete $attrs{checked};
    }
    $attrs{checked} = undef if $values->{ $pair->[1] };

    my $method = delete $attrs{type} eq 'checkbox' ? 'check_box' : 'radio_button';
    my $checkbox = $c->$method( $attrs{name} => %attrs );

    my $label = $c->__( $pair->[0] );
    return $c->tag( 'label', sub { $checkbox . $label } );
}

# NOTE: multipleの場合はname属性を xxx[] に変更する？
sub _choice_list_widget {
    my $c    = shift;
    my %args = @_;

    my $choices = delete $args{choices} || [];
    my $multiple = delete $args{multiple} ? 1 : 0;
    my $expanded = delete $args{expanded} ? 1 : 0;
    my $flag     = $multiple . $expanded;

    # Add suffix for multiple
    $args{name} .= '[]' if $multiple;

    # radio
    if ( $flag == 1 ) {
        $args{type} = 'radio';
        return _list_field( $c, $choices, %args );
    }

    # select-multiple
    elsif ( $flag == 10 ) {
        $args{multiple} = undef;
        my $name = delete $args{name};
        return $c->select_field( $name => _choices_for_select( $c, $choices ), %args );
    }

    # checkbox
    elsif ( $flag == 11 ) {
        $args{type} = 'checkbox';
        return _list_field( $c, $choices, %args );
    }

    # select
    else {
        my $name = delete $args{name};
        return $c->select_field( $name => _choices_for_select( $c, $choices ), %args );
    }
}

# I18N and bool selected
# NOTE: This function is used only for "$c->select_field" helper
sub _choices_for_select {
    my $c       = shift;
    my $choices = shift;

    for my $group ( @{$choices} ) {
        next unless ref $group;

        # optgroup
        if ( blessed $group && $group->isa('Mojo::Collection') ) {
            my ( $label, $values, %attrs ) = @{$group};
            $label  = $c->__($label);
            $values = _choices_for_select( $c, $values );
            $group  = c( $label => $values, %attrs );
        }
        else {
            my ( $label, $value ) = @{$group};
            $label = $c->__($label);

            # true to "selected"
            my %attrs = ( @{$group}[ 2 .. $#$group ] );
            $attrs{selected} ? $attrs{selected} = 'selected' : delete $attrs{selected};
            $group = [ $label, $value, %attrs ];
        }
    }
    return $choices;
}

sub _error {
    my ( $c, $name, $error_messages ) = @_;

    my $error = $c->validation->error($name);
    return unless $error;

    my ( $check, $result, @args ) = @{$error};
    my $message = ref $error_messages eq 'HASH' ? $error_messages->{$check} : '';

    # Default error message
    if ( !$message ) { $message = $c->form_error_message( $check, @args ) || 'This field is invalid.' }

    my %args;
    while ( my ( $i, $v ) = each @args ) { $args{$i} = $v }

    my $text = ref $message ? $message->($c) : $c->__x( $message, \%args );
    return $c->tag( 'span', class => $error_class, sub { $text } );
}

sub _help {
    my ( $c, $help ) = @_;

    my $text = ref $help ? $help->($c) : $c->__($help);
    return $c->tag( 'span', class => $help_class, sub { $text } );
}

sub _hidden {
    my $c     = shift;
    my %attrs = @_;
    return $c->hidden_field( $attrs{name} => $attrs{value} );
}

sub _input {
    my $c      = shift;
    my $method = shift;
    my %attrs  = @_;

    my $name          = delete $attrs{name};
    my $default_value = delete $attrs{default_value};

    if ( $method eq 'password_field' || $method eq 'file_field' ) {
        $attrs{placeholder} = $c->__( $attrs{placeholder} ) if exists $attrs{placeholder};
        return $c->$method( $name, %attrs );
    }
    else {
        $attrs{placeholder} = $c->__( $attrs{placeholder} ) if exists $attrs{placeholder};

        $attrs{value} = $c->__($default_value) if $default_value;
        return $c->$method( $name, %attrs );
    }
}

sub _label {
    my $c     = shift;
    my %attrs = @_;

    my $required_html =
      exists $attrs{required} ? $c->tag( 'span', class => $required_class, sub { $required_icon } ) : '';
    my $content = $c->__( $attrs{label} ) . $required_html;
    _validation( $c, $attrs{name}, 'label', for => $attrs{id}, sub { $content } );
}

# checkbox list or radio button list
sub _list_field {
    my $c       = shift;
    my $choices = shift;
    my %args    = @_;

    delete $args{$_} for qw(id value);
    my %values = map { $_ => 1 } @{ $c->every_param( $args{name} ) };

    my $root_class;
    my $groups = '';
    for my $group ( @{$choices} ) {
        if ( blessed $group && $group->isa('Mojo::Collection') ) {
            my ( $label, $values, %attrs ) = @$group;
            $root_class = 'form-choice-groups' unless $root_class;

            $label = $c->__($label);
            my $content = join '',
              map { $c->tag( 'li', class => 'form-choice-item', _choice_field( $c, \%values, $_, %args ) ) } @$values;
            $content = $c->tag( 'ul', class => 'form-choices', sub { $content } );
            $groups .= $c->tag( 'li', class => 'form-choice-group', %attrs, sub { $label . $content } );
        }
        else {
            $root_class = 'form-choices' unless $root_class;
            my $row = _choice_field( $c, \%values, $group, %args );
            $groups .= $c->tag( 'li', class => 'form-choice-item', sub { $row } );
        }
    }
    return _validation( $c, $args{name}, 'ul', class => $root_class, sub { $groups } );
}

sub _select {
    my $c     = shift;
    my %attrs = @_;

    my $choices = delete $attrs{choices} || [];
    my $name = delete $attrs{name};
    return $c->select_field( $name => _choices_for_select( $c, $choices ), %attrs );
}

sub _textarea {
    my $c     = shift;
    my %attrs = @_;

    my $name          = delete $attrs{name};
    my $default_value = delete $attrs{default_value};
    $attrs{placeholder} = $c->__( $attrs{placeholder} ) if exists $attrs{placeholder};

    return $c->text_area( $name => $c->__($default_value), %attrs );
}

# This code from Mojolicious::Plugin::TagHelpers
sub _validation {
    my ( $c, $name ) = ( shift, shift );
    return $c->tag(@_) unless $c->validation->has_error($name);
    return $c->helpers->tag_with_error(@_);
}

1;
__END__

=encoding utf8

=head1 NAME

Markets::Form::Field

=head1 SYNOPSIS

    my $field = Markets::Form::Field->new(
        field_key     => 'email',
        name          => 'email',
        label         => 'EMAIL',
    );

    say $field->label($c);
    say $field->text($c);

    # Rendering HTML
    # <label for="email">EMAIL</label>
    # <input id="email" type="text" name="email">


    # In templetes using helpers
    %= form_label('example.password_again')
    %= form_widget('example.password_again')
    %= form_help('example.password_again')
    %= form_error('example.password_again')

=head1 DESCRIPTION


=head1 METHODS

Return code refference.
All methods is L<Mojolicious::Plugin::TagHelpers> wrapper method.

=head2 C<checkbox>

    my $f = Markets::Form::Field->new(
        name    => 'agreed',
        value   => 'yes',
        label   => 'I agreed',
        checked => 1,
    );
    say $f->checkbox($c);

    # HTML
    <label><input checked name="agreed" type="checkbox" value="yes">I agreed</label>

=head2 C<choice>

    my $f = Markets::Form::Field->new( name => 'country' );
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
    my $f = Markets::Form::Field->new( name => 'country[]' );
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
    <ul class="form-choices">
        <li class="form-choice-item">
            <label><input name="country" type="radio" value="jp">Japan</label>
        </li>
        <li class="form-choice-item">
            <label><input checked name="country" type="radio" value="de">Germany</label>
        </li>
        <li class="form-choice-item">
            <label><input name="country" type="radio" value="cn">cn</label>
        </li>
    </ul>

    # Check box
    my $f = Markets::Form::Field->new( name => 'country[]' );
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ) ] );
    $f->multiple(1);
    $f->expanded(1);
    say $f->choice($c);

    # HTML
    <ul class="form-choices">
        <li class="form-choice-item">
            <label><input name="country[]" type="checkbox" value="jp">Japan</label>
        </li>
        <li class="form-choice-item">
            <label><input checked name="country[]" type="checkbox" value="de">Germany</label>
        </li>
        <li class="form-choice-item">
            <label><input name="country[]" type="checkbox" value="cn">cn</label>
        </li>
    </ul>

    # Group choices
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', checked => 1 ] ] ) ] );
    say $f->choice($c);

    # HTML
    <ul class="form-choice-groups">
        <li class="form-choice-group">EU
            <ul class="form-choices">
                <li class="form-choice-item">
                    <label><input name="country[]" type="checkbox" value="de">de</label>
                </li>
                <li class="form-choice-item">
                    <label><input name="country[]" type="checkbox" value="en">en</label>
                </li>
            </ul>
        </li>
        <li class="form-choice-group">Asia
            <ul class="form-choices">
                <li class="form-choice-item">
                    <label><input name="country[]" type="checkbox" value="cn">China</label>
                </li>
                <li class="form-choice-item">
                    <label><input checked name="country[]" type="checkbox" value="jp">Japan</label>
                </li>
            </ul>
        </li>
    </ul>

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
    my $f = Markets::Form::Field->new(
        name    => 'name',
        help   => 'Your name.',
    );
    say $f->help_block($c);

    # HTML
    <span class="">Your name.</span>

    # code refference
    my $f = Markets::Form::Field->new(
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

    my $f = Markets::Form::Field->new(
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

=head2 C<time>

=head2 C<url>

=head2 C<week>

=head1 SEE ALSO

L<Mojolicious::Plugin::TagHelpers>

=cut
