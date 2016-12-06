package Markets::Controller;
use Mojo::Base 'Mojolicious::Controller';

sub process {
    my ( $self, $action ) = @_;
    $self->init();
    $self->action_before();
    $self->$action();
    $self->action_after();
}

sub init {
    my $self = shift;
    say "C::init()";
}

sub action_before {
    my $self = shift;
    say "C::action_before()";
    $self->app->plugins->emit_hook( before_action => $self );
}

sub action_after {
    my $self = shift;
    say "C::action_after()";
    $self->app->plugins->emit_hook( after_action => $self );
}

1;
