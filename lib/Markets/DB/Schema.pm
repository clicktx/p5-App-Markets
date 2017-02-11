package Markets::DB::Schema;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name    'preferences';
    pk      'key_name';
    columns qw( key_name value default_value summary label position );
};

1;
