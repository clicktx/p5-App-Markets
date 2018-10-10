package Yetie::App::Common;
use Mojo::Base 'Mojolicious';
use Mojo::Log;
use Yetie::Addons;
use DBIx::QueryLog;

# $ENV{DBIX_QUERYLOG_EXPLAIN} = 1;
$ENV{DBIC_TRACE}            = 1;
$ENV{DBIX_QUERYLOG_COMPACT} = 1;
$ENV{DBIX_QUERYLOG_USEQQ}   = 1;

has addons => sub { Yetie::Addons->new(@_) };
has region => 'us';

# has restart_app => sub { system shift->home . "/script/appctl --restart" };
has restart_app => sub { system "touch " . __FILE__ };    # 本番用に変更する
has schema => sub {
    my $self = shift;

    # DBIC NestedSet
    _dbic_nestedset();

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
    _load_plugins($self);

    # Preferences
    $self->service('preference')->load;

    # Set default language
    $self->language( $self->pref('default_language') );

    # TimeZone
    # my $time_zone = 'Asia/Tokyo';                 # from preference
    # $self->schema->time_zone($time_zone);

    # Add before/after action hook
    # NOTE: Mojoliciou::Controllerの挙動を変更
    _add_hooks($self);
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
}

sub _dbic_nestedset {
    require Yetie::Schema::Result::Category;
    Yetie::Schema::Result::Category->tree_columns(
        {
            root_column  => 'root_id',
            left_column  => 'lft',
            right_column => 'rgt',
            level_column => 'level',
        }
    );
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
    $app->plugin('Yetie::DefaultHelpers');

    # Locale
    $ENV{MOJO_I18N_DEBUG} = 1 if $app->mode eq 'development';
    $app->plugin(
        'Yetie::I18N',
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
    # NOTE: Need after loading "Yetie::I18N"
    $app->plugin('Yetie::Log');

    # Password
    $app->plugin('Scrypt');

    # Session
    $app->plugin( 'Yetie::Session' => { expires_delta => 3600 } );
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

=head1 METHODS

L<Yetie::App::Common> inherits all methods from L<Mojolicious> and implements
the following new ones.

=head2 C<initialize_app>

    $app->initialize_app;

=head1 SEE ALSO

L<Mojolicious>

=cut
