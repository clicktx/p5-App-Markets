package Markets::Controller::Admin::Addons;
use Mojo::Base 'Markets::Controller';
use Data::Dumper;

# This action will render a template
sub index {
    my $self = shift;

    # All addons
    my $all_addons = $self->app->addons->get_all;
    $self->render(
        all_addons       => $all_addons,
        installed_addons => $self->app->stash('addons'),
    );
}

sub enable {
    my $self   = shift;
    my $target = $self->param('target');
    my $addon  = $self->stash('addons')->{$target};

    # stash addons を更新
    $addon->{is_enabled} = 1;

    # dbを更新
    # hook routes有効化
    $self->app->addons->to_enable($target);

    # TODO: 本番環境ではアプリケーションの再起動が必要
    # developモードでは反映するようにする？

    $self->redirect_to('/admin/addons');
}

sub disable {
    my $self   = shift;
    my $target = $self->param('target');
    my $addon  = $self->stash('addons')->{$target};

    # stash addons を更新
    $addon->{is_enabled} = 0;

    # dbを更新
    # hook routes無効化
    $self->app->addons->to_disable($target);

    $self->redirect_to('/admin/addons');
}

1;
