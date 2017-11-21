package Yetie::Form::TagHelpers;
use Mojo::Base -base;
use Carp qw(croak);
use Mojolicious::Controller;
use Mojolicious::Plugin::TagHelpers;

our $error_class     = 'form-error-block';
our $help_class      = 'form-help-block';
our $required_class  = 'form-required-field-icon';
our $required_icon   = '*';
our $wiget_id_prefix = 'form-widget';

has controller => sub { Mojolicious::Controller->new };

sub AUTOLOAD {
    my ( $self, $field ) = ( shift, shift );
    my ( $package, $method ) = our $AUTOLOAD =~ /^(.+)::(.+)$/;

    my $c     = $self->controller;
    my %attrs = %{$field};

    $attrs{id} = _id( $field->name );
    $attrs{required} ? $attrs{required} = undef : delete $attrs{required};
    delete $attrs{$_} for qw(filters validations);
    my $help           = delete $attrs{help};
    my $error_messages = delete $attrs{error_messages};

    # error message
    return _error( $c, $attrs{name}, $error_messages ) if $method eq 'error_block';

    # help
    return _help( $c, $help ) if $method eq 'help_block';

    # label
    return _label( $c, %attrs, @_ ) if $method eq 'label_for';

    delete $attrs{$_} for qw(field_key type label);

    # hidden
    return _hidden( $c, %attrs, @_ ) if $method eq 'hidden';

    # textarea
    return _textarea( $c, %attrs, @_ ) if $method eq 'textarea';

    croak "Undefined subroutine &${package}::$method called";
}

sub _error {
    my ( $c, $name, $error_messages ) = @_;

    my $error = $c->validation->error($name);
    return unless $error;

    my ( $check, $result, @args ) = @{$error};
    my $message = ref $error_messages eq 'HASH' ? $error_messages->{$check} : '';

    # Default error message
    if ( !$message ) { $message = $c->validation->error_message($name) || 'This field is invalid.' }

    my %args;
    while ( my ( $i, $v ) = each @args ) { $args{$i} = $v }

    my $text = ref $message ? $message->($c) : $c->__x( $message, \%args );
    return $c->tag( 'span', class => $error_class, sub { $text } );
}

sub _help {
    my ( $c, $help ) = @_;

    my $text = ref $help ? $help->($c) : $c->__($help);
    return $c->tag( 'span', class => $help_class, sub { $text } );
}

sub _hidden {
    my $c     = shift;
    my %attrs = @_;

    delete $attrs{required};
    my $default_value = delete $attrs{default_value};
    my $value = delete $attrs{value} // $default_value;
    return $c->hidden_field( $attrs{name} => $value, %attrs );
}

sub _id {
    my $name = shift;
    $name =~ s/\./-/g;
    return $wiget_id_prefix . '-' . $name;
}

sub _label {
    my $c     = shift;
    my %attrs = @_;

    my %label_attrs;
    $label_attrs{class} = $attrs{class} if exists $attrs{class};

    my $required_html =
      exists $attrs{required}
      ? $c->tag( 'span', class => $required_class, sub { $required_icon } )
      : '';
    my $content = $c->__( $attrs{label} ) . $required_html;
    _validation( $c, $attrs{name}, 'label', for => $attrs{id}, %label_attrs, sub { $content } );
}

sub _textarea {
    my $c     = shift;
    my %attrs = @_;

    my $name          = delete $attrs{name};
    my $default_value = delete $attrs{default_value};
    my $value         = delete $attrs{value} // $default_value;
    $attrs{placeholder} = $c->__( $attrs{placeholder} ) if exists $attrs{placeholder};

    return $c->text_area( $name => $value, %attrs );
}

sub _validation { Mojolicious::Plugin::TagHelpers::_validation(@_) }

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Form::TagHelpers

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Form::TagHelpers> inherits all attributes from L<Mojo::Base> and implements the following new ones.

=head1 METHODS

L<Yetie::Form::TagHelpers> inherits all methods from L<Mojo::Base> and implements the following new ones.

=head1 SEE ALSO

L<Yetie::Form>, L<Yetie::Form::FieldSet>, L<Yetie::Form::Field>

=cut
