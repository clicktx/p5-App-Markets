use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection qw(c);

my $pkg = 'Yetie::Domain::Entity::Page::Orders';
use_ok $pkg;

subtest 'basic' => sub {
    my $e = $pkg->new();
    isa_ok $e, 'Yetie::Domain::Entity::Page';
    isa_ok $e->order_list, 'Yetie::Domain::Collection';
};

subtest 'each' => sub {
    my $e = $pkg->new( order_list => c( 1, 2, 3 ) );
    my @array;
    $e->each( sub { push @array, $_ } );
    is_deeply \@array, [ 1, 2, 3 ], 'right each method';
};

done_testing();
