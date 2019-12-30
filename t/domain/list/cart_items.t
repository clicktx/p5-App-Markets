use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Exception;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::List::CartItems';
use_ok $pkg;

sub factory {
    return Yetie::Factory->new('list-cart_items')->construct(@_);
}

subtest 'append' => sub {
    my $list = factory();
    my $item = Yetie::Factory->new('entity-line_item')->construct( id => 1 );
    dies_ok { $list->append($item) } 'right fail';
};

done_testing();
