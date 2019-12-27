package Yetie::Domain::List::PaymentMethods;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::List';

sub to_form_choices {
    return shift->reduce( sub { [ @{$a}, [ $b->name, $b->id ] ] }, [] );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::List::PaymentMethods

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::PaymentMethods> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::List::PaymentMethods> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<to_form_choices>

    # [ [ foo => 1 ], [ bar => 2 ], ... ]
    my $form_choices = $list->to_form_choices();

    # set choices
    $form->field('field_name')->choices($form_choices);

Return array reference of array reference.

See L<Yetie::Form::Field/choices>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::List>
