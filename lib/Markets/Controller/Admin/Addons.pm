package Markets::Controller::Admin::Addons;
use Mojo::Base 'Markets::Controller::Admin';
use Data::Dumper;

# This action will render a template
sub index {
    my $self = shift;

    # All addons
    $self->render(
        all_addons       => $self->addons->uploaded->to_array,
        installed_addons => $self->addons->installed,
    );
}

# TODO: 本番環境ではアプリケーションの再起動が必要
# developモード(シングルプロセス)では反映される

sub enable {
    my $self   = shift;
    my $target = $self->param('target');
    my $addon  = $self->addons->addon($target);

    # stash addons を更新
    # $addon->{is_enabled} = 1;
    $addon->is_enabled(1);

    # TODO: dbの更新処理

    # hook routes有効化
    $self->app->addons->to_enable($addon);

    $self->redirect_to('/admin/addons');
}

sub disable {
    my $self   = shift;
    my $target = $self->param('target');
    my $addon  = $self->addons->addon($target);

    # stash addons を更新
    $addon->is_enabled(0);

    # TODO: dbの更新処理

    # hook routes無効化
    $self->app->addons->to_disable($addon);

    $self->redirect_to('/admin/addons');
}

1;
