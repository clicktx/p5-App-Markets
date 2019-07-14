package Yetie::Domain::Role::CategoryTaxRule;
use Moose::Role;

has tax_rules => (
    is      => 'ro',
    isa     => 'Yetie::Domain::List::TaxRules',
    default => sub { shift->factory('list-tax_rules')->construct() },
    writer  => 'set_tax_rules',
);

1;
__END__

=head1 NAME

Yetie::Domain::Role::CategoryTaxRule

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Role::CategoryTaxRule> inherits all attributes from L<Moose::Role> and implements
the following new ones.

=head2 C<tax_rules>

Return L<Yetie::Domain::List::TaxRules> object.

=head1 METHODS

L<Yetie::Domain::Role::CategoryTaxRule> inherits all methods from L<Moose::Role> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose::Role>
