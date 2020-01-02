package Yetie::Factory::List::ProductCategories;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_domain_list('entity-product_category');
    return $self;
}

1;
__END__

=head1 NAME

Yetie::Factory::List::ProductCategories

=head1 SYNOPSIS

    my $list = Yetie::Factory::List::ProductCategories->new()->construct();

    # In controller
    my $list = $c->factory('list-product_categories')->construct();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::ProductCategories> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::ProductCategories> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
