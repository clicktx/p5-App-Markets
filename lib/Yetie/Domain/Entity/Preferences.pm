package Yetie::Domain::Entity::Preferences;
use Yetie::Domain::Set;
use Carp qw/croak/;

sub properties { shift->hash_set(@_) }

sub value {
    my $self = shift;
    return undef unless @_;

    # Setter
    if ( @_ > 1 ) {
        while (@_) {
            my ( $key, $value ) = ( shift, shift );
            croak "Not found preference '$key'" unless $self->hash_set->{$key};
            $self->hash_set->{$key}->value($value);
        }
    }

    # Getter
    else {
        my $name = shift;
        croak "'$name' is not set preference" unless $self->hash_set->{$name};
        my $value = $self->hash_set->{$name}->value;
        return $value ? $value : $self->hash_set->{$name}->default_value;
    }
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Preferences

=head1 SYNOPSIS

    # get value
    my $value = $pref->value('admin_uri_prefix');

    # set value
    $pref->value( admin_uri_prefix => 'sss' );

    # get preferences sort by group
    my @preferences = $pref->group('main');

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Preferences> inherits all attributes from L<Yetie::Domain::Set> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::Preferences> inherits all methods from L<Yetie::Domain::Set> and implements
the following new ones.

=head2 C<value>

    my $value = $pref->value('preference_xxx');
    # $value = $pref->preference_xxx->value || $pref->preference_xxx->default_value;

Get/Set value.

=head2 C<properties>

    my $properties = $pref->properties;
    $pref->properties($IxHash_object);

Get/Set self-attribute "hash_set".

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Set>
