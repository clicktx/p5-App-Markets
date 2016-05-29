use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::DB::Schema';
use_ok 'Markets::Model::Data::Base';

subtest 'Model Data' => sub {
    my $data = Markets::Model::Data::Base->new;
    ok (ref $data, 'construct.');
};

done_testing();
