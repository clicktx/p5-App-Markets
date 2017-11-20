package Yetie::Form::TagHelpers;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app, $conf ) = @_;

    my $stash_key = $conf->{stash_key};
    $app->helper( form_error => sub { _form_error( $stash_key, @_ ) } );
    $app->helper( form_help => sub { _form_help( $stash_key, @_ ) } );
    $app->helper( form_label => sub { _form_label( $stash_key, @_ ) } );
    $app->helper( form_widget => sub { _form_widget( $stash_key, @_ ) } );
}

sub _form_error {
    my ( $form, $topic_field ) = _topic(@_);
    $form->field($topic_field)->error_block( $form->controller );
}

sub _form_help {
    my ( $form, $topic_field ) = _topic(@_);
    $form->field($topic_field)->help_block( $form->controller );
}

sub _form_label {
    my ( $form, $topic_field, %attrs ) = _topic(@_);
    $form->field($topic_field)->label_for( $form->controller, %attrs );
}

sub _form_widget {
    my ( $form, $topic_field, %attrs ) = _topic(@_);

    my $value = $form->controller->req->params->param($topic_field);
    $attrs{value} = $value if defined $value;

    my $field = $form->fieldset->field($topic_field);
    my $method = $field->type || 'text';
    $field->$method( $form->controller, %attrs );
}

sub _topic {
    my ( $stash_key, $c ) = ( shift, shift );

    my $topic =
      ( @_ ? @_ % 2 ? shift : $c->stash( $stash_key . '.topic_field' ) : $c->stash( $stash_key . '.topic_field' ) )
      || '';
    my ( $topic_form, $topic_field ) = $topic =~ /#/ ? $topic =~ /(.*)#(.+)/ : ( undef, $topic );
    die 'Unable to set field name' unless $topic_field;

    $topic_form = $c->stash( $stash_key . '.topic' ) unless $topic_form;
    die 'Unable to set form' unless $topic_form;

    my $form = $c->form($topic_form);
    return ( $form, $topic_field, @_ );
}

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
