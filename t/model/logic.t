use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Model::Logic::Base';

subtest 'Model Logic' => sub {
    my $logic = Markets::Model::Logic::Base->new;
    ok (ref $logic, 'right');
};

done_testing();
