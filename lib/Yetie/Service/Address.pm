package Yetie::Service::Address;
use Mojo::Base 'Yetie::Service';
use Mojo::Collection qw(c);
use Yetie::Util qw(args2hash);

sub get_form_choices_country {
    my $self   = shift;
    my $option = args2hash(@_);

    my $where = {};
    if ( $option->{is_actived} ) { $where->{is_actived} = 1 }

    my $rs = $self->resultset('AddressContinent')->search(
        $where,
        {
            prefetch => 'countries',
            order_by => [ 'me.position', 'countries.position' ],
        }
    );

    my @choices;
    $rs->each(
        sub {
            my $continent = shift;
            my $countries = $continent->countries->to_array_name_code_pair();
            push @choices, c( $continent->name => $countries );
        }
    );
    return \@choices;
}

sub get_form_choices_state {
    my ( $self, $country_code ) = @_;

    my $rs = $self->resultset('AddressState')->search( { country_code => $country_code } );
    return $rs->to_array_name_code_pair();
}

sub get_registered_id {
    my ( $self, $address ) = @_;

    my $registered = $self->resultset('Address')->search( { hash => $address->hash } )->first;
    return if !$registered or $registered->id == $address->id;

    return $registered->id;
}

sub set_address_id {
    my ( $self, $address ) = @_;

    my $result     = $self->resultset('Address')->find_or_create_address( $address->to_hash );
    my $address_id = $result->id;
    $address->id($address_id);
    return $address_id;
}

sub update_address {
    my ( $self, $params ) = @_;

    my $address       = $self->factory('entity-address')->construct($params);
    my $registered_id = $self->get_registered_id($address);

    if ($registered_id) {

        # 登録済みの住所なのでchangeするか確認する
        say 'Registered address';
        die;
    }
    else {
        # Update address
        $self->resultset('Address')->search( { id => $address->id } )->update( $address->to_data );
    }

    return;
}

1;
__END__

=head1 NAME

Yetie::Service::Address

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Address> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Address> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<get_form_choices_country>

    my $choices = get_form_choices_country( %OPTIONS | \%OPTIONS );

    my $all_countries = get_form_choices_country();
    my $active_countries = get_form_choices_country( is_actived => 1 );

B<OPTIONS>

is_actived default: 0 get all countries

Return Array reference.

Data structure: L<Yetie::Form::Field/choices>

=head2 C<get_form_choices_state>

    my $choices = get_form_choices_state($country_code);

Return Array reference.

Data structure: L<Yetie::Form::Field/choices>

=head2 C<get_registered_id>

    my $address_entity = $c->factory('entity-address')->construct($form_params);
    my $address_id = $service->get_registered_id($address_entity);

Return address ID or C<undefined>.

=head2 C<set_address_id>

Set the address ID.

    $service->set_address_id($address_object);

Arguments L<Yetie::Domain::Entity::Address> object.

Return address ID.

=head2 C<update_address>

    $service->update_address(\%form_params);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
