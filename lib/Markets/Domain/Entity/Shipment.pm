package Markets::Domain::Entity::Shipment;
use Mojo::Base 'Markets::Domain::Entity';

has [qw/items/];

has id => sub { shift->hash_code };
has shipping_address => '';

sub clone {
    my $self  = shift;
    my $clone = $self->SUPER::clone;
    $clone->items( $self->items->map( sub { $_->clone } ) ) if $self->items->can('map');
    return $clone;
}

# NOTE: [WIP] 特定する条件を決める
sub hash_code {
    my $self  = shift;
    my $bytes = $self->shipping_address;
    $self->SUPER::hash_code($bytes);
}

sub item_count {
    my $cnt = 0;
    shift->items->each( sub { $cnt += $_->quantity } );
    return $cnt;
}

sub to_hash {
    my $self = shift;
    my $hash = $self->SUPER::to_hash;

    my @items;
    $hash->{items}->each( sub { push @items, $_->to_hash } );
    $hash->{items} = \@items;
    return $hash;
}

1;
__END__

=head1 NAME

Markets::Domain::Entity::Shipment

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Shipment> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Entity>
