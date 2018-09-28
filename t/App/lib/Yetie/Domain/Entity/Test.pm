package Yetie::Domain::Entity::Test;
use Yetie::Domain::Base 'Yetie::Domain::Entity';

has [qw(email name address favorite_color luky_number)];
has billing => sub { __PACKAGE__->factory('billing')->construct() };
has burgers => sub { Yetie::Domain::Collection->new };

1;
