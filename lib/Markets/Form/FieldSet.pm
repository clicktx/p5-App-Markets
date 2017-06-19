package Markets::Form::FieldSet;
use Mojo::Base -base;
use Mojo::Util qw/monkey_patch/;
use Tie::IxHash;
use Scalar::Util qw/weaken/;
use Markets::Form::Field;

has 'legend';
has 'params';

sub append {
    my ( $self, $field_key ) = ( shift, shift );
    return unless ( my $class = ref $self || $self ) && $field_key;

    no strict 'refs';
    ${"${class}::field_list"}{$field_key} = +{@_};
}

sub each {
    my ( $self, $cb ) = @_;
    my $class = ref $self || $self;
    my $caller = caller;

    no strict 'refs';
    foreach my $a ( $self->keys ) {
        my $b = ${"${class}::field_list"}{$a};
        local ( *{"${caller}::a"}, *{"${caller}::b"} ) = ( \$a, \$b );
        $a->$cb($b);
    }
}

sub field {
    my ( $self, $name ) = ( shift, shift );
    my $args = @_ > 1 ? +{@_} : shift || {};

    my $class = ref $self || $self;
    my $key = _field_key($name);

    no strict 'refs';
    my $attrs = $key ? ${"${class}::field_list"}{$key} : {};
    return Markets::Form::Field->new( field_key => $key, name => $name, %{$args}, %{$attrs} );
}

sub keys {
    my $self = shift;
    my $class = ref $self || $self;

    no strict 'refs';
    return keys %{"${class}::field_list"};
}

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);

    weaken $self->{params};
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
}

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

# sub renderRow {
#     my $self = shift;
#     return sub {
#         my $app = shift;
#
#         my $form;
#         $self->each(
#             sub {
#
#                 $form .= $app->text_field( $b->name ) . "\n";
#             }
#         );
#
#         # my $tree = ['tag', 'fieldset', undef, undef, [ 'tag', 'aaa' ], [ 'tag', 'aaa' ] ];
#         my $tree = [ 'tag', 'fieldset', undef, undef ];
#         my $root = Mojo::ByteStream->new( Mojo::DOM::HTML::_render($tree) );
#         my $dom  = Mojo::DOM->new($root);
#
#         # $dom->at('fieldset')->append_content('123')->root;
#         $dom->at('fieldset')->append_content( "\n" . $form )->root;
#         $dom;
#     };
# }

sub _field_key { $_ = shift; s/\.\d/.[]/g; $_ }

# sub _id { $_ = shift; s/\./_/g; $_ }
#
# sub _key_id { return ( _key( $_[0] ), _id( $_[0] ) ) }

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

=head1 FUNCTIONS

=head2 C<has_field>

    has_field 'field_name' => ( type => 'text', ... );

=head1 METHODS

=head2 C<append>

    $fieldset->append( 'field_name' => ( %args ) );

=head2 C<field>

    my $field = $fieldset->field('field_name');

Return L<Markets::Form::Field> object.

=head2 C<remove>

    $fieldset->remove('field_name');

=head1 SEE ALSO

=cut
