package Yetie::Domain::Entity::Test;
use Yetie::Domain::Entity;
use Yetie::Domain::Entity::Billing;

has [qw(email name address favorite_color luky_number)];
has billing => sub { Yetie::Domain::Entity::Billing->new };

1;
