package Yetie::Domain::Entity::Burger;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::MooseEntity';

has [qw(name)] => ( is => 'rw' );
has toppings => ( is => 'rw', default => sub { Yetie::Domain::Collection->new } );

1;
