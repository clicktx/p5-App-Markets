package Yetie::Schema::Result::DefaultTaxRule;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column tax_rule_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column start_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => Yetie::Schema->TZ,
};

# Relation
belongs_to
  tax_rule => 'Yetie::Schema::Result::TaxRule',
  { 'foreign.id' => 'self.tax_rule_id' };

# Methods
sub to_data {
    my $self = shift;

    my $rule = $self->tax_rule;
    my $data = {
        start_at => $self->start_at,

        # tax rule
        title    => $rule->title,
        tax_rate => $rule->tax_rate,
    };

    return $data;
}

1;
