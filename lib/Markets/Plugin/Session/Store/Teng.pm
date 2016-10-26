package Markets::Plugin::Session::Store::Teng;
use strict;
use warnings;

use parent 'MojoX::Session::Store';

use MIME::Base64;
use Data::MessagePack;

__PACKAGE__->attr('resultset');
__PACKAGE__->attr( sid_column     => 'sid' );
__PACKAGE__->attr( expires_column => 'expires' );
__PACKAGE__->attr( data_column    => 'data' );
__PACKAGE__->attr( cart_column    => 'cart' );

sub _separate_session_data {
    my $data         = shift;
    my $cart_data    = $data->{cart} || '';
    my $session_data = $data;
    undef $session_data->{cart} if $session_data->{cart};
    return ( $cart_data, $session_data );
}

sub create {
    my ( $self, $sid, $expires, $data ) = @_;

    my ( $cart_data, $session_data ) = _separate_session_data($data);

    $cart_data    = Data::MessagePack->pack($cart_data)    if $cart_data;
    $session_data = Data::MessagePack->pack($session_data) if $session_data;

    my $resultset      = $self->resultset;
    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $data_column    = $self->data_column;
    my $cart_column    = $self->cart_column;

    return $resultset->insert(
        {
            $sid_column     => $sid,
            $expires_column => $expires,
            $data_column    => $session_data,
            $cart_column    => $cart_data,
        }
    ) ? 1 : 0;
}

sub update {
    my ( $self, $sid, $expires, $data ) = @_;

    my ( $cart_data, $session_data ) = _separate_session_data($data);

    $cart_data    = Data::MessagePack->pack($cart_data)    if $cart_data;
    $session_data = Data::MessagePack->pack($session_data) if $session_data;

    my $resultset      = $self->resultset;
    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $data_column    = $self->data_column;
    my $cart_column    = $self->cart_column;

    my $set = $resultset->single( { $sid_column => $sid } );
    return $set->update(
        {
            $expires_column => $expires,
            $data_column    => $session_data,
            $cart_column    => $cart_data,
        }
    ) ? 1 : 0;
}

sub load {
    my ( $self, $sid ) = @_;

    my $resultset      = $self->resultset;
    my $sid_column     = $self->sid_column;
    my $expires_column = $self->expires_column;
    my $data_column    = $self->data_column;
    my $cart_column    = $self->cart_column;

    my $row = $resultset->single( { $sid_column => $sid } );
    return unless $row;

    my $expires      = $row->get_column($expires_column);
    my $session_data = $row->get_column($data_column);
    my $cart_data    = $row->get_column($cart_column);

    my $data = {};
    $data = Data::MessagePack->unpack($session_data) if $session_data;
    $cart_data = Data::MessagePack->unpack($cart_data) if $cart_data;
    $data->{cart} = $cart_data if $cart_data;

    return ( $expires, $data );
}

sub delete {
    my ( $self, $sid ) = @_;

    my $resultset  = $self->resultset;
    my $sid_column = $self->sid_column;

    return $resultset->search( { $sid_column => $sid } )->delete;
}

1;
__END__

=head1 NAME

MojoX::Session::Store::Teng - Teng Store for MojoX::Session

=head1 SYNOPSIS

    CREATE TABLE session (
        sid          VARCHAR(40) PRIMARY KEY,
        data         LONG TEXT,
        cart         LONG TEXT,
        expires      INTEGER UNSIGNED NOT NULL,
        UNIQUE(sid)
    );

    package MyDB;
    use parent 'Teng';
    __PACKAGE__->load_plugin('ResultSet');

    package main;
    my $db = MyDB->new(...);
    my $rs = $db->resultset('session');
    my $session = MojoX::Session->new(
        store => MojoX::Session::Store::Teng->new(resultset => $rs),
        ...
    );

=head1 DESCRIPTION

L<MojoX::Session::Store::Teng> is a store for L<MojoX::Session> that stores a
session in a database using Teng.

forked by L<MojoX::Session::Store::Dbic>

=head1 ATTRIBUTES

L<MojoX::Session::Store::Teng> implements the following attributes.

=head2 C<resultset>

    my $resultset = $store->resultset;
    $resultset    = $store->resultset(resultset);

Get and set Teng::ResultSet object.

=head2 C<sid_column>

Session id column name. Default is 'sid'.

=head2 C<expires_column>

Expires column name. Default is 'expires'.

=head2 C<data_column>

Data column name. Default is 'data'.

=head2 C<cart_column>

Cart column name. Default is 'cart'.

=head1 METHODS

L<MojoX::Session::Store::Teng> inherits all methods from
L<MojoX::Session::Store>.

=head2 C<create>

Insert session to database.

=head2 C<update>

Update session in database.

=head2 C<load>

Load session from database.

=head2 C<delete>

Delete session from database.

=head1 SEE ALSO

L<Teng>

L<Teng::ResultSet>

L<Mojolicious::Plugin::Session>

L<MojoX::Session>

L<Mojolicious>

=head2 Fork

This module was forked from L<MojoX::Session::Store::Dbic>

=head1 AUTHOR

clicktx

=head1 COPYRIGHT

Copyright (C) 2016, clicktx.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
