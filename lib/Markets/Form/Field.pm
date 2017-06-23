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

    my %attr = %{$self};
    $attr{id} = $self->id;
    delete $attr{$_} for qw(field_key type label);

    # hidden
    return _hidden( $self, %attr, @_ ) if $method eq 'hidden';

    # textarea
    return _textarea( $self, %attr, @_ ) if $method eq 'textarea';

    # input
    for my $name (qw(email number search tel text url password)) {
        return _input( $self, method => "${name}_field", %attr, @_ ) if $method eq $name;
    }
    for my $name (qw(color range date month time week file)) {
        delete $attr{$_} for qw(placeholder);
        return _input( $self, method => "${name}_field", %attr, @_ ) if $method eq $name;
    }

    # checkbox/radio
    if ( $method eq 'checkbox' || $method eq 'radio' ) {

        # true to "checked"
        $attr{checked} ? $attr{checked} = undef : delete $attr{checked};
        return _input( $self, method => 'check_box',    %attr, @_ ) if $method eq 'checkbox';
        return _input( $self, method => 'radio_button', %attr, @_ ) if $method eq 'radio';
    }

    # select
    return _select( $self, %attr, @_ ) if $method eq 'select';

    # choice
    return _choice_widget( $self, %attr, @_ ) if $method eq 'choice';

    Carp::croak "Undefined subroutine &${package}::$method called";
}

# check_box or radio_button into the label
sub _choice_field {
    my ( $c, $values, $pair ) = ( shift, shift, shift );

    $pair = [ $pair, $pair ] unless ref $pair eq 'ARRAY';

    my %attrs = ( value => $pair->[1], @$pair[ 2 .. $#$pair ], @_ );
    delete $attrs{checked} if keys %$values;
    $attrs{checked} = undef if $attrs{checked} || $values->{ $pair->[1] };

    my $method = delete $attrs{type} eq 'checkbox' ? 'check_box' : 'radio_button';
    my $checkbox = $c->$method( $attrs{name} => %attrs );

    my $label = $c->__( $pair->[0] );
    return $c->tag( 'label', sub { $checkbox . $label } );
}

sub _choice_widget {
    my $field = shift;
    my %arg   = @_;

    my $choices = delete $arg{choices} || [];
    my $multiple = delete $arg{multiple} ? 1 : 0;
    my $expanded = delete $arg{expanded} ? 1 : 0;
    my $flag     = $multiple . $expanded;

    # radio
    if ( $flag == 1 ) {
        $arg{type} = 'radio';
        return _list_field( $field, $choices, %arg );
    }

    # select-multiple
    elsif ( $flag == 10 ) {
        $arg{multiple} = undef;
        return sub {
            my $c = shift;
            $c->select_field( $field->name => _choices_for_select( $c, $choices ), %arg );
        };
    }

    # checkbox
    elsif ( $flag == 11 ) {
        $arg{type} = 'checkbox';
        return _list_field( $field, $choices, %arg );
    }

    # select
    else {
        return sub {
            my $c = shift;
            $c->select_field( $field->name => _choices_for_select( $c, $choices ), %arg );
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
            my %attr = ( @{$group}[ 2 .. $#$group ] );
            $attr{selected} ? $attr{selected} = 'selected' : delete $attr{selected};
            $group = [ $label, $value, %attr ];
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
    my %arg   = @_;

    my $method = delete $arg{method};
    return sub {
        my $c = shift;
        $arg{placeholder} = $c->__( $arg{placeholder} ) if $arg{placeholder};
        $c->$method( $field->name, %arg );
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
    my %arg     = @_;

    # NOTE: multipleの場合はname属性を xxx[] に変更する？
    my $name = $arg{name};
    delete $arg{$_} for qw(id value);

    return sub {
        my $c = shift;

        my %values = map { $_ => 1 } @{ $c->every_param($name) };

        my $groups = "\n";
        for my $group ( @{$choices} ) {
            if ( blessed $group && $group->isa('Mojo::Collection') ) {
                my ( $label, $values, %attrs ) = @$group;

                $label = $c->__($label);
                my $content = join "\n", map { $c->tag( 'li', _choice_field( $c, \%values, $_, %arg ) ) } @$values;
                $content = $c->tag( 'ul', sub { "\n" . $content . "\n" } );
                $groups .= $c->tag( 'li', sub { $label . "\n" . $content . "\n" } ) . "\n";
            }
            else {
                my $row = _choice_field( $c, \%values, $group, %arg );
                $groups .= $c->tag( 'li' => sub { $row } ) . "\n";
            }
        }
        $c->tag( 'ul' => sub { $groups } );
    };
}

sub _select {
    my $field   = shift;
    my %arg     = @_;
    my $choices = delete $arg{choices} || [];

    return sub {
        my $c = shift;
        $c->select_field( $field->name => _choices_for_select( $c, $choices ), %arg );
    };
}

sub _textarea {
    my $field         = shift;
    my %arg           = @_;
    my $default_value = delete $arg{default_value};

    return sub {
        my $c = shift;
        $arg{placeholder} = $c->__( $arg{placeholder} ) if $arg{placeholder};
        $c->text_area( $field->name => $c->__($default_value), %arg );
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

=head1 SEE ALSO

=cut
