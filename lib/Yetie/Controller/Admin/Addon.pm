package Yetie::Controller::Admin::Addon;
use Mojo::Base 'Yetie::Controller::Admin';
use Data::Dumper;

# This action will render a template
sub index {
    my $c = shift;

    # All addons
    $c->render(
        uploaded_addons  => $c->addons->uploaded,
        all_addons       => $c->addons->uploaded->to_array,
        installed_addons => $c->addons->installed,
    );
}

# TODO: 本番環境ではアプリケーションの再起動が必要
# developモード(シングルプロセス)では反映される

sub enable {
    my $c      = shift;
    my $target = $c->param('target');
    my $addon  = $c->addons->addon($target);

    # TODO: dbの更新処理
    # $addon->is_enabled(1); はAddons::to_enableで行う
    # $c->app->restart_app;

    # trigger routes有効化
    $c->app->addons->to_enable($addon);

    $c->redirect_to('rn.admin.settings.addon');
}

sub disable {
    my $c      = shift;
    my $target = $c->param('target');
    my $addon  = $c->addons->addon($target);

    # TODO: dbの更新処理
    # $addon->is_enabled(0); はAddons::to_disableで行う
    # $c->app->restart_app;

    # trigger routes無効化
    $c->app->addons->to_disable($addon);

    $c->redirect_to('rn.admin.settings.addon');
}

1;
