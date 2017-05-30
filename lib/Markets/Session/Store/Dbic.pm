package Markets::Session::Store::Dbic;
use Mojo::Base 'MojoX::Session::Store';

use Try::Tiny;
use Mojo::Util;
use MIME::Base64;
use Storable qw/nfreeze thaw/;

has 'schema';
has resultset_session  => 'Session';
has resultset_cart     => 'Cart';
has sid_column         => 'sid';
has expires_column     => 'expires';
has data_column        => 'data';
has cart_id_column     => 'cart_id';
has customer_id_column => 'customer_id';

sub create {
    my ( $self, $sid, $expires, $data ) = @_;

    my $schema         = $self->schema;
    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $cart_id_column = $self->cart_id_column;
    my $data_column    = $self->data_column;

    my ( $session_data, $cart_id, $cart_data ) = _separate_session_data($data);
    $session_data = $session_data ? encode_base64( nfreeze($session_data) ) : '';
    $cart_data    = $cart_data    ? encode_base64( nfreeze($cart_data) )    : '';

    my $cb = sub {

        # Cart
        $schema->resultset( $self->resultset_cart )->create(
            {
                $cart_id_column => $cart_id,
                $data_column    => $cart_data,
            }
        );

        # Session
        $schema->resultset( $self->resultset_session )->create(
            {
                $sid_column     => $sid,
                $expires_column => $expires,
                $data_column    => $session_data,
                $cart_id_column => $cart_id,
            }
        );
    };

    try {
        $schema->txn_do($cb);
        return 1;
    }
    catch {
        $self->error($_);
        return;
    };
}

sub update {
    my ( $self, $sid, $expires, $data ) = @_;

    my $schema         = $self->schema;
    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $cart_id_column = $self->cart_id_column;
    my $data_column    = $self->data_column;

    my ( $session_data, $cart_id, $cart_data ) = _separate_session_data($data);
    my $customer_id = $session_data->{customer_id} || undef;

    # カートの変更をチェック
    my $is_modified = $cart_data->{_is_modified};
    $cart_data->{_is_modified} = 0;

    $session_data = $session_data ? encode_base64( nfreeze($session_data) ) : '';
    $cart_data    = $cart_data    ? encode_base64( nfreeze($cart_data) )    : '';

    my $cb = sub {

        # Update Cart
        $schema->resultset( $self->resultset_cart )->search( { $cart_id_column => $cart_id } )->update(
            {
                $data_column => $cart_data,
            }
        ) if $is_modified;

        # Update Session
        $schema->resultset( $self->resultset_session )->search( { $sid_column => $sid } )->update(
            {
                $expires_column => $expires,
                $data_column    => $session_data,
                $cart_id_column => $cart_id,
            }
        );
    };

    try {
        $schema->txn_do($cb);
        return 1;
    }
    catch {
        $self->error($_);
        return;
    };
}

sub update_cart_id {
    my ( $self, $cart_id, $new_cart_id ) = @_;

    my $schema         = $self->schema;
    my $cart_id_column = $self->cart_id_column;

    return $schema->resultset( $self->resultset_cart )->search( { $cart_id_column => $cart_id } )
      ->update( { $cart_id_column => $new_cart_id } ) ? 1 : 0;
}

sub update_sid {
    my ( $self, $sid, $new_sid ) = @_;

    my $schema     = $self->schema;
    my $sid_column = $self->sid_column;

    return $schema->resultset( $self->resultset_session )->search( { $sid_column => $sid } )
      ->update( { $sid_column => $new_sid } ) ? 1 : 0;
}

sub load_cart_data {
    my ( $self, $cart_id ) = @_;
    my $schema      = $self->schema;
    my $data_column = $self->data_column;

    my $rs = $schema->resultset( $self->resultset_cart )->find($cart_id);
    my $data = $rs ? thaw( decode_base64( $rs->data ) ) : undef;
    return $data ? $data->{data} : undef;
}

sub load {
    my ( $self, $sid ) = @_;

    my $schema         = $self->schema;
    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $cart_id_column = $self->cart_id_column;
    my $data_column    = $self->data_column;

    my $rs = $schema->resultset( $self->resultset_session )->find( $sid, { prefetch => ['cart'], }, );
    return unless $rs;

    my $expires      = $rs->$expires_column;
    my $session_data = $rs->$data_column;
    my $cart_data    = $rs->cart->$data_column;
    my $cart_id      = $rs->$cart_id_column;

    $session_data            = $session_data ? thaw( decode_base64($session_data) ) : {};
    $session_data->{cart_id} = $cart_id      ? $cart_id                             : '';
    $session_data->{cart}    = $cart_data    ? thaw( decode_base64($cart_data) )    : '';

    return ( $expires, $session_data );
}

sub delete_cart {
    my ( $self, $cart_id ) = @_;
    my $schema         = $self->schema;
    my $cart_id_column = $self->cart_id_column;

    $schema->resultset( $self->resultset_cart )->search( { $cart_id_column => $cart_id } )->delete;
}

sub delete {
    my ( $self, $sid ) = @_;

    my $schema     = $self->schema;
    my $sid_column = $self->sid_column;

    # my $cart_id_column = $self->cart_id_column;

    # TODO: customer cart以外の場合はcartも削除するように
    # session deleteで関係するcartもdeleteされる
    my $cb = sub {
        my $session =
          $schema->resultset( $self->resultset_session )->search( { $sid_column => $sid } )->delete;

        # $session->delete_related('cart');#リレーション設定により不要
    };

    try {
        $schema->txn_do($cb);
        return 1;
    }
    catch {
        $self->error($_);
        return;
    };
}

sub _separate_session_data {
    my $data = shift;

    my %clone     = %$data;
    my $cart_data = delete $clone{cart};
    my $cart_id   = delete $clone{cart_id};

    return ( \%clone, $cart_id, $cart_data );
}

1;
__END__

=head1 NAME

Markets::Session::Store::Dbic - Dbic Store for MojoX::Session

=head1 SYNOPSIS

    CREATE TABLE sessions (
        sid          VARCHAR(50) PRIMARY KEY,
        data         MEDIUMTEXT,
        cart_id      VARCHAR(50) NOT NULL,
        expires      BIGINT NOT NULL,
    );
    CREATE TABLE carts (
        cart_id      VARCHAR(50) PRIMARY KEY,
        data         MEDIUMTEXT NOT NULL,
        created_at   DATETIME NOT NULL,
        updated_at   DATETIME NOT NULL,
    );

    # Your App
    my $schema = MyDbic::DB->new(...);
    my $session = MojoX::Session->new(
        store => Markets::Session::Store::Dbic->new( schema => $schema ),
        ...
    );

=head1 DESCRIPTION

L<Markets::Session::Store::Dbic> is a store for L<MojoX::Session> that stores a
session in a database using Dbic.

forked by L<MojoX::Session::Store::Dbic>

=head1 ATTRIBUTES

L<Markets::Session::Store::Dbic> implements the following attributes.

=head2 C<schema>

    my $schema = $store->schema;
    $store->schema($schema);

Get and set L<DBIx::Class::Schema> object.

=head2 C<sid_column>

Session id column name. Default is 'sid'.

=head2 C<expires_column>

Expires column name. Default is 'expires'.

=head2 C<data_column>

Data column name. Default is 'data'.

=head2 C<cart_id_column>

Cart column name. Default is 'cart_id'.

=head1 METHODS

L<Markets::Session::Store::Dbic> inherits all methods from
L<MojoX::Session::Store>.

=head2 C<create>

Insert session to database.

=head2 C<update>

Update session in database.

=head2 C<update_sid>

Update sid in database.

=head2 C<load_cart_data>

Load cart from database.

=head2 C<load>

Load session from database.

=head2 C<delete_cart>

Delete cart from database.

=head2 C<delete>

Delete session from database.

=head1 SEE ALSO

L<Markets::Session::CartSession>

L<DBIx::Class>

L<Mojolicious::Plugin::Session>

L<MojoX::Session::Store>

L<MojoX::Session::Store::Dbic>

L<MojoX::Session>

=head1 AUTHOR

clicktx

=head1 COPYRIGHT

Copyright (C) 2016, clicktx.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
