package Yetie::Domain::Entity::Address;
use Yetie::Domain::Entity;
use Mojo::Util qw(encode);

my $attrs = [qw(country_code line1 line2 state city postal_code personal_name organization phone fax mobile)];
has $attrs;
has hash => '';
has type => '';

has _locale_field_names => sub {
    {
        us => [qw(country_code personal_name organization line1 line2 city state postal_code phone fax mobile)],
        jp => [qw(country_code personal_name organization postal_code state city line1 line2 phone fax mobile)],
    };
};
has _locale_notation => sub {
    my $self = shift;

    my $country_name = {
        us => 'United States',
        jp => 'Japan',
    };
    my $country = $country_name->{ $self->country_code };

    my @contacts = ( "TEL: " . $self->phone );
    push @contacts, "FAX: " . $self->fax       if $self->fax;
    push @contacts, "MOBILE: " . $self->mobile if $self->mobile;

    return {
        us => [
            $self->personal_name, $self->organization, $self->line2, $self->line1,
            [ $self->city, ", ", $self->state, " ", $self->postal_code ],
            $country, @contacts
        ],
        jp => [
            $self->postal_code, $self->state . $self->city . $self->line1,
            $self->line2, $self->organization, $self->personal_name, $country, @contacts
        ],
    };
};

sub field_names {
    my $self = shift;
    my $region = shift || 'us';
    $self->_locale_field_names->{$region} || $self->_locale_field_names->{us};
}

sub hash_code {
    my $self = shift;

    my $str = '';
    foreach my $attr ( @{$attrs} ) {
        my $value = $self->$attr // '';
        $value = $value->number_only if ref $value;
        $str .= '::' . encode( 'UTF-8', $value );
    }
    $str =~ s/\s//g;
    $self->SUPER::hash_code($str);
}

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);

    $self->hash( $self->hash_code );
    $self->is_modified(0);
    return $self;
}

sub notation {
    my $self = shift;

    my $country_code = $self->country_code;
    $self->_locale_notation->{$country_code} || $self->_locale_notation->{us};
}

sub to_data {
    my $self = shift;

    my $data = {};
    $data->{$_} = $self->$_ // '' for @{$attrs};

    # Generate hash
    $data->{hash} = $self->hash_code;
    return $data;
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Address

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Address> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::Address> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<field_names>

Get form field names.

    my $field_names = $address->field_names($region);

    # Country Japan
    my $field_names = $address->field_names('jp');

Return Array refference.

Default region "us".

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
