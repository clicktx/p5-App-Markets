package Markets::Form;
use Mojo::Base -base;

sub new {
    my $self = shift;
    $self->SUPER::new(@_);
}

sub add_param {
    my ( $self, $param, $value, $label, $length, $validations, $filters ) = @_;

    # Default value
    $self->{$param} = $value;
    $self->attr( $param => sub { shift->{$value} } );

    # Label
    $self->{".labels"}->{$param} = $label;

    # Validations
    $self->{".validations"}->{$param} = $validations;

    # Filters
    $self->{".filters"}->{$param} = $filters;

    $self;
}

# [WIP]
sub params {
    my $self = shift;
    say $_ for keys %$self;
}

1;

=encoding utf8

=head1 NAME

Markets::Form - Form object for Markets

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 METHODS

=head2 add_param

    $form->add_param(name => value, display name, lengs, [validations], [filters]);

=head1 SEE ALSO

L<Markets::Plugin::FormFields> L<Mojolicious::Plugin::FormFields>

=cut
