package Yetie::Domain::Entity::Address;
use Yetie::Domain::Entity;
use Mojo::Util qw(encode);

has hash          => '';
has country_code  => '';
has line1         => '';
has line2         => '';
has level1        => '';
has level2        => '';
has postal_code   => '';
has personal_name => '';
has company_name  => '';
has phone         => '';
has fax           => '';
has mobile        => '';

has type           => '';
has collate_fields => sub {
    {
        us => [qw(country_code personal_name company_name line1 line2 level2 level1 postal_code phone fax mobile)],
        jp => [qw(country_code personal_name company_name postal_code level1 level2 line1 line2 phone fax mobile)],
    };
};
has locale_notation => sub {
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
            $self->personal_name, $self->company_name, $self->line2, $self->line1,
            [ $self->level2, ", ", $self->level1, " ", $self->postal_code ],
            $country, @contacts
        ],
        jp => [
            $self->postal_code, $self->level1 . $self->level2 . $self->line1,
            $self->line2, $self->company_name, $self->personal_name, $country, @contacts
        ],
    };
};

sub fields {
    my $self = shift;
    my $region = shift || 'us';
    $self->collate_fields->{$region} || $self->collate_fields->{us};
}

sub hash_code {
    my $self = shift;

    my $bytes;
    $bytes .= encode( 'UTF-8', $self->$_ ) || '' for qw(
      line1 line2 postal_code personal_name company_name
    );
    $self->SUPER::hash_code($bytes);
}

sub notation {
    my $self = shift;

    my $country_code = $self->country_code;
    $self->locale_notation->{$country_code} || $self->locale_notation->{us};
}

sub to_data {
    my $self = shift;
    my $data = $self->SUPER::to_hash;

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

=head2 C<fields>

Get form field names.

    my $fields = $e->fields($region);

    # Country Japan
    my $fields = $e->fields('jp');

Return Array refference.

Default region "us".

=head2 C<notation>

    my $notation = $e->notation;

Acquire notation method of address.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
