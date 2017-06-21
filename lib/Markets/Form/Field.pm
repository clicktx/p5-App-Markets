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
    delete $attr{$_} for qw/field_key type label/;

    my @time  = qw(datetime date month time week);
    my @other = qw(file hidden password);
    for my $name ( @time, @other, qw(color email number range search tel text url) ) {
        return _input( $self, method => "${name}_field", %attr, @_ ) if $method eq $name;
    }

    # textarea
    # select
    # checkbox radio

    Carp::croak "Undefined subroutine &${package}::$method called";
}

sub _input {
    my $self = shift;
    my %arg  = @_;

    my $method = delete $arg{method};
    return sub { shift->$method( $self->name, %arg ) };
}

sub _label {
    my $self = shift;
    return sub {
        my $app = shift;
        $app->label_for( $self->id => $app->__( $self->label ) );
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
