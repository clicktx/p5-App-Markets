package Markets::Form::Field;
use Mojo::Base -base;
use Carp qw/croak/;

has id => sub { $_ = shift->name; s/\./_/g; $_ };
has [qw/field_key name type label help error_message default_value value placeholder/];

sub AUTOLOAD {
    my $self = shift;
    my ( $package, $method ) = our $AUTOLOAD =~ /^(.+)::(.+)$/;

    # label
    return _label( $self, @_ ) if $method eq 'label_for';

    # input
    my %attr = %{$self};
    $attr{id} = $self->id;
    delete $attr{$_} for qw(field_key type label);

    my @basic = qw(email number search tel text url password);
    my @other = qw(color range date month time week file);
    for my $name (@basic) {
        return _input( $self, method => "${name}_field", %attr, @_ ) if $method eq $name;
    }
    for my $name (@other) {
        delete $attr{$_} for qw(placeholder);
        return _input( $self, method => "${name}_field", %attr, @_ ) if $method eq $name;
    }

    # hidden
    return _hidden( $self, %attr, @_ ) if $method eq 'hidden';

    # textarea
    return _text_area( $self, %attr, @_ ) if $method eq 'textarea';

    # select
    # checkbox radio

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

sub _text_area {
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
