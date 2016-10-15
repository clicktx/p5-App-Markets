package Markets::Plugin::Form::Param;
use Mojo::Base -base;

sub new {
    my $self = shift;
    $self->SUPER::new(@_);
}

sub c      { shift->{"markets.controller"} }
sub fields {
    my ($self, $arg) = @_;
    return $self->{"markets.form.fields"} unless $arg;
    $self->{"markets.form.fields"} = $arg;
    $self;
}

# [WIP]
sub remove_param { }

sub add_param {
    my ( $self, $param, $length, $filters, $validations ) = @_;

    # Default value
    $self->{$param} = '';
    $self->attr($param);

    $self->filters( $param => $filters );
    $self->validations( $param => $validations );

    $self;
}

sub validations {
    my ( $self, $param, $value ) = @_;
    return $self->{"markets.form.validations"}->{$param} unless $value;
    $self->{"markets.form.validations"}->{$param} = $value;
}

sub filters {
    my ( $self, $param, $value ) = @_;
    return $self->{"markets.form.filters"}->{$param} unless $value;
    $self->{"markets.form.filters"}->{$param} = $value;
}

sub default_value {
    my ( $self, $param, $value ) = @_;
    return $self->{$param} unless $value;

    $self->{$param} = $value;
}

sub params {
    my $self = shift;

    my @params = grep { $_ =~ /^markets\..+/ ? undef : $_ } keys %{$self};
    return wantarray ? @params : \@params;
}

# [WIP]
sub valid {
    my $self = shift;
    say "valid from Markets::Form";
    say "language now: " . $self->c->language;

    my $fields = $self->c->fields( $self->fields );
    foreach my $param ( @{ $self->params } ) {
        $fields->filter( $param, @{ $self->filters($param) } );

        $self->_add_validation( $fields, $param );
    }

    $fields->is_equal( 'password', 'confirm_password' );

    # Execute valid method
    my $method = $self->{"markets.form.valid.method"};
    $self->c->$method;
}

sub _add_validation {
    my ( $self, $fields, $param ) = @_;
    my $validations = $self->validations($param);
    use DDP {

        # deparse => 1,
        # filters => {
        #        'DateTime' => sub { shift->ymd },
        # },
    };
    p($validations);

    # [WIP]
    foreach my $validation ( @{$validations} ) {
        $fields->$validation($param);
    }
}

1;

=encoding utf8

=head1 NAME

Markets::Form - Form for Markets

=head1 SYNOPSIS


=head1 DESCRIPTION

=head1 ALIAS

=head2 c

    $form->c;

Return $form->{markets.controller}

=head2 fields

    $form->fields;

Return $form->{markets.form.fields}

=head1 METHODS

=head2 add_param

    $form->add_param(name, length, [filters], [validations]);
    $form->add_param('password', [8, 32], [qw/trim/], [qw/is_required is_equal/]);

=head2 validations

    $form->validations('password', ['is_required']);
    my $validations = $form->validations('password');

Get/Set validations.

=head2 filters

    $form->filters('password', ['trim']);
    my $filters = $form->filters('password');

Get/Set filters.

=head2 default_value

    # Get value
    my $value = $form->default_value('age');

    # Set value
    $form->default_value('age', 20);

Get/Set default value.

=head2 params

    my $params = $form->params;
    my @params = $form->params;

=head2 valid

    $form->valid;

=head1 SEE ALSO

L<Markets::Plugin::FormFields> L<Mojolicious::Plugin::FormFields>

=cut
