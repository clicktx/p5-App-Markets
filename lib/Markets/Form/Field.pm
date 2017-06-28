package Markets::Form::Field;
use Mojo::Base -base;
use Carp qw/croak/;
use Scalar::Util qw/blessed/;
use Mojo::Collection 'c';

our $required_class = 'form-required-field-icon';
our $required_icon  = '*';

has id => sub { $_ = shift->name; s/\./_/g; $_ };
has [qw(field_key default_value choices help label error_message multiple expanded)];
has [qw(name type value placeholder checked)];

sub AUTOLOAD {
    my $self = shift;
    my ( $package, $method ) = our $AUTOLOAD =~ /^(.+)::(.+)$/;

    my %attrs = %{$self};
    delete $attrs{$_} for qw(filters validations);
    $attrs{id} = $self->id;
    $attrs{required} ? $attrs{required} = undef : delete $attrs{required};

    # label
    return _label(%attrs) if $method eq 'label_for';

    # hidden
    delete $attrs{$_} for qw(field_key type label);
    return _hidden( %attrs, @_ ) if $method eq 'hidden';

    # textarea
    return _textarea( %attrs, @_ ) if $method eq 'textarea';

    # input
    for my $name (qw(email number search tel text url password)) {
        return _input( "${name}_field", %attrs, @_ ) if $method eq $name;
    }
    for my $name (qw(color range date month time week file datetime)) {
        delete $attrs{$_} for qw(placeholder);
        return _input( "${name}_field", %attrs, @_ ) if $method eq $name;
    }

    # checkbox/radio
    if ( $method eq 'checkbox' || $method eq 'radio' ) {
        delete $attrs{id};
        $attrs{type} = $method;

        my @args = @_;
        return sub {
            my $c = shift;
            my %values = map { $_ => 1 } @{ $c->every_param( $attrs{name} ) };
            _choice_field( $c, \%values, $self->label, %attrs, @args );
        };
    }

    # select
    return _select( %attrs, @_ ) if $method eq 'select';

    # choice
    return _choice_widget( %attrs, @_ ) if $method eq 'choice';

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
sub _choice_widget {
    my %args = @_;

    my $choices = delete $args{choices} || [];
    my $multiple = delete $args{multiple} ? 1 : 0;
    my $expanded = delete $args{expanded} ? 1 : 0;
    my $flag     = $multiple . $expanded;

    # radio
    if ( $flag == 1 ) {
        $args{type} = 'radio';
        return _list_field( $choices, %args );
    }

    # select-multiple
    elsif ( $flag == 10 ) {
        $args{multiple} = undef;

        # my $name = (delete $args{name}) . '[]';
        my $name = delete $args{name};
        return sub {
            my $c = shift;
            $c->select_field( $name => _choices_for_select( $c, $choices ), %args );
        };
    }

    # checkbox
    elsif ( $flag == 11 ) {

        # $args{name} = $args{name}. '[]';
        $args{type} = 'checkbox';
        return _list_field( $choices, %args );
    }

    # select
    else {
        my $name = delete $args{name};
        return sub {
            my $c = shift;
            $c->select_field( $name => _choices_for_select( $c, $choices ), %args );
        };
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

sub _hidden {
    my %attrs = @_;
    return sub { shift->hidden_field( $attrs{name} => $attrs{value} ) };
}

sub _input {
    my $method = shift;
    my %attrs  = @_;

    my $name          = delete $attrs{name};
    my $default_value = delete $attrs{default_value};

    if ( $method eq 'password_field' || $method eq 'file_field' ) {
        return sub {
            my $c = shift;
            $attrs{placeholder} = $c->__( $attrs{placeholder} ) if $attrs{placeholder};
            $c->$method( $name, %attrs );
        };
    }
    else {
        return sub {
            my $c = shift;
            $attrs{placeholder} = $c->__( $attrs{placeholder} ) if $attrs{placeholder};

            delete $attrs{value} unless defined $attrs{value};
            $c->$method( $name => $c->__($default_value), %attrs );
        };
    }
}

sub _label {
    my %attrs = @_;

    return sub {
        my $c = shift;

        my $required_html =
          exists $attrs{required}
          ? '<span class="' . $required_class . '">' . $required_icon . '</span>'
          : '';
        my $content = $c->__( $attrs{label} ) . $required_html;
        $c->label_for( $attrs{id} => sub { $content } );
    };
}

# checkbox list or radio button list
sub _list_field {
    my $choices = shift;
    my %args    = @_;

    delete $args{$_} for qw(id value);
    return sub {
        my $c = shift;

        my %values = map { $_ => 1 } @{ $c->every_param( $args{name} ) };

        my $root_class;
        my $groups = '';
        for my $group ( @{$choices} ) {
            if ( blessed $group && $group->isa('Mojo::Collection') ) {
                my ( $label, $values, %attrs ) = @$group;
                $root_class = 'form-choice-groups' unless $root_class;

                $label = $c->__($label);
                my $content = join '',
                  map { $c->tag( 'li', class => 'form-choice-item', _choice_field( $c, \%values, $_, %args ) ) }
                  @$values;
                $content = $c->tag( 'ul', class => 'form-choices', sub { $content } );
                $groups .= $c->tag( 'li', class => 'form-choice-group', %attrs, sub { $label . $content } );
            }
            else {
                $root_class = 'form-choices' unless $root_class;
                my $row = _choice_field( $c, \%values, $group, %args );
                $groups .= $c->tag( 'li', class => 'form-choice-item', sub { $row } );
            }
        }
        $c->tag( 'ul', class => $root_class, sub { $groups } );
    };
}

sub _select {
    my %attrs = @_;

    my $choices = delete $attrs{choices} || [];
    my $name = delete $attrs{name};
    return sub {
        my $c = shift;
        $c->select_field( $name => _choices_for_select( $c, $choices ), %attrs );
    };
}

sub _textarea {
    my %attrs = @_;

    my $name          = delete $attrs{name};
    my $default_value = delete $attrs{default_value};

    return sub {
        my $c = shift;
        $attrs{placeholder} = $c->__( $attrs{placeholder} ) if $attrs{placeholder};
        $c->text_area( $name => $c->__($default_value), %attrs );
    };
}

1;
__END__

=encoding utf8

=head1 NAME

Markets::Form::Field

=head1 SYNOPSIS

    package Markets::Form::Type::User;
    use Mojo::Base -strict;
    use Markets::Form::Field;

    has_field email => (
        type        => 'email',
        placeholder => 'use@mail.com',
        label       => 'E-mail',
        required    => 1,
        class       => 'hoge-class',
        filters     => [],
        validations => [],
    );

    has_field 'item.[].id' => (
        type  => 'hidden',
    );

    has_field country => (
        type     => 'choice',
        expanded => 0,
        multiple => 1,
        choices  => [
            c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
            c( Asia => [ [ Chaina => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ),
        ],
    );


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
    say $f->checkbox->($c);

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
    $f->multiple(1);
    $f->expanded(0);

    <select id="country" multiple name="country">
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
    say $f->choice->($c);

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
    $f->multiple(1);
    $f->expanded(1);
    say $f->choice->($c);

    # HTML
    <ul class="form-choices">
        <li class="form-choice-item">
            <label><input name="country" type="checkbox" value="jp">Japan</label>
        </li>
        <li class="form-choice-item">
            <label><input checked name="country" type="checkbox" value="de">Germany</label>
        </li>
        <li class="form-choice-item">
            <label><input name="country" type="checkbox" value="cn">cn</label>
        </li>
    </ul>

    # Group choices
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', checked => 1 ] ] ) ] );
    say $f->choice->($c);

    # HTML
    <ul class="form-choice-groups">
        <li class="form-choice-group">EU
            <ul class="form-choices">
                <li class="form-choice-item">
                    <label><input name="country" type="checkbox" value="de">de</label>
                </li>
                <li class="form-choice-item">
                    <label><input name="country" type="checkbox" value="en">en</label>
                </li>
            </ul>
        </li>
        <li class="form-choice-group">Asia
            <ul class="form-choices">
                <li class="form-choice-item">
                    <label><input name="country" type="checkbox" value="cn">China</label>
                </li>
                <li class="form-choice-item">
                    <label><input checked name="country" type="checkbox" value="jp">Japan</label>
                </li>
            </ul>
        </li>
    </ul>

=head2 C<color>

=head2 C<date>

=head2 C<datetime>

=head2 C<email>

=head2 C<file>

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
    say $f->radio->($c);

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
