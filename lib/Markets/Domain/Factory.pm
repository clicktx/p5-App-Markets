package Markets::Domain::Factory;
use Mojo::Base -base;
use Carp 'croak';
use Scalar::Util 'weaken';

has [qw/app construct_class/];

sub construct {
    my $self = shift;

    delete $self->{app};
    my $construct_class = delete $self->{construct_class};

    return bless $self, $construct_class;
}

sub new {
    my ( $self, $params ) = @_;

    # Attributes
    $self->attr( [ keys %{$params} ] );    # TODO: 不要かもしれないので検討する

    my $factory = $self->SUPER::new( %{$params} );
    weaken $factory->{app};
    return $factory->construct();
}

sub params {
    my $self   = shift;
    my %params = %{$self};
    delete $params{app};
    delete $params{construct_class};
    return \%params;
}

1;
__END__

=head1 NAME

Markets::Domain::Factory

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head2 C<app>

    my $app  = $factory->app;
    $factory = $factory->app(Mojolicious->new);

A reference back to the application that dispatched to this factory, usually
a L<Mojolicious> object.

=head2 C<construct_class>

    my $construct_class = $factory->construct_class;

Get namespace as a construct class.

=head2 C<params>

    my $params = $factory->params;

Get object parameter. Return Hash reference.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Mojo::Base>
