package Markets::Domain::Entity;
use Markets::Domain::Base;

use Carp qw/croak/;
use Mojo::Util qw/sha1_sum/;
use Scalar::Util qw/blessed/;

has id => sub { Carp::croak 'Attribute "id" not implemented by subclass' };

my @needless_attrs = (qw/id/);

sub clone {
    my $self  = shift;
    my $clone = $self->new( +{ %{$self} } );
    $clone->_is_modified(0);
    return $clone;
}

sub hash_code { @_ > 1 ? sha1_sum( $_[1] ) : sha1_sum( $_[0]->id ) }

sub is_equal { shift->id eq shift->id ? 1 : 0 }

sub is_modified { @_ > 1 ? $_[0]->_is_modified( $_[1] ? 1 : 0 ) : $_[0]->_is_modified }

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

1;
__END__

=head1 NAME

Markets::Domain::Entity - Entity Object Base Class

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head2 C<entity_id>

    has entity_id => 'identity';
    has entity_id => sub { shift->more_id };

=head1 METHODS

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

    my $bool = $entity->is_modified;
    $entity->is_modified($bool);

Return boolean value.

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

 L<Mojo::Base>
