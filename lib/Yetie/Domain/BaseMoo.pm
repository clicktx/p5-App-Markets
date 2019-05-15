package Yetie::Domain::BaseMoo;
use Moo;
use MooX::StrictConstructor;
use Data::Dumper;
use Mojo::Util qw{};
use strictures 2;
use namespace::clean -except => [ 'new', 'meta' ];

has _hash_sum => ( is => 'lazy' );

sub _build__hash_sum { return shift->hash_code }

sub BUILD {
    my $self = shift;

    # Lazy build
    $self->_hash_sum;
}

sub equals {
    my ( $self, $obj ) = @_;
    return $self->hash_code eq $obj->hash_code ? 1 : 0;
}

sub dump {
    local $Data::Dumper::Terse    = 1;
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Sortkeys = sub {
        my ($hash) = @_;
        my @keys = grep { /\A(?!_).*/sxm } ( sort keys %{$hash} );
        return \@keys;
    };
    return Dumper(shift);
}

sub hash_code { return Mojo::Util::sha1_sum( shift->dump ) }

sub is_modified {
    my $self = shift;
    return $self->_hash_sum ne $self->hash_code ? 1 : 0;
}

1;

=encoding utf8

=head1 NAME

Yetie::Domain::Base

=head1 SYNOPSIS

    package Yetie::Domain::Foo;
    use Moo;
    extends 'Yetie::Domain::Base';

    has value => ( is => 'rw' );

    sub dump { return shift->value }
    1;

=head1 DESCRIPTION

Domain object base class.

=head1 METHODS

L<Yetie::Domain::Base> inherits all methods from L<Moo> and implements
the following new ones.

=head2 C<dump>

    # bless( {}, 'Yetie::Domain::Foo::Bar' )
    my $dump_string = $obj->dump;

=head2 C<equals>

    my $bool = $obj->equals($object);

Return boolean value.

=head2 C<hash_code>

    # "960167e90089e5ebe6a583e86b4c77507afb70b7"
    my $sha1_sum = $obj->hash_code;

Return sha1 string.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moo>, L<MooX::StrictConstructor>
