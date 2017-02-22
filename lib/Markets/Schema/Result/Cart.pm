package Markets::Schema::Result::Cart;

use strict;
use warnings;

use DBIx::Class::Candy -autotable => v1;

primary_column cart_id => {
    data_type => 'VARCHAR',
    size      => 50,
};

column data => { data_type => 'MEDIUMTEXT', };

column customer_id => { data_type => 'INT' };

has_many session => 'Markets::Schema::Result::Session', 'cart_id';

sub sqlt_deploy_hook {
    my ( $self, $table ) = @_;
    $table->add_index( name => 'idx_customer_id', fields => ['customer_id'] );
}

1;
