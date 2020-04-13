package Yetie::Service::Address;
use Mojo::Base 'Yetie::Service';
use Mojo::Collection qw(c);
use Yetie::Util qw(args2hash);

sub find_or_create_address {
    my ( $self, $address ) = @_;

    my $data = $address->to_data;
    if ( !$data->{state_id} ) {
        $data->{state_id} = $self->resultset('AddressState')->get_id(
            country_code => $address->country_code,
            state_code   => $address->state_code,
        );
    }

    my $result = $self->resultset('Address')->find_or_create_address($data);
    my $new_address = $address->clone( id => $result->id );
    return $new_address;
}

sub get_form_choices_country {
    my $self   = shift;
    my $option = args2hash(@_);

    my $where = {};
    if ( $option->{is_actived} ) { $where->{is_actived} = 1 }

    my $rs = $self->resultset('AddressContinent')->get_countries($where);
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
    return if !$registered || $registered->id == $address->id;

    return $registered->id;
}

sub init_form {
    my ( $self, $form, $country_code ) = @_;

    my $country_choices = $self->get_form_choices_country( is_actived => 1 );
    my $field = $form->field('country_code');
    $field->choices($country_choices);
    $field->choiced($country_code);    # Default choiced

    my $state_choices = $self->get_form_choices_state($country_code);
    $form->field('state_code')->choices($state_choices);
    return;
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

=head2 C<find_or_create_address>

    my $address_obj = $c->factory('entity-address')->construct(%params);
    my $new_address_obj = $service->find_or_create_address($address_obj);

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

=head2 C<init_form>

    my $form_obj = $c->form('base-address');
    my $country_code = 'JP';
    $service->init_form( $form_obj, $country_code );

Set L<Yetie::Form::Field/choices> in form field C<country_code> and C<state_code>.

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
