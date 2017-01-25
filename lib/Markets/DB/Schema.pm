package Markets::DB::Schema;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name    'preferences';
    pk      'key';
    columns qw( key value default_value summary label position );
};

1;
