package Markets::DB::Schema::Addons;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name    'addons';
    pk      'id';
    columns qw( id name is_enabled );
};

table {
    name    'addons_hooks';
    pk      'id';
    columns qw( id addon_id hook_name priority );
};

1;
