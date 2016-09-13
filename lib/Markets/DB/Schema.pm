package Markets::DB::Schema;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name    'constants';
    pk      'name';
    columns qw( name default_value value summary label position );
};

1;
