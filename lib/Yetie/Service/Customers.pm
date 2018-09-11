package Yetie::Service::Customers;
use Mojo::Base 'Yetie::Service';

sub search_customers {
    my ( $self, $form ) = @_;

    my $conditions = {
        where    => '',
        order_by => '',
        page_no  => $form->param('page') || 1,
        per_page => $form->param('per_page') || 5,
    };
    my $rs = $self->resultset('Customer')->search_customers($conditions);

    my $data = {
        meta_title    => 'Customers',
        form          => $form,
        breadcrumbs   => [],
        customer_list => $rs->to_data,
        pager         => $rs->pager,
    };
    return $self->factory('entity-page-customers')->construct($data);
}

1;
__END__

=head1 NAME

Yetie::Service::Customers

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Customers> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Customers> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<search_customers>

    my $customers = $service->search_customers($form_object);

Return L<Yetie::Domain::Entity::Page::Customers> Object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
