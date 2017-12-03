package Yetie::Service::Form;
use Mojo::Base 'Yetie::Service';
use Scalar::Util qw(blessed);
use Mojo::Collection qw(c);

sub fill_in {
    my ( $self, $form, $entity ) = @_;

    my @names = $form->fieldset->field_keys;
    foreach my $name (@names) {
        next unless $entity->can($name);

        my $field = $form->field($name);
        my $value = $entity->$name;
        next unless defined $value;

        if ( !ref $value ) {
            _string( $field, $value );
        }
        else {
            # 複数の場合。配列、collection、等
        }

    }
}

sub _string {
    my ( $field, $value ) = @_;

    if ( $field->type =~ /^(choice|select|checkbox|radio)$/ ) {
        $field->choices( _to_choiced( $field->choices, $value ) );
    }
    else { $field->default_value($value) }
}

sub _to_choiced {
    my ( $choices, $value ) = @_;

    foreach my $v ( @{$choices} ) {
        if ( blessed $v && $v->isa('Mojo::Collection') ) {
            my ( $label, $values, @attrs ) = @{$v};

            $values = _to_choiced( $values, $value );
            $v = c( $label, $values, @attrs );
        }
        elsif ( ref $v eq 'ARRAY' ) {
            if ( $v->[1] eq $value ) { push @{$v}, ( choiced => 1 ) }
        }
        else {
            if ( $v eq $value ) { $v = [ $v => $v, choiced => 1 ] }
        }
    }
    return $choices;
}

1;
__END__

=head1 NAME

Yetie::Service::Form

=head1 SYNOPSIS

    my $service = $c->service('form');

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Form> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Form> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<fill_in>

    $service->fill_in( $form => $entity );

Fill in form default value from entity object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Form::Base>, L<Yetie::Domain::Entity>, L<Yetie::Service>
