package Yetie::Domain::Entity::Billing;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::MooseEntity';

has [qw(line1 line2)] => ( is => 'rw' );

1;
