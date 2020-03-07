package Yetie::Schema::ResultSet::Staff;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub find_by_login_id {
    my ( $self, $login_id ) = @_;

    return $self->search(
        {
            'me.login_id' => $login_id
        },
        {
            prefetch => { staff_password => 'password' },
            order_by => [ { '-desc' => 'password.created_at' } ],
        },
    )->limit(1)->first;
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Staff

=head1 SYNOPSIS

    my $result = $schema->resultset('Staff')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Staff> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Staff> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<find_by_login_id>

    my $result = $rs->find_by_login_id($login_id);

Return L<$result|DBIx::Class::Manual::ResultClass> | undef.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
