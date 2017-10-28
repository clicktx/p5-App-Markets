package Markets::Domain::Entity::Preference;
use Markets::Domain::Entity;
use Carp qw/croak/;

has properties => sub { Markets::Domain::IxHash->new };

sub value {
    my $self = shift;
    return undef unless @_;

    # Setter
    if ( @_ > 1 ) {
        while (@_) {
            my ( $key, $value ) = ( shift, shift );
            croak "Not found preference '$key'" unless $self->properties->{$key};
            $self->properties->{$key}->value($value);
        }
    }

    # Getter
    else {
        my $name = shift;
        croak "'$name' is not set preference" unless $self->properties->{$name};
        my $value = $self->properties->{$name}->value;
        return $value ? $value : $self->properties->{$name}->default_value;
    }
}

1;
__END__

=head1 NAME

Markets::Domain::Entity::Preference

=head1 SYNOPSIS

    $self->attr('admin_uri_prefix');

    admin_uri_prefix => {
        value => 'xxx',
        default_value => 'yyy',
        summary => 'text',
        position => 1,
        group_id => 3,
    }

    # get value
    my $value = $pref->value('admin_uri_prefix');

    # ser value
    $pref->value( admin_uri_prefix => 'sss' );

    # get preferences sort by group
    my @preferences = $pref->group('main');

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Preference> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<properties>

=head1 METHODS

L<Markets::Domain::Entity::Preference> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<value>

    my $value = $pref->value('preference_xxx');
    # $value = $pref->preference_xxx->value || $pref->preference_xxx->default_value;

Get/Set value.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
