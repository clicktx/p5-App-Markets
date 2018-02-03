package Yetie::Domain::Entity;
use Yetie::Domain::Base;
use Yetie::Domain::Factory;
use Yetie::Domain::Collection qw(collection);
use Yetie::Domain::IxHash qw(ix_hash);
use Mojo::Util qw();
use Scalar::Util qw();
use Data::Clone qw();

has 'id';

my @needless_attrs = (qw/id created_at updated_at/);

sub clone {
    my $self  = shift;
    my $clone = Data::Clone::data_clone($self);

    my @attributes = keys %{$self};
    foreach my $attr (@attributes) {
        next unless $self->can($attr);
        next unless Scalar::Util::blessed( $self->$attr );
        $clone->$attr( $self->$attr->map( sub { $_->clone } ) ) if $self->$attr->can('map');
    }
    $clone->_is_modified(0);
    return $clone;
}

sub equal { shift->id eq shift->id ? 1 : 0 }

sub factory {
    my ( $class, $entity_name ) = @_;
    Yetie::Domain::Factory->new($entity_name)->create();
}

sub has_data { return shift->id ? 1 : 0 }

sub hash_code {
    my ( $self, $arg ) = @_;
    if   ( @_ > 1 ) { return defined $arg      ? Mojo::Util::sha1_sum($arg)        : undef }
    else            { return defined $self->id ? Mojo::Util::sha1_sum( $self->id ) : undef }
}

sub is_empty { shift->id ? 0 : 1 }

sub is_modified {
    my $self = shift;

    # Setter
    if (@_) {
        return $_[0] ? $self->_is_modified(1) : $self->reset_modified;
    }

    # Getter
    return 1 if $self->_is_modified;

    # Recursive call for attributes
    my $is_modified = 0;
    $self->_recursive_call( sub { $is_modified = 1 if shift->is_modified } );
    return $is_modified;
}

sub reset_modified {
    my $self = shift;
    $self->_is_modified(0);

    # Recursive call for attributes
    $self->_recursive_call( sub { shift->reset_modified } );
    return 0;
}

sub to_array {
    my $self = shift;
    my $hash = $self->to_hash;

    my @keys = sort keys %{$hash};
    my @values = map { $hash->{$_} } @keys;
    return [ \@keys, \@values ];
}

sub to_data {
    my $self = shift;
    my $h    = $self->to_hash;
    my %hash;
    $hash{$_} = Scalar::Util::blessed $h->{$_} ? $h->{$_}->to_data : $h->{$_} for keys %{$h};
    return \%hash;
}

sub to_hash {
    my %hash = %{ +shift };

    # Remove needless data
    my @private = grep { $_ =~ /^_.*/ } keys %hash;
    push @needless_attrs, @private;

    delete $hash{$_} for @needless_attrs;
    return \%hash;
}

sub _recursive_call {
    my ( $self, $cb ) = @_;
    foreach my $attr ( keys %{$self} ) {
        next if !$self->can($attr);
        next if !Scalar::Util::blessed( $self->$attr );

        if ( $self->$attr->isa('Yetie::Domain::Entity') ) {
            $cb->( $self->$attr );
        }
        elsif ( $self->$attr->isa('Yetie::Domain::Collection') ) {
            $self->$attr->each( sub { $cb->($_) } );
        }
        elsif ( $self->$attr->isa('Yetie::Domain::IxHash') ) {
            $self->$attr->each( sub { $cb->($b) } );
        }
    }
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity - Entity Object Base Class

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 FUNCTIONS

=head2 C<collection>

    my $collection = collection( 'foo', 'bar', 'baz' );

Construct a new index-hash-based L<Yetie::Domain::Collection> object.

=head2 C<ix_hash>

    my $ix_hash = ix_hash( foo => 1, bar => 2, baz => 3 );

Construct a new index-hash-based L<Yetie::Domain::IxHash> object.

=head1 ATTRIBUTES

L<Yetie::Domain::Entity> inherits all attributes from L<Yetie::Domain::Base> and implements
the following new ones.

=head2 C<entity_id>

    has entity_id => 'identity';
    has entity_id => sub { shift->more_id };

=head1 METHODS

L<Yetie::Domain::Entity> inherits all methods from L<Yetie::Domain::Base> and implements
the following new ones.

=head2 C<clone>

    my $clone = $self->clone;

Return object.

=head2 C<equal>

    my $bool = $entity->equal($other_entity);

Return boolean value.

=head2 C<factory>

    __PACKAGE__->factory('entity-foo');

Return Yetie::Domain::Entity object.

=head2 C<has_data>

    my $bool = $entity->has_data;

Return boolean value.

=head2 C<hash_code>

    my $sha1_sum = $entity->hash_code;
    my $sha1_sum = $entity->hash_code($bytes);

Return SHA1 checksum. Default bytes is L<Yetie::Domain::Entity/id>.

=head2 C<id>

    my $entity_id = $entity->id;

=head2 C<is_empty>

    my $bool = $entity->is_empty;

Return boolean value.

=head2 C<is_modified>

    # Getter
    my $bool = $entity->is_modified;
    say 'Entity is modified!' if $bool;

    # Setter
    $entity->is_modified($bool);

Return boolean value.

=head2 C<reset_modified>

    $entity->reset_modified;

Reset modified flag.
Recursively reset all entities to keep.

=head2 C<to_array>

    my $array = $entity->to_array;

    # eg.
    my $e = Yetie::Domain::Entity->new({ id => 11, b => 5, a => 3, z => 15 });
    my $array = $e->to_array;

    # Return value
    print Dumper $array;
    $VAR1 = [
        [ 'a', 'b', 'z' ],
        [ 3, 5, 15 ]
    ];

Return Array reference.

Note: All private attributes (e.g. "_xxx") and "id", "created_at", "updated_at" are removed.

=head2 C<to_data>

    my $data = $e->to_data;

Return hash reference. This method recursive call L</to_hash>.

Note: All private attributes (e.g. "_xxx") and "id", "created_at", "updated_at" are removed.

=head2 C<to_hash>

    my $data = $entity->to_hash;

Return Hash reference.

Note: All private attributes (e.g. "_xxx") and "id", "created_at", "updated_at" are removed.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Base>, L<Mojo::Base>, L<Yetie::Domain::Collection>, L<Yetie::Domain::IxHash>
