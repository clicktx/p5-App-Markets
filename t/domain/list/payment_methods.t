use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::List::PaymentMethods';

sub construct { return Yetie::Factory->new('list-payment_methods')->construct( list => @_ ) }

use_ok $pkg;

subtest 'to_form_choices' => sub {
    my $l = construct( [] );
    is_deeply $l->to_form_choices, [], 'right empty list';

    $l = construct( [ { id => 1, name => 'foo' }, { id => 2, name => 'bar' }, { id => 3, name => 'baz' } ] );
    is_deeply $l->to_form_choices, [ [ foo => 1 ], [ bar => 2 ], [ baz => 3 ] ], 'right list';
};

done_testing();
