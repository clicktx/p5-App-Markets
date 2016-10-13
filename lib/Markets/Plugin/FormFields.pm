package Markets::Plugin::FormFields;

# TODO: pull requestがmergeされた場合はオリジナル(Mojolicious::Plugin::FormFields v0.06)を使う
# https://github.com/sshaw/Mojolicious-Plugin-FormFields/pull/3

use Mojo::Base 'Mojolicious::Plugin::FormFields';
use Mojo::Util qw(monkey_patch);
use Markets::Form;

# Override method
monkey_patch 'Mojolicious::Plugin::FormFields::Field', valid => sub {
    my $self = shift;
    return $self->{result}->{success} if defined $self->{result};

    my $result;
    my $name  = $self->{name};
    my $value = $self->{c}->param($name);
    my $field = { $name => $value };
    my $rules = {
        fields  => [$name],
        checks  => $self->{checks},
        filters => $self->{filters}
    };

    # A bit of massaging For the is_equal() validation
    my $eq = $self->{eq_to_field};
    if ($eq) {
        $field->{$eq} = $self->{c}->param($eq);
        push @{ $rules->{fields} }, $eq;
    }

    $result = Validate::Tiny::validate( $field, $rules );
    $self->{c}->req->params->param( $name, $result->{data}->{$name} )
      if @{ $self->{filters} };
    $self->{result} = $result;

    $result->{success};
};

monkey_patch 'Mojolicious::Plugin::FormFields::Field', label => sub {
    my $self = shift;

    my $text;
    $text = pop   if ref $_[-1] eq 'CODE';
    $text = shift if @_ % 2;                 # step on CODE

    my $SEPARATOR = $self->separator;
    my @result = ( split /\Q$SEPARATOR/, $self->{name} );
    $text //= $self->{c}->__( $self->{name} );

    # $text //= $self->{c}->stash( $result[0] )->{".labels"}->{ $result[-1] };
    $text //=
      Mojolicious::Plugin::FormFields::Field::_default_label( $self->{name} );

    my %options = @_;
    $options{for} //=
      Mojolicious::Plugin::FormFields::Field::_dom_id( $self->{name} );

    $self->{c}->tag( 'label', %options, $text );
};

sub register {
    my ( $self, $app, $config ) = @_;
    my $ns = 'formfields.fields';
    $self->SUPER::register( $app, $config );

    # Override helper
    my $methods = $config->{methods};
    my $helper = $methods->{valid} // 'valid';
    $app->helper(
        $helper => sub {
            my $c      = shift;
            my $valid  = 1;
            my $errors = {};

            # TODO: skip keys used by fields()
            while ( my ( $name, $field ) = each %{ $c->stash->{$ns} } ) {
                if ( !$field->valid ) {
                    $valid = 0;
                    $errors->{$name} = $field->error;
                }
            }

            my $hash = Mojolicious::Plugin::ParamExpand::expander->expand_hash(
                $c->req->params->to_hash );
            $c->param( $_ => $hash->{$_} ) for keys %$hash;

            $c->stash->{"$ns.errors"} = $errors;
            $valid;
        }
    );
    $app->helper(
        form => sub {
            Markets::Form->new(
                'markets.controller'        => shift,
                'markets.form.fields'       => shift,
                'markets.form.valid.method' => $helper,
            );
        }
    );
}

1;
