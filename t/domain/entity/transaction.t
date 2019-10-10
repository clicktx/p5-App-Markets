use Mojo::Base -strict;
use Test::More;
use Test::Exception;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::Entity::Transaction';
use_ok $pkg;

done_testing();
