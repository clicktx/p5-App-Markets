package Markets::Addon::TestAddon;
use Mojo::Base 'Markets::Addon';

sub register {
    my ( $self, $app, $conf ) = @_;

    $self->add_action(
        'action_exsample_hook' => \&action_exsample_hook,
        { default_priority => 500 }
    );
    $self->add_action(
        'action_exsample_hook' => \&action_exsample_hook,
    );
    $self->add_filter(
        'filter_exsample_hook' => \&filter_exsample_hook,
        { default_priority => 10 }
    );
    $self->add_filter(
        'filter_exsample_hook' => \&filter_exsample_hook,
    );

}

sub action_exsample_hook {
    my ( $c, $arg ) = @_;
}

sub filter_exsample_hook {
    my ( $c, $arg ) = @_;
}

1;
