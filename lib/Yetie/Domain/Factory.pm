package Yetie::Domain::Factory;
use Mojo::Base -base;
use Carp 'croak';
use DateTime::Format::Strptime;
use Mojo::Util   ();
use Mojo::Loader ();
use Yetie::Util  ();
use Yetie::Schema;
use Yetie::Domain::Collection qw/collection/;
use Yetie::Domain::IxHash qw/ix_hash/;

has 'app';
has entity_class => sub {
    my $class = ref shift;
    $class =~ s/::Factory//;
    $class;
};

sub aggregate {
    my ( $self, $accessor, $entity, $data ) = @_;
    croak 'Data type is not Array refference' if ref $data ne 'ARRAY';

    my @array;
    push @array, $self->factory($entity)->create($_) for @{$data};
    $self->param( $accessor => collection(@array) );
    return $self;
}

sub aggregate_kvlist {
    my ( $self, $accessor, $entity, $data ) = @_;
    croak 'Data type is not Array refference' if ref $data ne 'ARRAY';

    my @kvlist;
    while ( @{$data} ) {
        my ( $key, $value ) = ( shift @{$data}, shift @{$data} );
        push @kvlist, ( $key, $self->factory($entity)->create($value) );
    }
    $self->param( $accessor => ix_hash(@kvlist) );
    return $self;
}

sub cook { }

sub create { shift->create_entity(@_) }

sub create_entity {
    my $self = shift;

    my $args = @_ ? @_ > 1 ? {@_} : { %{ $_[0] } } : {};

    # inflate datetime
    my @keys = grep { $_ =~ qr/^.+_at$/ } keys %{$args};
    foreach my $key (@keys) {
        next if !$args->{$key} or ref $args->{$key} eq 'DateTime';

        my $strp = DateTime::Format::Strptime->new(
            pattern   => '%Y-%m-%d %H:%M:%S',
            time_zone => $Yetie::Schema::TIME_ZONE,
        );
        $args->{$key} = $strp->parse_datetime( $args->{$key} );
    }

    $self->params($args);

    # cooking entity
    $self->cook();

    my $params = $self->params;

    # no need parameter
    delete $params->{$_} for qw(app entity_class resultset);

    # Create entity
    Yetie::Util::load_class( $self->entity_class );
    my $entity = $self->entity_class->new( %{$params} );

    # NOTE: attributesは Yetie::Domain::Entity::XXX で明示する方が良い?
    # Add attributes
    # my @keys = keys %{$entity};
    # $entity->attr($_) for @keys;

    return $entity;
}

sub factory {
    my $self = shift;

    my $factory = $self->new(@_);
    $factory->app( $self->app );
    return $factory;
}

sub new {
    my ( $self, $arg ) = ( shift, shift );
    Carp::croak 'Argument empty' unless $arg;

    my $entity_name = Mojo::Util::camelize($arg);
    $entity_name =~ s/Entity:://;

    my $factory_base_class = 'Yetie::Domain::Factory';
    my $factory_class      = $factory_base_class . '::' . $entity_name;
    my $entity_class       = 'Yetie::Domain::Entity::' . $entity_name;

    my $e = Mojo::Loader::load_class($factory_class);
    die "Exception: $e" if ref $e;

    my $factory = $e ? $factory_base_class->SUPER::new(@_) : $factory_class->SUPER::new(@_);
    $factory->entity_class($entity_class);
    return $factory;
}

sub param {
    my $self = shift;
    @_ = ( %{ $_[0] } ) if ref $_[0];
    croak 'Arguments empty' unless @_;
    croak 'Arguments many, using the "params" method' if @_ > 2;

    return @_ > 1 ? $self->{ $_[0] } = $_[1] : $self->{ $_[0] };
}

sub params {
    my $self = shift;
    croak 'Only one argument, using the "param" method' if @_ == 1 and !ref $_[0];

    my %hash = %{$self};

    # Getter params()
    return wantarray ? (%hash) : {%hash} if !@_;

    # Setter
    my %args = @_ > 1 ? @_ : %{ $_[0] };
    $self->{$_} = $args{$_} for keys %args;
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory

=head1 SYNOPSIS

    my $factory = Yetie::Domain::Factory->new( 'entity-hoge', %data1 || \%data1 );
    my $entity = $factory->create( %data2 || \%data2 );

=head1 DESCRIPTION

=head1 FUNCTIONS

=head2 C<new>

    my $factory = Yetie::Domain::Factory->new( 'entity-hoge', %data || \%data );

=head1 ATTRIBUTES

=head2 C<app>

=head2 C<entity_class>

    my $entity_class = $factory->entity_class;

Get namespace as a construct entity class.

=head1 METHODS

L<Yetie::Domain::Factory> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<aggregate>

    my @data = (qw/a b c d e f/);
    my $entity = $factory->aggregate( $accessor_name, $target_entity, \@data );
    my $entity = $factory->aggregate( 'items', 'entity-xxx-item', \@data );

Create C<Yetie::Domain::Collection> type aggregate.

=head2 C<aggregate_kvlist>

    my @data = ( key => 'value', key2 => 'value2', ... );
    my $entity = $factory->aggregate_kv( $accessor_name, $target_entity, \@data );
    my $entity = $factory->aggregate_kv( 'items', 'entity-xxx-item', \@data );

Create C<Yetie::Domain::IxHash> type aggregate.

=head2 C<cook>

    # Yetie::Domain::Factory::YourEntity;
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

    my $other_factory = $factory->factory('entity-hoge');

Object constructor.close to L</new> function.
Inherit the value of attribute "app".

=head2 C<param>

    # Getter
    my $param = $factory->param('name');

    # Setter
    $factory->param( key => value );
    $factory->param( { key => value } );

Get/Set parameter.

=head2 C<params>

    # Getter
    my $params = $factory->params;
    my %params = $factory->params;

    # Setter
    $factory->params( %param );
    $factory->params( \%param );

Get/Set parameters.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Mojo::Base>, L<Yetie::Domain::Collection>, L<Yetie::Domain::IxHash>
