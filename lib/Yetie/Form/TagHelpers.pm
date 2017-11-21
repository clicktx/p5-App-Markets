package Yetie::Form::TagHelpers;
use Mojo::Base -base;
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

    # help
    return _help( $c, $help ) if $method eq 'help_block';

    # label
    return _label( $c, %attrs, @_ ) if $method eq 'label_for';
}

sub _help {
    my ( $c, $help ) = @_;

    my $text = ref $help ? $help->($c) : $c->__($help);
    return $c->tag( 'span', class => $help_class, sub { $text } );
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
