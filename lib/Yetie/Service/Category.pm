package Yetie::Service::Category;
use Mojo::Base 'Yetie::Service';

has resultset => sub { shift->schema->resultset('Category') };

sub update {
    my ( $self, $entity, $option ) = @_;
    my $cols = [ qw(title), @{$option} ];

    my $data = {};
    $data->{$_} = $entity->$_ for @{$cols};

    # NOTE: findにするとSQLの実行が1回増える。
    # $self->resultset->find( $entity->id )->update($data);
    $self->resultset->search( { id => $entity->id } )->update($data);
}

1;
__END__

=head1 NAME

Yetie::Service::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Category> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Category> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<update>

    $service->update( $entity, \@option );

    $service->update( $entity, [ 'column_foo', 'colmun_bar' ] );

Update database.
Add a column to be updated with the second argument.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
