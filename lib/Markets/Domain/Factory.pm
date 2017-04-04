package Markets::Domain::Factory;
use Mojo::Base -base;
use Carp 'croak';
use Mojo::Util;
use Mojo::Loader;

has entity_class => sub {
    my $class = ref shift;
    $class =~ s/::Factory//;
    $class;
};

sub cook { }

sub create { shift->create_entity(@_) }

sub create_entity {
    my $self = shift;

    # cooking entity
    $self->cook();

    my $params = { %{$self} };
    my $args = @_ ? @_ > 1 ? {@_} : { %{ $_[0] } } : {};

    # no need attributes
    delete $params->{entity_class};

    _load_class( $self->entity_class );
    return $self->entity_class->new( %{$params}, %{$args} );
}

sub factory {
    my ( $self, $ns ) = ( shift, shift );
    $ns = Mojo::Util::camelize($ns) if $ns =~ /^[a-z]/;
    Carp::croak 'Argument empty' unless $ns;

    my $factory_base_class = __PACKAGE__;
    my $factory_class      = $factory_base_class . '::' . $ns;
    my $entity_class       = $factory_class;
    $entity_class =~ s/::Factory//;

    # factory classが無い場合はデフォルトのfactory classを使用
    my $e = Mojo::Loader::load_class($factory_class);
    die "Exception: $e" if ref $e;

    my $factory = $e ? $factory_base_class->SUPER::new(@_) : $factory_class->new(@_);
    $factory->entity_class($entity_class);
    return $factory;
}

sub params {
    my $self = shift;
    return wantarray ? ( %{$self} ) : { %{$self} } if !@_;

    # Setter
    my %args = @_ > 1 ? @_ : %{ $_[0] };
    $self->{$_} = $args{$_} for keys %args;
}

sub _load_class {
    my $class = shift;

    if ( my $e = Mojo::Loader::load_class($class) ) {
        die ref $e ? "Exception: $e" : "$class not found!";
    }
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

=head2 C<entity_class>

    my $entity_class = $factory->entity_class;

Get namespace as a construct entity class.

=head1 METHODS

=head2 C<cook>

    # Markets::Domain::Factory::Entity::YourEntity;
    sub cook {
        # Overdide this method.
        # your factory codes here!
    }

=head2 C<create>

Alias for L</create_entity>.

=head2 C<create_entity>

    my $entity = $factory->create_entity;
    my $entity = $factory->create_entity( foo => 'bar' );
    my $entity = $factory->create_entity( { foo => 'bar' } );

=head2 C<factory>

    my $new_factory = $factory->factory('Entity::Hoge', %data );
    my $new_factory = $factory->factory('Entity::Hoge', \%data );
    my $new_factory = $factory->factory('entity-hoge', %data );
    my $new_factory = $factory->factory('entity-hoge', \%data );

Return factory object.

=heas2 C<params>

    # Getter
    my $params = $factory->params;
    my %params = $factory->params;

    # Setter
    $factory->params( %param );
    $factory->params( \%param );

Get/Set parameter.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Mojo::Base>
