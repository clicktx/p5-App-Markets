package Markets::Controller::Admin::Addons;
use Mojo::Base 'Markets::Controller::Admin';
use Data::Dumper;

# This action will render a template
sub index {
    my $self = shift;

    # All addons
    $self->render(
        uploaded_addons  => $self->addons->uploaded,
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

    # TODO: dbの更新処理
    # $addon->is_enabled(1); はAddons::to_enableで行う
    # $self->app->restart_app;

    # hook routes有効化
    $self->app->addons->to_enable($addon);

    $self->redirect_to('RN_admin_settings_addons');
}

sub disable {
    my $self   = shift;
    my $target = $self->param('target');
    my $addon  = $self->addons->addon($target);

    # TODO: dbの更新処理
    # $addon->is_enabled(0); はAddons::to_disableで行う
    # $self->app->restart_app;

    # hook routes無効化
    $self->app->addons->to_disable($addon);

    $self->redirect_to('RN_admin_settings_addons');
}

1;
