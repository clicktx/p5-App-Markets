package Markets::Domain::Factory;
use Mojo::Base -base;
use Carp 'croak';
use Scalar::Util 'weaken';

has [qw/app construct_class/];

sub new {
    my ( $self, $params ) = @_;

    # Attributes
    $self->attr( [ keys %{$params} ] );

    my $factory = $self->SUPER::new( %{$params} );
    weaken $factory->{app};
    return $factory->construct() if $factory->can('construct');

    # Factory class nothing
    # delete $params->{app}; # TODO: appは消す？
    my $construct_class = delete $params->{construct_class};

    my $domain = $construct_class->new( %{$params} );
    weaken $domain->{app};
    return $domain;
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

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Mojo::Base>
