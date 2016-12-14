package Markets::DB::Schema::Session;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name 'sessions';
    pk 'sid';
    columns qw( sid data cart_id expires );
};

table {
    name 'carts';
    pk 'cart_id';
    columns qw( cart_id data );
};

1;
