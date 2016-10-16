package Markets::Plugin::Form::Struct;
use Mojo::Base -base;

sub new {
    my $self = shift;
    $self->SUPER::new(@_);
}

sub c { shift->{"markets.controller"} }

sub fields {
    my ( $self, $arg ) = @_;
    return $self->{"markets.form.fields"} unless $arg;
    $self->{"markets.form.fields"} = $arg;
    $self;
}

# [WIP]
sub remove_field { }

sub add_field {
    my ( $self, $name, $length, $filters, $validations ) = @_;

    # Default value
    $self->{$name} = '';
    $self->attr($name);

    $self->filters( $name => $filters );
    $self->validations( $name => $validations );

    $self;
}

sub validations {
    my ( $self, $name, $value ) = @_;
    return $self->{"markets.form.validations"}->{$name} unless $value;
    $self->{"markets.form.validations"}->{$name} = $value;
}

sub filters {
    my ( $self, $name, $value ) = @_;
    return $self->{"markets.form.filters"}->{$name} unless $value;
    $self->{"markets.form.filters"}->{$name} = $value;
}

sub default_value {
    my ( $self, $name, $value ) = @_;
    return $self->{$name} unless $value;

    $self->{$name} = $value;
}

sub names {
    my $self = shift;

    my @names = grep { $_ =~ /^markets\..+/ ? undef : $_ } keys %{$self};
    return wantarray ? @names : \@names;
}

sub params {
    my $self = shift;
    $self->c->param( $self->fields );
}

sub param {
    my ( $self, $name ) = @_;
    $self->params->{$name};
}

# [WIP]
sub valid {
    my $self = shift;
    say "valid from Markets::Form";
    say "language now: " . $self->c->language;

    my $fields = $self->c->fields( $self->fields );
    foreach my $name ( @{ $self->names } ) {
        $fields->filter( $name, @{ $self->filters($name) } );

        $self->_add_validation( $fields, $name );
    }

    $fields->is_equal( 'password', 'confirm_password' );

    # Execute valid method
    my $method = $self->{"markets.formfields.valid.method"};
    $self->c->$method;
}

sub errors {
    my ( $self, $name ) = @_;
    my $form_fields = $self->c->fields( $self->fields );
    return $name ? $form_fields->errors($name) : $form_fields->errors;
}

sub _add_validation {
    my ( $self, $fields, $name ) = @_;
    my $validations = $self->validations($name);
    use DDP {

        # deparse => 1,
        # filters => {
        #        'DateTime' => sub { shift->ymd },
        # },
    };
    p($validations);

    # [WIP]
    foreach my $validation ( @{$validations} ) {
        $fields->$validation($name);
    }
}

1;

=encoding utf8

=head1 NAME

Markets::Form::Struct - Form for Markets

=head1 SYNOPSIS


=head1 DESCRIPTION

=head1 ALIAS

=head2 c

    $form->c;

Return $form->{markets.controller}

=head2 fields

    $form->fields;
    $form->fields('login');

Get/Set $form->{markets.form.fields} value.

=head1 METHODS

=head2 add_field

    $form->add_field(name, length, [filters], [validations]);
    $form->add_field('password', [8, 32], [qw/trim/], [qw/is_required is_equal/]);

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

=head2 names

    my $names = $form->names;
    my @names = $form->names;

=head2 valid

    $form->valid;

=head2 errors

    # Return value is hash ref.
    # ex. { password => 'Requied', login_name => 'Requied', ... }
    my $error_messages = $form->errors;

    # Return value is scalar
    # ex. 'Requied'
    my $error_message = $form->errors('password');

= head2 params

    my $params = $form->params;

Return value is hash ref.
This method is alias of $controller->param($fields_name)

=head2 param

    my $password = $form->param('password');

Get field value.

=head1 SEE ALSO

L<Markets::Plugin::Form> L<Mojolicious::Plugin::FormFields>

=cut
