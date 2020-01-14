package Yetie::Factory;
use Mojo::Base -base;
use Carp 'croak';
use Mojo::Util   ();
use Mojo::Loader ();
use Scalar::Util ();
use Yetie::Util  ();
use Yetie::Domain::Collection qw/collection/;
use Yetie::Domain::IxHash qw/ixhash/;

has 'app';
has domain_class => sub {
    my $class = ref shift;
    $class =~ s/Factory/Domain/;
    $class;
};

sub aggregate {
    my ( $self, $accessor, $domain, $data ) = @_;

    if ( !$data ) { $data = $self->param($accessor) }
    return $self->param( $accessor => $data ) if Scalar::Util::blessed($data);

    my $converted_data = $self->_convert_data( $domain, $data );
    return $self->param( $accessor => $self->factory($domain)->construct($converted_data) );
}

sub aggregate_domain_list {
    my ( $self, $domain ) = @_;

    my $list = $self->param('list') || [];
    return $self->aggregate_collection( list => $domain, $list );
}

sub aggregate_domain_set {
    my ( $self, $domain ) = @_;

    my $hash = $self->param('hash_set') || [];
    return $self->aggregate_ixhash( hash_set => $domain, $hash );
}

sub aggregate_collection {
    my ( $self, $accessor, $domain, $data ) = @_;

    # croak 'Data type is not Array refference' if ref $data ne 'ARRAY';
    # NOTE: $data is Array reference or Yetie::Domain::Collection object

    my @array;
    push @array, $self->factory($domain)->construct($_) for @{$data};
    $self->param( $accessor => collection(@array) );
    return $self;
}

sub aggregate_ixhash {
    my ( $self, $accessor, $domain, $data ) = @_;

    # croak 'Data type is not Array refference' if ref $data ne 'ARRAY';
    # NOTE: $data is Array reference or Yetie::Domain::Ixhash object

    my @kvlist;
    if ( ref $data eq 'ARRAY' ) {
        foreach my $kv ( @{$data} ) {
            my ( $key, $value ) = %{$kv};
            push @kvlist, ( $key => $self->factory($domain)->construct($value) );
        }
    }
    elsif ( $data->isa('Yetie::Domain::IxHash') ) {
        $data->each(
            sub {
                my ( $key, $value ) = @_;
                push @kvlist, ( $key => $self->factory($domain)->construct($value) );
            }
        );
    }
    else { croak 'Bad data type' }

    $self->param( $accessor => ixhash(@kvlist) );
    return $self;
}

sub cook { }

sub construct {
    my $self = shift;

    # my $args = @_ ? @_ > 1 ? {@_} : { %{ $_[0] } } : {};
    # NOTE: For now to debuggable code...
    my $args = {};
    if (@_) {
        $args = @_ > 1 ? {@_} : ref $_[0] eq 'HASH' ? { %{ $_[0] } } : Carp::croak 'Not a HASH reference';
    }
    $self->params($args);

    # Cooking parameter
    $self->cook();

    # Convert parameter for Yetie::Domain::List and Yetie::Domain::Set
    # in the case of first domain
    $self->_convert_param_to_list if $self->domain_class =~ /::List/;
    $self->_convert_param_to_set  if $self->domain_class =~ /::Set/;

    # no need parameter
    my $params = $self->params;
    delete $params->{$_} for qw(app domain_class resultset);

    # Construct domain object
    Yetie::Util::load_class( $self->domain_class );
    return $self->domain_class->new( %{$params} );
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

    my $domain        = Mojo::Util::camelize($arg);
    my $factory_class = 'Yetie::Factory::' . $domain;
    my $domain_class  = 'Yetie::Domain::' . $domain;

    my $e = Mojo::Loader::load_class($factory_class);
    die "Exception: $e" if ref $e;

    my $factory = $e ? __PACKAGE__->SUPER::new(@_) : $factory_class->SUPER::new(@_);
    $factory->domain_class($domain_class);
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

sub _convert_data {
    my ( $self, $domain, $data ) = @_;
    return $data if ref $data eq 'HASH';

    return { value => $data } if $domain =~ /^value/;
    return { list => collection( @{ $data || [] } ) } if $domain =~ /^list/;

    # Not convert
    return $data || {};
}

sub _convert_param_to_list {
    my $self  = shift;
    my $param = $self->param('list');
    return if ref $param ne 'ARRAY';

    $self->param( list => collection( @{$param} ) );
}

sub _convert_param_to_set {
    my $self  = shift;
    my $param = $self->param('hash_set');
    return if ref $param ne 'ARRAY';

    my @kvlist;
    foreach my $kv ( @{$param} ) {
        my ( $key, $value ) = %{$kv};
        push @kvlist, ( $key => $value );
    }
    return $self->param( hash_set => ixhash(@kvlist) );
}

1;
__END__

=head1 NAME

Yetie::Factory

=head1 SYNOPSIS

    my $factory = Yetie::Factory->new( 'entity-hoge', %data1 || \%data1 );
    my $domain = $factory->construct( %data2 || \%data2 );

=head1 DESCRIPTION

=head1 FUNCTIONS

L<Yetie::Factory> inherits all functions from L<Mojo::Base> and implements
the following new ones.

=head2 C<new>

    my $factory = Yetie::Factory->new( 'entity-hoge', %data || \%data );

=head1 ATTRIBUTES

L<Yetie::Factory> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head2 C<app>

L<Yetie> application instance.

=head2 C<domain_class>

    my $domain_class = $factory->domain_class;

Get namespace as a construct domain class.

=head1 METHODS

L<Yetie::Factory> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<aggregate>

    sub cook {
        my $self = shift;

        my %data = ( foo => 'bar' );
        $self->aggregate( $attribure_name => $domain_class, \%data );

        # Entity Object
        $self->aggregate( user => 'entity-user', { id => 1, name => 'foo', age => 22, ... } );

        # Value Object
        $self->aggregate( email => 'value-email', { value => 'a@example.org', ... } );
        $self->aggregate( email => 'value-email', 'a@example.org' );

        # Object as arguments
        $self->aggregate( user => 'entitiy-user',  Yetie::Domain::Entity::User->new );
        $self->aggregate( email => 'value-email',  Yetie::Domain::Value::Email->new );
    }

Create L<Yetie::Domain::Entity>, or L<Yetie::Domain::Value> type aggregate.

    sub cook {
        my $self = shift;

        $self->aggregate( user => 'entity-user' );
        $self->aggregate( email => 'value-email' );

        # Longer version
        $self->aggregate( user => 'entity-user', $self->param('user') );
        $self->aggregate( email => 'value-email', $self->param('email') );
    }

If third argument is omited, the value of C<param($attribure_name)> will be used.

=head2 C<aggregate_domain_list>

    sub cook {
        my $self = shift;

        $self->aggregate_domain_list($target_domain_class);

        # Longer version
        $self->aggregate_collection( 'list' => $target_domain_class, $self->param('list') || [] );
    }

Create L<Yetie::Domain::List> type aggregate.
See L</aggregate_collection>.

=head2 C<aggregate_domain_set>

    sub cook {
        my $self = shift;

        $self->aggregate_domain_set($target_domain_class);

        # Longer version
        $self->aggregate_ixhash( 'hash_set' => $target_domain_class, $self->param('hash_set') || {} );
    }

Create L<Yetie::Domain::Set> type aggregate.
See L</aggregate_ixhash>.

=head2 C<aggregate_collection>

    sub cook {
        my $self = shift;

        my @data = (qw/a b c d e f/);
        $self->aggregate_collection( $accessor_name, $target_domain_class, \@data );
        $self->aggregate_collection( 'items', 'entity-xxx-item', \@data );
    }

Create L<Yetie::Domain::Collection> type aggregate.

=head2 C<aggregate_ixhash>

    sub cook {
        my $self = shift;

        my @data = ( { label => { key => 'value' } }, { label2 => { key2 => 'value2' } }, ... );
        $self->aggregate_ixhash( $accessor_name, $target_domain_class, \@data );
        $self->aggregate_ixhash( 'items', 'entity-xxx-item', \@data );
    }

Create L<Yetie::Domain::IxHash> type aggregate.

=head2 C<cook>

    # Yetie::Factory::YourDomainClass;
    sub cook {
        # Overdide this method.
        # your factory codes here!
    }

=head2 C<construct>

    my $domain = $factory->construct;
    my $domain = $factory->construct( foo => 'bar' );
    my $domain = $factory->construct( { foo => 'bar' } );

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

L<Mojo::Base>, L<Yetie::Domain::Entity>, L<Yetie::Domain::Value>,
L<Yetie::Domain::Collection>, L<Yetie::Domain::IxHash>
