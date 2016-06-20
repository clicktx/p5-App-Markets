use Mojo::Base -strict;

use Test::More;

use_ok $_ for qw(
    Markets
    Markets::Web
    MojoX::Session
    Markets::Session::Store::Teng
);

done_testing();
