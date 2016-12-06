package Markets::DB::Schema::More;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name    'sessions';
    pk      'sid';
    columns qw( sid data cart_id expires );
};

1;
