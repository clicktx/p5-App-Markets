use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::App::Core::Parameters';
use_ok $pkg;

my $p = $pkg->new('foo=1&bar[]=1&baz=1&baz=2');

is_deeply $p->to_hash,
  {
    foo     => 1,
    'bar[]' => [1],
    baz     => [ 1, 2 ]
  },
  'right to_hash';

done_testing();
