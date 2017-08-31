package Markets::Domain::Entity::Content;
use Markets::Domain::Entity;

has title       => '';
has description => '';
has keywords    => '';
has robots      => '';

has breadcrumb => sub { Markets::Domain::Collection->new };


1;
__END__

=head1 NAME

Markets::Domain::Entity::Content

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Content> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Entity::Content> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
