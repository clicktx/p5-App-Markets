package Markets::Form::Field;
use Mojo::Base -base;
use Carp qw/croak/;
use Scalar::Util qw/blessed/;
use Mojo::Collection 'c';

has id => sub { $_ = shift->name; s/\./_/g; $_ };
has [qw(field_key default_value choices help label error_message)];
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
        $attr{checked} ? $attr{checked} = 'checked' : delete $attr{checked};
        return _input( $self, method => 'check_box',    %attr, @_ ) if $method eq 'checkbox';
        return _input( $self, method => 'radio_button', %attr, @_ ) if $method eq 'radio';
    }

    # select
    return _select( $self, %attr, @_ ) if $method eq 'select';

    # [WIP] choice
    # return _choice( $self, %attr, @_ ) if $method eq 'choice';

    Carp::croak "Undefined subroutine &${package}::$method called";
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
        my $app = shift;
        $arg{placeholder} = $app->__( $arg{placeholder} ) if $arg{placeholder};
        $app->$method( $field->name, %arg );
    };
}

sub _label {
    my $field = shift;
    return sub {
        my $app = shift;
        $app->label_for( $field->id => $app->__( $field->label ) );
    };
}

sub _select {
    my $field   = shift;
    my %arg     = @_;
    my $choices = delete $arg{choices} || [];

    return sub {
        my $app = shift;
        $app->select_field( $field->name => _choices( $app, $choices ), %arg );
    };
}

# I18N and bool selected
sub _choices {
    my $app     = shift;
    my $choices = shift;

    for my $group ( @{$choices} ) {
        next unless ref $group;

        # optgroup
        if ( blessed $group && $group->isa('Mojo::Collection') ) {
            my ( $label, $values, %attrs ) = @{$group};
            $label  = $app->__($label);
            $values = _choices( $app, $values );
            $group  = c( $label => $values, %attrs );
        }
        else {
            my ( $label, $value ) = @{$group};
            $label = $app->__($label);

            # true to "selected"
            my %attr = ( @{$group}[ 2 .. $#$group ] );
            $attr{selected} ? $attr{selected} = 'selected' : delete $attr{selected};
            $group = [ $label, $value, %attr ];
        }
    }
    return $choices;
}

sub _textarea {
    my $field         = shift;
    my %arg           = @_;
    my $default_value = delete $arg{default_value};

    return sub {
        my $app = shift;
        $arg{placeholder} = $app->__( $arg{placeholder} ) if $arg{placeholder};
        $app->text_area( $field->name => $app->__($default_value), %arg );
    };
}

1;
__END__

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
