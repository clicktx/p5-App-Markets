package Markets::Domain::Entity;
use Markets::Domain::Base;

use Carp qw/croak/;
use Mojo::Util qw/sha1_sum/;
use Scalar::Util qw/blessed/;
use Data::Clone qw/data_clone/;

has id => sub { Carp::croak 'Attribute "id" not implemented by subclass' };

my @needless_attrs = (qw/id/);

sub clone {
    my $self  = shift;
    my $clone = data_clone($self);

    my @attributes = keys %{$self};
    foreach my $attr (@attributes) {
        next unless blessed( $self->$attr );
        $clone->$attr( $self->$attr->map( sub { $_->clone } ) ) if $self->$attr->can('map');
    }
    $clone->_is_modified(0);
    return $clone;
}

sub hash_code { @_ > 1 ? sha1_sum( $_[1] ) : sha1_sum( $_[0]->id ) }

sub is_equal { shift->id eq shift->id ? 1 : 0 }

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
    $hash{$_} = blessed $h->{$_} ? $h->{$_}->to_data : $h->{$_} for keys %{$h};
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

        if ( $self->$attr->isa('Markets::Domain::Entity') ) {
            $cb->( $self->$attr );
        }
        elsif ( $self->$attr->isa('Markets::Domain::Collection') ) {
            $self->$attr->each( sub { $cb->($_) } );
        }
        elsif ( $self->$attr->isa('Markets::Domain::IxHash') ) {
            $self->$attr->each( sub { $cb->($b) } );
        }
    }
}

1;
__END__

=head1 NAME

Markets::Domain::Entity - Entity Object Base Class

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity> inherits all attributes from L<Markets::Domain::Base> and implements
the following new ones.

=head2 C<entity_id>

    has entity_id => 'identity';
    has entity_id => sub { shift->more_id };

=head1 METHODS

L<Markets::Domain::Entity> inherits all methods from L<Markets::Domain::Base> and implements
the following new ones.

=head2 C<clone>

    my $clone = $self->clone;

Return object.

=head2 C<hash_code>

    my $sha1_sum = $entity->hash_code;
    my $sha1_sum = $entity->hash_code($bytes);

Return SHA1 checksum. Default bytes is L<Markets::Domain::Entity/id>.

=head2 C<id>

    my $entity_id = $entity->id;

=head2 C<is_equal>

    my $bool = $entity->is_equal($other_entity);

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
    my $e = Markets::Domain::Entity->new({ id => 11, b => 5, a => 3, z => 15 });
    my $array = $e->to_array;

    # Return value
    print Dumper $array;
    $VAR1 = [
        [ 'a', 'b', 'z' ],
        [ 3, 5, 15 ]
    ];

Return Array reference.
Note: Key 'id' and '_xxxx' is remove.

=head2 C<to_data>

    my $data = $e->to_data;

Return hash reference. This method recursive call L</to_hash>.

=head2 C<to_hash>

    my $data = $entity->to_hash;

Return Hash reference.
Note: Key 'id' and '_xxxx' is remove.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Base>, L<Mojo::Base>
