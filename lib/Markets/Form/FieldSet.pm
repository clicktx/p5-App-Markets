package Markets::Form::FieldSet;
use Mojo::Base -base;
use Mojo::Util qw/monkey_patch/;
use Tie::IxHash;
use Scalar::Util qw/weaken/;
use Mojolicious::Controller;
use Mojo::Collection;
use Markets::Form::Field;

has field_list => sub { {} };
has controller => sub { Mojolicious::Controller->new };

sub append {
    my ( $self, $field_key ) = ( shift, shift );
    return unless ( my $class = ref $self || $self ) && $field_key;

    no strict 'refs';
    ${"${class}::field_list"}{$field_key} = +{@_};
}

# sub each {
#     my ( $self, $cb ) = @_;
#     my $class = ref $self || $self;
#     my $caller = caller;
#
#     no strict 'refs';
#     foreach my $a ( $self->field_keys ) {
#         my $b = ${"${class}::field_list"}{$a};
#         local ( *{"${caller}::a"}, *{"${caller}::b"} ) = ( \$a, \$b );
#         $a->$cb($b);
#     }
# }

sub field_keys {
    my $self = shift;
    my $class = ref $self || $self;

    no strict 'refs';
    my @field_keys = keys %{"${class}::field_list"};
    return wantarray ? @field_keys : \@field_keys;
}

sub field {
    my ( $self, $name ) = ( shift, shift );
    my $args = @_ > 1 ? +{@_} : shift || {};
    my $class = ref $self || $self;

    my $field_key = _replace_key($name);

    no strict 'refs';
    my $attrs = $field_key ? ${"${class}::field_list"}{$field_key} : {};
    return Markets::Form::Field->new( field_key => $field_key, name => $name, %{$args}, %{$attrs} );
}

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);

    weaken $self->{params};
    weaken $self->{controller};

    no strict 'refs';
    $self->{field_list} = \%{"${class}::field_list"};

    return $self;
}

sub import {
    my $class  = shift;
    my $caller = caller;

    no strict 'refs';
    no warnings 'once';
    push @{"${caller}::ISA"}, $class;
    tie %{"${caller}::field_list"}, 'Tie::IxHash';
    monkey_patch $caller, 'has_field', sub { append( $caller, @_ ) };
    monkey_patch $caller, 'c', sub { Mojo::Collection->new(@_) };
}

sub params { shift->controller->req->params(@_) }

sub remove {
    my ( $self, $field_key ) = ( shift, shift );
    return unless ( my $class = ref $self || $self ) && $field_key;

    no strict 'refs';
    delete ${"${class}::field_list"}{$field_key};
}

sub render_label {
    my $self = shift;
    my $name = shift;

    $self->field($name)->label_for;
}

sub render {
    my $self = shift;
    my $name = shift;

    my $field = $self->field( $name, value => $self->params->param($name) );
    my $method = $field->type || 'text';
    $field->$method;
}

sub validations {
    my ( $self, $field_key ) = ( shift, shift );
    my $field_list = $self->field_list;
    return $field_list->{$field_key}->{validations} if $field_key;

    my %validations = map { $_ => $field_list->{$_}->{validations} } @{ $self->field_keys };
    return \%validations;
}

sub _replace_key { $_ = shift; s/\.\d/.[]/g; $_ }

1;
__END__

=encoding utf8

=head1 NAME

Markets::Form::Field

=head1 SYNOPSIS

    package MyForm::Field::User;
    use Markets::Form::FieldSet;

    has_field 'name' => ( %args );


    # In controller
    my $fieldset = MyForm::Field::User->new(%params);


=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<controller>

    my $controller = $fieldset->controller;
    $fieldset->controller( Mojolicious::Controller->new );

Return L<Mojolicious::Controller> object.

=head1 FUNCTIONS

=head2 C<c>

    my $collection = c(1, 2, 3);

Construct a new array-based L<Mojo::Collection> object.

=head2 C<has_field>

    has_field 'field_name' => ( type => 'text', ... );

=head1 METHODS

=head2 C<append>

    $fieldset->append( 'field_name' => ( %args ) );

=head2 C<field_keys>

    my @field_keys = $fieldset->field_keys;

    # Return array refference
    my $field_keys = $fieldset->field_keys;

=head2 C<field>

    my $field = $fieldset->field('field_name');

Return L<Markets::Form::Field> object.

=head2 C<params>

    my $params = $fieldset->params;
    my $params_hash_ref = $fieldset->params->to_hash;

    # Longer Version
    my $params = $fieldset->controller->req->params;

    # Append parameter
    $fieldset->params->append( email => 'a@b.com' );

Return L<Mojo::Parameters> object.

=head2 C<remove>

    $fieldset->remove('field_name');

=head2 C<render_label>

    $fieldset->render_label('email');

Return code refference.

=head2 C<render>

    $fieldset->render('email');

Return code refference.

=head2 C<validations>

    # Return array refference
    my $validations = $fieldset->validations('email');

    # Return hash refference
    my $validations = $fieldset->validations;

=head1 SEE ALSO

=cut
