package Yetie::Domain::Entity::Burger;
use Yetie::Domain::Base 'Yetie::Domain::Entity';

has [qw(name)];
has toppings => sub { Yetie::Domain::Collection->new };

1;
