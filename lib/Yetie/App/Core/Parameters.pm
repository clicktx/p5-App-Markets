package Yetie::App::Core::Parameters;
use Mojo::Base 'Mojo::Parameters';

sub to_hash {
    my $self = shift;

    my %hash;
    my $pairs = $self->pairs;
    for ( my $i = 0 ; $i < @$pairs ; $i += 2 ) {
        my ( $name, $value ) = @{$pairs}[ $i, $i + 1 ];

        # Array
        if ( exists $hash{$name} ) {
            $hash{$name} = [ $hash{$name} ] if ref $hash{$name} ne 'ARRAY';
            push @{ $hash{$name} }, $value;
        }

        # Key suffix is "[]"
        elsif ( $name =~ m/\[\]$/ ) { $hash{$name} = [$value] }

        # String
        else { $hash{$name} = $value }
    }

    return \%hash;
}

1;

=encoding utf8

=head1 NAME

Yetie::App::Core::Parameters

=head1 SYNOPSIS

=head1 DESCRIPTION

This module is L<Mojo::Parameters> Based.

=head1 ATTRIBUTES

L<Yetie::App::Core::Parameters> inherits all attribures from L<Mojo::Parameters> and implements the
following new ones.

=head1 METHODS

L<Yetie::App::Core::Parameters> inherits all methods from L<Mojo::Parameters> and implements the
following new ones.

=head2 C<to_hash>

    my $hash = $params->to_hash;

Turn parameters into a hash reference.

C<Note>
that this method will normalize the parameters.

The difference from L<Mojo::Parameters> is the handling of keys with multiple parameters.
When the suffix of the key is "[]", the value always returns an array reference.

e.g. C<key_name[]>

    # { 'foo[]' => [ 1 ] }
    Mojo::Parameters->new('foo[]=1')->to_hash;

    # { foo => 1 }
    Mojo::Parameters->new('foo=1')->to_hash;

=head1 SEE ALSO

L<Mojo::Parameters>

=cut
