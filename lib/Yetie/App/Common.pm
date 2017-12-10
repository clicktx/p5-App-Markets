package Yetie::App::Common;
use Mojo::Base 'Mojolicious';
use Mojo::Log;
use Yetie::Addons;
use Scalar::Util qw/weaken/;
use DBIx::QueryLog;

$ENV{DBIC_TRACE}            = 1;
$ENV{DBIX_QUERYLOG_COMPACT} = 1;
$ENV{DBIX_QUERYLOG_USEQQ}   = 1;

# $ENV{DBIX_QUERYLOG_EXPLAIN} = 1;

has schema => sub {
    my $self = shift;

    say "+++++ DBIC +++++";    # debug
    my $schema_class = "Yetie::Schema";
    eval "require $schema_class" or die "Could not load Schema Class ($schema_class). $@\n";

    say "      connecting db.";    # debug
    my $conf   = $self->config('db') or die "Missing configuration for db";
    my $dsn    = _dsn($conf);
    my $schema = $schema_class->connect( $dsn, $conf->{user}, $conf->{password} )
      or die "Could not connect to $schema_class using DSN ";

    $schema->{app} = $self;
    weaken $schema->{app};
    return $schema;
};

# has restart_app => sub { system shift->home . "/script/appctl --restart" };
has restart_app => sub { system "touch " . __FILE__ };    # 本番用に変更する
has addons      => sub { Yetie::Addons->new(@_) };

# logging
has error_log    => sub { shift->_log('error') };
has db_log       => sub { shift->_log('db') };
has admin_log    => sub { shift->_log('admin') };
has customer_log => sub { shift->_log('customer') };

sub initialize_app {
    my $self = shift;
    my $home = $self->home;
    my $mode = $self->mode;

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer') if $mode eq 'development';

    # SQL debug log
    # DBIx::QueryLog->threshold(0.1); # sec
    $DBIx::QueryLog::OUTPUT = sub {
        my %param = @_;
        $self->db_log->debug("[$param{time}] $param{sql}");
    };

    # change log dir
    $self->log->path( $home->rel_file("var/log/$mode.log") )
      if -d $home->rel_file('var/log') && -w _;

    my $config_path = $home->rel_file("config/$mode.conf");
    $self->plugin( Config => { file => $config_path } );

    # DBIC NestedSet
    _dbic_nestedset();

    # Load plugin
    _load_plugin($self);

    # Preferences
    $self->service('preference')->load;

    # TimeZone
    # my $time_zone = 'Asia/Tokyo';                 # from preference
    # $self->schema->time_zone($time_zone);

    # default cookie
    $self->sessions->cookie_name('session');
    $self->secrets( ['aaabbbccc'] );    #           change this!

    # locale
    $ENV{MOJO_I18N_DEBUG} = 1 if $mode eq 'development';
    $self->plugin(
        'Yetie::I18N',
        {
            # file_type => 'po',    # or 'mo'. default: po
            default   => $self->pref('default_language'),
            languages => [qw( en ja de )],

            # Mojolicious::Plugin::I18N like options
            no_header_detect  => 1,                   # option. default: false
            support_url_langs => [qw( en ja de )],    # option
        }
    );

    # loading lexicon files
    my $locale_dir = Mojo::File::path( $home, 'share', 'locale' );
    $self->lexicon(
        {
            search_dirs => [$locale_dir],

            # gettext_to_maketext => $boolean,                    # option
            # decode              => $boolean,                    # option
            data => [ '*::' => '*.po' ],
        }
    ) if -d $locale_dir;

    # Form Frameworks
    # $self->plugin( 'Yetie::Form', methods => { valid => 'form_valid', errors => 'form_errors' } );
    # $self->plugin('Yetie::FormExpand');
    $self->plugin('Yetie::Form');

    # Add before/after action hook
    # MEMO: Mojoliciou::Controllerの挙動を変更
    _add_hooks($self);
}

sub log {
    my $app = shift;

    # Check if we have a log directory that is writable
    my $log      = Mojo::Log->new;
    my $home     = $app->home;
    my $mode     = $app->mode;
    my $log_name = shift // $mode;
    $log->path( $home->child( 'var', 'log', "$log_name.log" ) )
      if -d $home->child( 'var', 'log' ) && -w _;

    # Reduced log output outside of development mode
    return $mode eq 'development' ? $log : $log->level('info');
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

sub _load_plugin {
    my $app = shift;

    # Models
    $app->plugin( Model => { namespaces => ['Yetie::Model'] } );

    # Default Helpers
    $app->plugin('Yetie::DefaultHelpers');

    # password
    $app->plugin('Scrypt');

    # session
    $app->plugin( 'Yetie::Session' => { expires_delta => 3600 } );
}

sub _log {
    my $app      = shift;
    my $log_name = shift . ".log";

    # Check if we have a log directory that is writable
    my $log  = Mojo::Log->new;
    my $home = $app->home;
    my $mode = $app->mode;
    $log->path( $home->child( 'var', 'log', $log_name ) )
      if -d $home->child( 'var', 'log' ) && -w _;

    # Reduced log output outside of development mode
    return $mode eq 'development' ? $log : $log->level('info');
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

=head2 C<log>

    # into default log
    $app->log->debug('message');

    # change log file var/log/foo.log
    $app->log('foo')->debug('message');

See L<Mojolicious/log>, L<Mojo::Log>

=head1 SEE ALSO

L<Mojolicious>

=cut
