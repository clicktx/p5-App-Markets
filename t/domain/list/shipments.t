use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::List::Shipments';
use_ok $pkg;

sub construct {
    Yetie::Factory->new('list-shipments')->construct(@_);
}

subtest 'basic' => sub {
    my $l = construct();
    isa_ok $l, 'Yetie::Domain::List';
};

done_testing();
