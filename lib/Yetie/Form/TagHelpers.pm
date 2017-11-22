package Yetie::Form::TagHelpers;
use Mojo::Base -base;
use Carp qw(croak);
use Scalar::Util qw/blessed/;
use Mojo::Collection 'c';
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

    # choice
    return _choice_list_widget( $c, %attrs, @_ ) if $method eq 'choice';

    # hidden
    return _hidden( $c, %attrs, @_ ) if $method eq 'hidden';

    # select
    return _select( $c, %attrs, @_ ) if $method eq 'select';

    # textarea
    return _textarea( $c, %attrs, @_ ) if $method eq 'textarea';

    croak "Undefined subroutine &${package}::$method called";
}

# check_box or radio_button into the label
sub _choice_field {
    my ( $c, $values, $pair ) = ( shift, shift, shift );

    $pair = [ $pair, $pair ] unless ref $pair eq 'ARRAY';
    my %attrs = ( value => $pair->[1], @$pair[ 2 .. $#$pair ], @_ );

    # choiced
    my $choiced = delete $attrs{choiced};
    if ($choiced) { $attrs{checked} = $choiced }

    if ( @{$values} ) { delete $attrs{checked} }
    else {    # default checked(bool)
        $attrs{checked} ? $attrs{checked} = undef : delete $attrs{checked};
    }

    my $value = $attrs{value} // 'on';
    $attrs{checked} = undef if grep { $_ eq $value } @{$values};
    my $name = delete $attrs{name};

    my $tag = _validation( $c, $name, 'input', name => $name, %attrs );
    my $label_text = $c->tag( 'span', class => 'label-text', $c->__( $pair->[0] ) );
    return $c->tag( 'label', sub { $tag . $label_text } );
}

# NOTE: multipleの場合はname属性を xxx[] に変更する？
sub _choice_list_widget {
    my $c    = shift;
    my %args = @_;

    my $choices = delete $args{choices} || [];
    my $multiple = delete $args{multiple} ? 1 : 0;
    my $expanded = delete $args{expanded} ? 1 : 0;
    my $flag     = $multiple . $expanded;

    # Add suffix for multiple
    $args{name} .= '[]' if $multiple;

    # radio
    if ( $flag == 1 ) {
        $args{type} = 'radio';
        return _list_field( $c, $choices, %args );
    }

    # select-multiple
    elsif ( $flag == 10 ) {
        $args{multiple} = undef;
        my $name = delete $args{name};
        return $c->select_field( $name => _choices_for_select( $c, $choices ), %args );
    }

    # checkbox
    elsif ( $flag == 11 ) {
        $args{type} = 'checkbox';
        return _list_field( $c, $choices, %args );
    }

    # select
    else {
        my $name = delete $args{name};
        return $c->select_field( $name => _choices_for_select( $c, $choices ), %args );
    }
}

# I18N and bool selected
# NOTE: This function is used only for "$c->select_field" helper
sub _choices_for_select {
    my $c       = shift;
    my $choices = shift;

    for my $group ( @{$choices} ) {
        next unless ref $group;

        # optgroup
        if ( blessed $group && $group->isa('Mojo::Collection') ) {
            my ( $label, $values, %attrs ) = @{$group};
            $label  = $c->__($label);
            $values = _choices_for_select( $c, $values );
            $group  = c( $label => $values, %attrs );
        }
        else {
            my ( $label, $value ) = @{$group};
            $label = $c->__($label);

            # true to "selected"
            my %attrs = ( @{$group}[ 2 .. $#$group ] );

            # choiced
            my $choiced = delete $attrs{choiced};
            if ($choiced) { $attrs{selected} = $choiced }

            $attrs{selected} ? $attrs{selected} = 'selected' : delete $attrs{selected};
            $group = [ $label, $value, %attrs ];
        }
    }
    return $choices;
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

# checkbox list or radio button list
sub _list_field {
    my $c       = shift;
    my $choices = shift;
    my %args    = @_;

    delete $args{$_} for qw(value id);
    my @values = @{ $c->req->every_param( $args{name} ) };

    my $root_class;
    my $groups = '';
    for my $group ( @{$choices} ) {
        if ( blessed $group && $group->isa('Mojo::Collection') ) {
            my ( $label, $v, %attrs ) = @$group;
            $root_class = 'form-choice-groups' unless $root_class;

            $label = $c->__($label);
            my $legend = $c->tag( 'legend', $label );
            my $items = join '',
              map { $c->tag( 'div', class => 'form-choice-item', _choice_field( $c, \@values, $_, %args ) ) } @$v;
            $groups .= $c->tag( 'fieldset', class => 'form-choice-group', %attrs, sub { $legend . $items } );
        }
        else {
            $root_class = 'form-choice-group' unless $root_class;
            my $row = _choice_field( $c, \@values, $group, %args );
            $groups .= $c->tag( 'div', class => 'form-choice-item', sub { $row } );
        }
    }
    return _validation( $c, $args{name}, 'fieldset', class => $root_class, sub { $groups } );
}

sub _select {
    my $c     = shift;
    my %attrs = @_;

    my $choices = delete $attrs{choices} || [];
    my $name = delete $attrs{name};
    return $c->select_field( $name => _choices_for_select( $c, $choices ), %attrs );
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
