package t::DB::Schema;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name 'test';
    pk 'id';
    columns qw( id key_name value );
};

1;
