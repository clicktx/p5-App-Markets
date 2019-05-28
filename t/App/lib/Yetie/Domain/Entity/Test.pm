package Yetie::Domain::Entity::Test;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::MooseEntity';

has [qw(email name address favorite_color luky_number)] => ( is => 'rw' );
has billing => ( is => 'rw', default => sub { __PACKAGE__->factory('entity-billing')->construct() } );
has burgers => ( is => 'rw', default => sub { Yetie::Domain::Collection->new } );

1;
