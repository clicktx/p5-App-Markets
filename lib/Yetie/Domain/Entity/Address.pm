package Yetie::Domain::Entity::Address;
use Mojo::Util qw(encode);

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has _country => (
    is       => 'ro',
    init_arg => 'country',
    reader   => 'country',
);
has _state => (
    is       => 'ro',
    init_arg => 'state',
    reader   => 'state',
);
has _state_code => (
    is       => 'ro',
    init_arg => 'state_code',
    reader   => 'state_code',
);

my $attrs = [qw(country_code state_id line1 line2 city postal_code personal_name organization phone)];
has $attrs => ( is => 'ro', default => q{} );
has hash => (
    is         => 'ro',
    lazy_build => 1,
);

has _locale_field_names => (
    is      => 'ro',
    default => sub {
        {
            us => [qw(country_code state_code personal_name organization line1 line2 city state postal_code phone)],
            jp => [qw(country_code state_code personal_name organization postal_code state city line1 line2 phone)],
        };
    }
);

has _locale_notation => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;

        my $country_name = {
            us => 'United States',
            jp => 'Japan',
        };
        my $country = $country_name->{ $self->country_code };

        # NOTE: templateでclass を追加できるようにしたい
        # Address::ViewFormat
        # $address->view('attr')  $address->attr
        # $address->view( \$scalar ) $scalar
        # $address->view( { class => [ 'attr1', 'attr2' ] } ) $address->attr1 . $address->attr2
        # <li class="<%=  %>"><%= $address->view($_) %></li>
        my $lines = {
            us => [
                qw(personal_name organization line2 line1),
                { main => [ 'city', \', ', 'state', \' ', 'postal_code' ] },
                qw(country_name phone)
            ],
            jp => [ qw(postal_code), [qw(state city line1)], qw(line2 organization personal_name country_name phone) ],
        };

        # use DDP;
        # p $lines->{us};

        return {
            us => [
                $self->personal_name, $self->organization, $self->line2, $self->line1,
                [ $self->city, ', ', $self->state, q{\s}, $self->postal_code ],
                $country, $self->phone
            ],
            jp => [
                $self->postal_code,   $self->state . $self->city . $self->line1,
                $self->line2,         $self->organization,
                $self->personal_name, $country,
                $self->phone
            ],
        };
    }
);

override 'to_order_data' => sub {
    my $self = shift;
    return { id => $self->id };
};

sub _build_hash { return shift->hash_code }

sub empty_hash_code { return shift->hash_code('empty') }

sub equals {
    my ( $self, $address ) = @_;
    return $self->hash_code eq $address->hash_code ? 1 : 0;
}

sub field_names {
    my $self = shift;
    my $region = shift || 'us';    # FIXME:
    return $self->_locale_field_names->{$region} || $self->_locale_field_names->{us};
}

sub hash_code {
    my ( $self, $mode ) = ( shift, shift || '' );

    my $str = '';
    foreach my $attr ( @{$attrs} ) {
        my $value = $mode eq 'empty' ? '' : $self->$attr // '';
        $str .= '::' . encode( 'UTF-8', $value );
    }
    $str =~ s/\s//g;
    return $self->SUPER::hash_code($str);
}

sub is_empty {
    my $self = shift;
    return $self->hash_code eq $self->empty_hash_code ? 1 : 0;
}

sub notation {
    my $self = shift;

    my $country_code = $self->country_code;
    return $self->_locale_notation->{$country_code} || $self->_locale_notation->{us};
}

sub to_data {
    my $self = shift;
    my $data = $self->SUPER::to_data;

    # Regenerate hash code
    $data->{hash} = $self->hash_code;
    return $data;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Address

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Address> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<city>

=head2 C<country>

=head2 C<country_code>

=head2 C<hash>

=head2 C<line1>

=head2 C<line2>

=head2 C<organization>

=head2 C<personal_name>

=head2 C<phone>

=head2 C<postal_code>

=head2 C<state>

=head2 C<state_code>

=head2 C<state_id>

=head1 METHODS

L<Yetie::Domain::Entity::Address> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<empty_hash_code>

    my $hash_code = $address->empty_hash_code;

All data empty L</hash_code>.

=head2 C<equals>

    my $bool = $address->equals($other_address);

Compare L</hash_code>.

Return boolean value.

=head2 C<field_names>

Get form field names.

    my $field_names = $address->field_names($region);

    # Country Japan
    my $field_names = $address->field_names('jp');

Return Array reference.

Default region "us".

=head2 C<hash_code>

    my $hash_code = $address->hash_code;

Generate unique hash code from address information.

=head2 C<is_empty>

    my $bool = $address->is_empty;

Return boolean value.

=head2 C<new>

    my $address = Yetie::Domain::Entity->new( \%arg );

Generates a hash attribute at instance creation.

=head2 C<notation>

    my $notation = $address->notation;

Acquire notation method of address.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
