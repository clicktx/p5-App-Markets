package Markets::Web;
use Mojo::Base 'Markets::Core';
use Markets::Util qw(directories);
use constant { ADDON_NAMESPACE => 'Markets::Addon', };

# This method will run once at server start
sub startup {
    my $self = shift;
    $self->initialize_app;

    # templets paths
    $self->renderer->paths( [ 'themes/default', 'themes/admin' ] );
    my $themes = directories( 'themes', { ignore => [ 'default', 'admin' ] } );
    say $self->dumper($themes);    # debug

    # unshift @{$self->renderer->paths}, 'themes/mytheme';

    # renderer
    $self->plugin('Markets::Plugin::EPRenderer');
    $self->plugin('Markets::Plugin::EPLRenderer');
    $self->plugin('Markets::Plugin::DOM');

    # Routes
    $self->plugin('Markets::Admin::DispatchRoutes');
    $self->plugin('Markets::Web::DispatchRoutes');

    # Loadin Addons
    # [WIP] addon config
    my $addons_setting_from_db = [
        {
            name       => 'MyAddon',
            is_enabled => 1,
            hooks      => {
                before_compile_template => 300,
                before_xxx_action       => 500,
            },
        },

        # DBで is_enabled=false を除く事も出来るが...
        {
            name       => 'MyDisableAddon',
            is_enabled => 0,
        },
    ];
    $self->config( addons => $addons_setting_from_db );

    # regist enable addons
    my $addons = $self->config->{addons};
    my @enabled = grep { $_->{is_enabled} } @$addons;
    foreach my $addon (@enabled) {
        my $addon_name = $addon->{name};
        my $hooks = $addon->{hooks} || {};
        $self->plugin( ADDON_NAMESPACE . '::' . $addon_name => $hooks );
    }
}

1;
