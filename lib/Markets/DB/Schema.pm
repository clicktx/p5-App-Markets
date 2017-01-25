package Markets::DB::Schema;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name    'constants';
    pk      'name';
    columns qw( name default_value value summary label position );
};

table {
    name    'preferences';
    pk      'key';
    columns qw( key value default_value summary label position );
};

1;
