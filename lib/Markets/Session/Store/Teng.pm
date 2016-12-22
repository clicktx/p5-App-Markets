package Markets::Session::Store::Teng;
use Mojo::Base 'MojoX::Session::Store';

# use MIME::Base64; シリアライズ時にbase64する必要があるか？MessagePackなら不要？
use Data::MessagePack;
use Mojo::Util;

has 'db';
has table_session  => 'sessions';
has table_cart     => 'carts';
has sid_column     => 'sid';
has expires_column => 'expires';
has data_column    => 'data';
has cart_id_column => 'cart_id';

sub create {
    my ( $self, $sid, $expires, $data ) = @_;

    my $db             = $self->db;
    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $data_column    = $self->data_column;
    my $cart_id_column = $self->cart_id_column;

    my ( $session_data, $cart_id, $cart_data ) = $self->_separate_session_data($data);
    my $session_data_mp = $session_data ? Data::MessagePack->pack($session_data) : '';
    my $cart_data_mp    = %$cart_data   ? Data::MessagePack->pack($cart_data)    : '';

    {
        my $txn = $db->txn_scope;

        # Cart
        $db->fast_insert(
            $self->table_cart,
            {
                $cart_id_column => $cart_id,
                $data_column    => $cart_data_mp,
            }
        );

        # Session
        $db->fast_insert(
            $self->table_session,
            {
                $sid_column     => $sid,
                $expires_column => $expires,
                $data_column    => $session_data_mp,
                $cart_id_column => $cart_id,
            }
        );

        my $error = $db->dbh->errstr || '';
        if ($error) {
            $self->error($error);
            return;
        }
        $txn->commit;
    }

    return 1;
}

sub update {
    my ( $self, $sid, $expires, $data ) = @_;

    my ( $session_data, $cart_id, $cart_data ) = $self->_separate_session_data($data);

    # カートの変更をチェック
    my $cart_data_mp = %$cart_data ? Data::MessagePack->pack($cart_data) : '';

    my ( $is_modified, $checksum ) = $self->_cart_checksum( $session_data, $cart_data_mp );
    $session_data->{cart_checksum} = $checksum;

    my $db              = $self->db;
    my $sid_column      = $self->sid_column;
    my $expires_column  = $self->expires_column;
    my $data_column     = $self->data_column;
    my $cart_id_column  = $self->cart_id_column;
    my $session_data_mp = $session_data ? Data::MessagePack->pack($session_data) : '';

    {
        my $txn = $db->txn_scope;

        # Update Cart
        $db->update(
            $self->table_cart,
            {
                $data_column => $cart_data_mp,
            },
            {
                $cart_id_column => $cart_id
            }
        ) if $is_modified;

        # Update Session
        $db->update(
            $self->table_session,
            {
                $expires_column => $expires,
                $data_column    => $session_data_mp,
                $cart_id_column => $cart_id,
            },
            {
                $sid_column => $sid
            }
        );

        $txn->commit;
    }

    my $error = $db->dbh->errstr || '';
    if ($error) {
        $self->error($error);
        return;
    }
    return 1;
}

sub update_sid {
    my ( $self, $original_sid, $new_sid ) = @_;

    my $db         = $self->db;
    my $sid_column = $self->sid_column;

    my $row_cnt = $db->update(
        $self->table_session,
        {
            $sid_column => $new_sid
        },
        {
            $sid_column => $original_sid
        }
    );

    my $error = $db->dbh->errstr || '';
    if ($error) {
        $self->error($error);
        return;
    }
    return $row_cnt ? 1 : 0;
}

sub load {
    my ( $self, $sid ) = @_;

    my $db             = $self->db;
    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $data_column    = $self->data_column;
    my $cart_id_column = $self->cart_id_column;

    my $row_session = $db->single( $self->table_session, { $sid_column => $sid } );
    my $error = $db->dbh->errstr || '';
    if ($error) {
        $self->error($error);
        return;
    }
    return unless $row_session;

    my $expires         = $row_session->get_column($expires_column);
    my $session_data_mp = $row_session->get_column($data_column);
    my $session_data    = $session_data_mp ? Data::MessagePack->unpack($session_data_mp) : {};
    my $cart_id         = $row_session->get_column($cart_id_column);
    $session_data->{cart_id} = $cart_id if $cart_id;

    my $cart_data_mp =
        $session_data->{cart_checksum}
      ? $db->single( $self->table_cart, { $cart_id_column => $cart_id } )->$data_column
      : '';
    $session_data->{cart} = $cart_data_mp ? Data::MessagePack->unpack($cart_data_mp) : '';

    return ( $expires, $session_data );
}

sub delete {
    my ( $self, $sid ) = @_;

    my $db             = $self->db;
    my $sid_column     = $self->sid_column;
    my $cart_id_column = $self->cart_id_column;

    {
        my $txn = $db->txn_scope;

        my $session_row = $db->single( $self->table_session, { $sid_column => $sid } );
        my $cart_id = $session_row->cart_id;
        $db->delete( $self->table_cart, { $cart_id_column => $cart_id } );
        $session_row->delete;

        $txn->commit;
    }

    my $error = $db->dbh->errstr || '';
    if ($error) {
        $self->error($error);
        return;
    }
    return 1;
}

sub _separate_session_data {
    my ( $self, $data ) = @_;

    my %clone     = %$data;
    my $cart_id   = delete $clone{cart_id};
    my $cart_data = delete $clone{cart};

    return ( \%clone, $cart_id, $cart_data );
}

# カートデータからchecksumを生成
# カートデータが空の場合のchecksumは空文字
sub _cart_checksum {
    my ( $self, $session_data, $cart_data_mp ) = @_;

    my $checksum     = $session_data->{cart_checksum};
    my $new_checksum = $cart_data_mp ? Mojo::Util::md5_sum($cart_data_mp) : '';
    my $is_modified  = $checksum ne $new_checksum ? 1 : 0;

    return $is_modified, $new_checksum;
}

1;
__END__

=head1 NAME

Markets::Session::Store::Teng - Teng Store for MojoX::Session

=head1 SYNOPSIS

    CREATE TABLE sessions (
        sid          VARCHAR(40) PRIMARY KEY,
        data         MEDIUMTEXT,
        cart_id      VARCHAR(40),
        expires      INTEGER UNSIGNED NOT NULL,
        UNIQUE(sid)
    );
    CREATE TABLE carts (
        cart_id      VARCHAR(40) PRIMARY KEY,
        data         MEDIUMTEXT,
        UNIQUE(cart_id)
    );

    # Your App
    my $teng = MyTeng::DB->new(...);
    my $session = MojoX::Session->new(
        store => Markets::Session::Store::Teng->new( db => $teng ),
        ...
    );

=head1 DESCRIPTION

L<Markets::Session::Store::Teng> is a store for L<MojoX::Session> that stores a
session in a database using Teng.

forked by L<MojoX::Session::Store::Dbic>

=head1 ATTRIBUTES

L<Markets::Session::Store::Teng> implements the following attributes.

=head2 C<db>

    my $db = $store->db;
    $db    = $store->db($teng);

Get and set Teng object.

=head2 C<sid_column>

Session id column name. Default is 'sid'.

=head2 C<expires_column>

Expires column name. Default is 'expires'.

=head2 C<data_column>

Data column name. Default is 'data'.

=head2 C<cart_id_column>

Cart column name. Default is 'cart_id'.

=head1 METHODS

L<Markets::Session::Store::Teng> inherits all methods from
L<MojoX::Session::Store>.

=head2 C<create>

Insert session to database.

=head2 C<update>

Update session in database.

=head2 C<update_sid>

Update sid in database.

=head2 C<load>

Load session from database.

=head2 C<delete>

Delete session from database.

=head1 SEE ALSO

L<Teng>

L<Mojolicious::Plugin::Session>

L<MojoX::Session::Store>

L<MojoX::Session>

=head1 AUTHOR

clicktx

=head1 COPYRIGHT

Copyright (C) 2016, clicktx.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
