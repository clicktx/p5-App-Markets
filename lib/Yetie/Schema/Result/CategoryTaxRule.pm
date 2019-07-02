package Yetie::Schema::Result::CategoryTaxRule;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column category_id => { data_type => 'INT' };
primary_column tax_rule_id => { data_type => 'INT' };

column start_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => __PACKAGE__->TZ,
};

column end_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => __PACKAGE__->TZ,
};

# Relation
belongs_to
  category => 'Yetie::Schema::Result::Category',
  { 'foreign.id' => 'self.category_id' };

belongs_to
  tax_rule => 'Yetie::Schema::Result::TaxRule',
  { 'foreign.id' => 'self.tax_rule_id' };

1;
