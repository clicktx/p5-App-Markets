package Yetie::Schema::ResultSet::Staff;
use Mojo::Base 'Yetie::Schema::Base::ResultSet';

my $prefetch = { account => 'password' };

sub find_by_login_id {
    my ( $self, $login_id ) = @_;

    return $self->find(
        {
            'me.login_id' => $login_id
        },
        {
            prefetch => $prefetch
        },
    );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Staff

=head1 SYNOPSIS

    my $data = $schema->resultset('Staff')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Staff> inherits all attributes from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Staff> inherits all methods from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<find_by_login_id>

    my $result = $rs->find_by_login_id($login_id);

Return L<$result|DBIx::Class::Manual::ResultClass> | undef.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Base::ResultSet>, L<Yetie::Schema>
