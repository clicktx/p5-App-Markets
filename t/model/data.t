use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('Markets::Web');
my $app = $t->app;

subtest 'Model Data Base' => sub {
    my $result = $app->model('Data::Base')->new;
    ok( ref $result, 'construct.' );
};

subtest 'preferences' => sub {
    my $result = $app->model('Data::Preference')->load;
    isa_ok( $result, 'HASH' );
};

done_testing();
