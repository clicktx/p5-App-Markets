package Markets::Form::Field;
use Mojo::Base -base;
use Carp qw/croak/;
use Scalar::Util qw/blessed/;
use Mojo::Collection 'c';

has id => sub { $_ = shift->name; s/\./_/g; $_ };
has [qw(field_key default_value choices help label error_message multiple expanded)];
has [qw(name type value placeholder checked)];

sub AUTOLOAD {
    my $self = shift;
    my ( $package, $method ) = our $AUTOLOAD =~ /^(.+)::(.+)$/;

    # label
    return _label( $self, @_ ) if $method eq 'label_for';

    my %attrs = %{$self};
    $attrs{id} = $self->id;
    delete $attrs{$_} for qw(field_key type label);

    # hidden
    return _hidden( $self, %attrs, @_ ) if $method eq 'hidden';

    # textarea
    return _textarea( $self, %attrs, @_ ) if $method eq 'textarea';

    # input
    for my $name (qw(email number search tel text url password)) {
        return _input( $self, method => "${name}_field", %attrs, @_ ) if $method eq $name;
    }
    for my $name (qw(color range date month time week file datetime)) {
        delete $attrs{$_} for qw(placeholder);
        return _input( $self, method => "${name}_field", %attrs, @_ ) if $method eq $name;
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
    return _select( $self, %attrs, @_ ) if $method eq 'select';

    # choice
    return _choice_widget( $self, %attrs, @_ ) if $method eq 'choice';

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

sub _choice_widget {
    my $field = shift;
    my %args   = @_;

    my $choices = delete $args{choices} || [];
    my $multiple = delete $args{multiple} ? 1 : 0;
    my $expanded = delete $args{expanded} ? 1 : 0;
    my $flag     = $multiple . $expanded;

    # radio
    if ( $flag == 1 ) {
        $args{type} = 'radio';
        return _list_field( $field, $choices, %args );
    }

    # select-multiple
    elsif ( $flag == 10 ) {
        $args{multiple} = undef;
        return sub {
            my $c = shift;
            $c->select_field( $field->name => _choices_for_select( $c, $choices ), %args );
        };
    }

    # checkbox
    elsif ( $flag == 11 ) {
        $args{type} = 'checkbox';
        return _list_field( $field, $choices, %args );
    }

    # select
    else {
        return sub {
            my $c = shift;
            $c->select_field( $field->name => _choices_for_select( $c, $choices ), %args );
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
    my $field = shift;
    return sub { shift->hidden_field( $field->name, $field->value, @_ ) };
}

sub _input {
    my $field = shift;
    my %args   = @_;

    my $method = delete $args{method};
    return sub {
        my $c = shift;
        $args{placeholder} = $c->__( $args{placeholder} ) if $args{placeholder};
        $c->$method( $field->name, %args );
    };
}

sub _label {
    my $field = shift;
    return sub {
        my $c = shift;
        $c->label_for( $field->id => $c->__( $field->label ) );
    };
}

# checkbox list or radio button list
sub _list_field {
    my $field   = shift;
    my $choices = shift;
    my %args     = @_;

    # NOTE: multipleの場合はname属性を xxx[] に変更する？
    my $name = $field->name;
    delete $args{$_} for qw(id value);

    return sub {
        my $c = shift;

        my %values = map { $_ => 1 } @{ $c->every_param($name) };

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
    my $field   = shift;
    my %args     = @_;
    my $choices = delete $args{choices} || [];

    return sub {
        my $c = shift;
        $c->select_field( $field->name => _choices_for_select( $c, $choices ), %args );
    };
}

sub _textarea {
    my $field         = shift;
    my %args           = @_;
    my $default_value = delete $args{default_value};

    return sub {
        my $c = shift;
        $args{placeholder} = $c->__( $args{placeholder} ) if $args{placeholder};
        $c->text_area( $field->name => $c->__($default_value), %args );
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

    has_field email => ( type => 'email', placeholder => 'use@mail.com', label => 'E-mail' );

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
