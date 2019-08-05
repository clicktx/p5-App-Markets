package Yetie::Domain::Entity::TaxRule;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has tax_rate => ( is => 'ro' );
has title    => ( is => 'ro' );
has start_at => ( is => 'ro' );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::TaxRule

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::TaxRule> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::TaxRule> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
