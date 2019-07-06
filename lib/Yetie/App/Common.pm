package Yetie::App::Common;
use Mojo::Base 'Mojolicious';
use Mojo::Log;
use Yetie::Addon::Handler;
use Yetie::App::Core::DateTime;
use DBIx::QueryLog;

# $ENV{DBIX_QUERYLOG_EXPLAIN} = 1;
$ENV{DBIC_DT_SEARCH_OK}     = 1;
$ENV{DBIC_TRACE}            = 1;
$ENV{DBIX_QUERYLOG_COMPACT} = 1;
$ENV{DBIX_QUERYLOG_USEQQ}   = 1;

has addons    => sub { Yetie::Addon::Handler->new(@_) };
has date_time => sub { Yetie::App::Core::DateTime->new(@_) };
has region    => 'us';

# has restart_app => sub { system shift->home . "/script/appctl --restart" };
has restart_app => sub { system "touch " . __FILE__ };    # 本番用に変更する
has schema => sub {
    my $self = shift;

    say "+++++ DBIC +++++";                               # debug
    my $schema_class = "Yetie::Schema";
    eval "require $schema_class" or die "Could not load Schema Class ($schema_class). $@\n";    ## no critic

    my $conf   = $self->config('db') or die "Missing configuration for db";
    my $dsn    = _dsn($conf);
    my $schema = $schema_class->connect( $dsn, $conf->{user}, $conf->{password} );
    eval { say 'connected to DB' if $schema->storage->dbh };
    do {
        my $message = "Could not connect to $schema_class using DSN ";
        $self->log->fatal($message) and die $message;
    } if $@;
    $schema->{app} = $self;
    return $schema;
};

sub initialize_app {
    my $self = shift;
    my $home = $self->home;
    my $mode = $self->mode;

    # Change default log directory
    $self->log->path( $home->child( 'var', 'log', "$mode.log" ) )
      if -d $home->child( 'var', 'log' ) && -w _;

    # SQL debug log
    # DBIx::QueryLog->threshold(0.1); # sec
    $DBIx::QueryLog::OUTPUT = sub {
        my %param = @_;
        $self->logging('db')->debug( 'log.message', message => "[$param{time}] $param{sql}" );
    };

    # Load config
    my $config_path = $home->child( "config", "$mode.conf" );
    $self->plugin( config => { file => $config_path } );

    # default cookie
    $self->sessions->cookie_name('session');
    $self->secrets( $self->config('secrets') );

    # Load plugins
    $self->_load_plugins;

    # Preferences
    $self->service('preference')->load;

    # Set default language
    $self->language( $self->pref('default_language') );

    # Server Session
    $self->plugin(
        'Yetie::App::Core::Session' => {
            expires_delta        => $self->pref('server_session_expires_delta'),
            cookie_expires_delta => $self->pref('server_session_cookie_expires_delta'),
            httponly             => 1,

            # secure => 1 if pref->https_only
        }
    );

    # TimeZone
    # my $time_zone = 'Asia/Tokyo';                 # from preference
    # $self->date_time->time_zone($time_zone);

    # Add before/after action hook
    # NOTE: Mojoliciou::Controllerの挙動を変更
    $self->_add_hooks;

    return $self;
}

sub _add_hooks {
    my $app = shift;
    $app->hook(
        around_action => sub {
            my ( $next, $c, $action, $last ) = @_;
            return $next->() unless $last;

            if ( $c->can('process') ) { $c->process($action) }
            else {
                $c->app->log->warn('Controller class shoud inheritance of "Yetie::Controller".');
                $c->$action;
            }
        }
    );

    $app->hook(
        before_routes => sub {
            my $c = shift;

            # Emit filter hook (ignore static files)
            say "hook! before_routes";    # debug
            say "... This route is dynamic" unless ( $c->stash('mojo.static') );
            $c->app->addons->emit_trigger( filter_form => $c )
              unless $c->stash('mojo.static');
        }
    );

    return $app;
}

sub _dsn {
    my $conf = shift;

    return $ENV{TEST_MYSQL}
      ? $ENV{TEST_MYSQL}
      : "DBI:$conf->{dbtype}:dbname=$conf->{dbname};host=$conf->{host};port=$conf->{port};";
}

sub _load_plugins {
    my $app = shift;

    # Documentation browser under "/perldoc"
    $app->plugin('PODRenderer') if $app->mode eq 'development';

    # Default Helpers
    $app->plugin('Yetie::App::Core::DefaultHelpers');

    # Locale
    $ENV{MOJO_I18N_DEBUG} = 1 if $app->mode eq 'development';
    $app->plugin(
        'Yetie::App::Core::I18N',
        {
            # file_type => 'po',    # or 'mo'. default: po
            # default   => $self->pref('default_language'),
            languages => [qw( en ja de )],

            # Mojolicious::Plugin::I18N like options
            no_header_detect  => 1,                   # option. default: false
            support_url_langs => [qw( en ja de )],    # option
        }
    );

    # Logging
    # NOTE: Need after loading "Yetie::App::Core::I18N"
    $app->plugin('Yetie::App::Core::Log');

    # Password
    $app->plugin('Scrypt');

    return $app;
}

1;

=encoding utf8

=head1 NAME

Yetie::App::Common

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::App::Common> inherits all attributes from L<Mojolicious> and implements the
following new ones.

=head2 C<addons>

    my $addons = $app->addons;

Return L<Yetie::Addon::Handler> object.

=head2 C<date_time>

    my $date_time = $app->date_time;

Return L<Yetie::App::Core::DateTime> object.

=head2 C<region>

    my $region = $app->region;

Default: us

=head2 C<restart_app>

    $app->restart_app;

=head2 C<schema>

    my $schema = $app->schema;

L<Yetie::Schema> object.

=head1 METHODS

L<Yetie::App::Common> inherits all methods from L<Mojolicious> and implements
the following new ones.

=head2 C<initialize_app>

    $app->initialize_app;

=head1 SEE ALSO

L<Mojolicious>

=cut
