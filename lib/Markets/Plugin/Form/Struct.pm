package Markets::Plugin::Form::Struct;
use Mojo::Base -base;

has 'fields';

sub new {
    my $self = shift;
    $self->SUPER::new(@_);
}

sub c { shift->{"controller"} }

sub default_value {
    my ( $self, $name, $value ) = @_;
    return $self->{default_value}->{$name} unless $value;

    $self->{default_value}->{$name} = $value;
}

sub expand_hash {
    my $self   = shift;
    my $fields = $self->fields;
    my $params = $self->params ? $self->params : $self->{default_value};

    $fields => CGI::Expand->expand_hash($params);
}

# [WIP]
sub remove_field { }

sub add_field {
    my ( $self, $field, $length, $filters, $validations ) = @_;

    $self->filters( $field => $filters );
    $self->validations( $field => $validations );
    $self;
}

sub filters {
    my ( $self, $field, $value ) = @_;
    return $self->{field}->{$field}->{filters} unless $value;
    $self->{field}->{$field}->{filters} = $value || [];
}

sub validations {
    my ( $self, $field, $value ) = @_;
    return $self->{field}->{$field}->{validations} unless $value;
    $self->{field}->{$field}->{validations} = $value || [];
}

sub param {
    my ( $self, $name ) = @_;
    $self->params->{$name};
}

sub params {
    my ( $self, $name ) = @_;
    my $params = $self->c->param( $self->fields );
    return $name ? $params->{$name} : $params;
}

# [WIP]
sub valid {
    my $self = shift;
    say "valid from Markets::Form";
    say "language now: " . $self->c->language;

    my $formfields = $self->c->fields( $self->fields );
    my $fields     = $self->fields;

    # POSTされてきたfieldのみバリデーション対象となる
    my @names = @{ $self->c->req->params->names };
    @names = grep { s/^$fields\.// } @names;    ## no critic
    foreach my $name (@names) {
        my $field = $name;
        $field =~ s/\.\d+/.[]/g;

        $formfields->filter( $name, @{ $self->filters($field) } );
        $self->_do_validate( $formfields, $name, $field );
    }
    $formfields->is_equal( 'password', 'confirm_password' );

    # Execute valid method
    my $method = $self->{'formfields_valid'};
    $self->c->$method;
}

sub errors {
    my ( $self, $name ) = @_;
    my $formfields = $self->c->fields( $self->fields );
    return $name ? $formfields->errors($name) : $formfields->errors;
}

sub _do_validate {
    my ( $self, $formfields, $name, $field ) = @_;

    my $validations = $self->validations($field);

    # [WIP]
    foreach my $validation ( @{$validations} ) {
        $formfields->$validation($name);
    }
}

1;

=encoding utf8

=head1 NAME

Markets::Form::Struct - Form for Markets

=head1 SYNOPSIS


=head1 DESCRIPTION

=head1 METHODS

=head2 add_field

    $form->add_field(name, length, [filters], [validations]);
    $form->add_field('password', [8, 32], [qw/trim/], [qw/is_required is_equal/]);

=head2 c

    $form->c;

Return $form->{markets.controller}

=head2 default_value

    # Get value
    my $value = $form->default_value('age');

    # Set value
    $form->default_value('age', 20);

Get/Set default value.

=head2 errors

    # Return value is hash ref.
    # ex. { password => 'Requied', login_name => 'Requied', ... }
    my $error_messages = $form->errors;

    # Return value is scalar
    # ex. 'Requied'
    my $error_message = $form->errors('password');

=head2 expand_hash

    # in your controller
    $self->render(
        $form->expand_hash
    );

    # Return value is fields_name => { ... }

Return default values or form paramater.

=head2 fields

    $form->fields;
    $form->fields('login');

Get/Set $form->{fields} value.

=head2 filters

    $form->filters('password', ['trim']);
    my $filters = $form->filters('password');

Get/Set filters.

=head2 param

    my $password = $form->param('password');

Get field value.

= head2 params

    # Return value is hash ref.
    # ex. { password => 'xxxxxxx', login_name => 'hoge', ... }
    my $params = $form->params;

    # Return value is scalar
    # ex. 'hoge'
    my $login_name = $form->params('login_name');

This method is alias of $controller->param($fields_name)

=head2 valid

    $form->valid;

=head2 validations

    $form->validations('password', ['is_required']);
    my $validations = $form->validations('password');

Get/Set validations.

=head1 SEE ALSO

L<Markets::Plugin::Form> L<Mojolicious::Plugin::FormFields>

=cut
