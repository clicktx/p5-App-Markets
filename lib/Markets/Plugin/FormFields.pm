package Markets::Plugin::FormFields;

# TODO: pull requestがmergeされた場合はオリジナル(Mojolicious::Plugin::FormFields v0.06)を使う
# https://github.com/sshaw/Mojolicious-Plugin-FormFields/pull/3

use Mojo::Base 'Mojolicious::Plugin::FormFields';
use Mojo::Util qw(monkey_patch);

# Add cuntom filters
$Validate::Tiny::FILTERS{only_digits} = sub { _only_digits(@_) };

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
}

sub _only_digits {
    my $val = shift // return;
    $val =~ s/\D//g;
    return $val;
}

1;
