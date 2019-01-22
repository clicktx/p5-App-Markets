package Yetie::App::Core::Log;
use Mojo::Base 'Mojolicious::Plugin';
use Yetie::App::Core::Log::Logger;

sub register {
    my ( $self, $app ) = @_;

    # Signal warn
    $SIG{'__WARN__'} = sub { my $err = shift; warn $err; chomp $err; $app->log->warn($err); };

    # Create log directory
    my $log_dir = $app->home->child( "var", "log" );
    $log_dir->make_path unless -d $log_dir && -w _;

    # Add attributes
    my $mode = $app->mode;
    $app->attr(
        logger => sub {
            my $self = shift;
            my $logger = Yetie::App::Core::Log::Logger->new( app => $app );

            # Reduced log output outside of development mode
            return $mode eq 'development' ? $logger : $logger->level('info');
        }
    );

    # Add helpers
    $app->helper(
        logging => sub {
            my ( $c, $log_name ) = @_;

            ($log_name) = $c->stash('controller') =~ /^(.+?)-(.+)$/ if $c->stash('controller') and !$log_name;
            $log_name = $app->mode unless $log_name;
            my $log_path = $app->home->child( "var", "log", "$log_name.log" )->to_string;

            my $logger = $app->logger;
            $logger->path($log_path);
        }
    );

    do {
        my $level = $_;
        $app->helper( "logging_$level" => sub { _logging( $level, @_ ) } );
      }
      for qw(debug info warn error fatal);
}

sub _logging {
    my ( $level, $c ) = ( shift, shift );
    my @args = @_;

    # For admin
    push @args, ( staff_id => $c->server_session->staff_id ) if $c->logging->path =~ /admin\.log$/;

    # Other than debugging
    push @args, ( request_ip_address => $c->request_ip_address ) if $level ne 'debug';

    return $c->logging->$level(@args);
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::App::Core::Log

=head1 SYNOPSIS

    # Mojolicious
    $app->plugin('Yetie::App::Core::I18N');    # dependence
    $app->plugin('Yetie::App::Core::Log');

    # Mojolicious::Lite
    plugin 'Yetie::App::Core::I18N';    # dependence
    plugin 'Yetie::App::Core::Log';

    # In controller
    $c->logging_warn( $msgid, %context );
    $c->logging('error')->error( $msgid, %context );

=head1 DESCRIPTION

=head1 ATTRIBUTES for APPLICATION

L<Yetie::App::Core::Log> implements the following attributes for application.

=head2 C<logger>

    my $logger = $app->logger;

Return L<Yetie::App::Core::Log::Logger> object.

=head1 HELPERS

L<Yetie::App::Core::Log> implements the following helpers.

NOTE: If the log file path contains C<"admin.log">, add C<"staff_id"> as an argument.

=head2 C<logging>

    # Emit log message at $app_home/var/log/$log_name.log
    $c->logging($log_name)->info( $msgid, %context );

    # Log file path is controller prefix
    # e.g. controller => 'admin-dashboard'
    # $app_home/var/log/admin.log
    $c->logging->info( $msgid, %context );

Log level see L<Yetie::App::Core::Log::Logger>.

=head2 C<logging_debug>

    $c->logging_debug( $message, %context | \%context );

    # Longer version
    $c->logging->debug(...);

=head2 C<logging_info>

    $c->logging_info( $message, %context | \%context );

    # Longer version
    $c->logging->info(...);

=head2 C<logging_warn>

    $c->logging_warn( $message, %context | \%context );

    # Longer version
    $c->logging->warn(...);

=head2 C<logging_error>

    $c->logging_error( $message, %context | \%context );

    # Longer version
    $c->logging->error(...);

=head2 C<logging_fatal>

    $c->logging_fatal( $message, %context | \%context );

    # Longer version
    $c->logging->fatal(...);

=head1 METHODS

L<Yetie::App::Core::Log> inherits all methods from L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register helpers in L<Mojolicious> application.

=head1 SEE ALSO

L<Yetie::App::Core::Log::Logger>, L<Mojo::Log>, L<Mojolicious::Plugin>

=cut
