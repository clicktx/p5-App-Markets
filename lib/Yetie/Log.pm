package Yetie::Log;
use Mojo::Base 'Mojolicious::Plugin';
use Yetie::Log::Logger;

sub register {
    my ( $self, $app ) = @_;

    # Add attributes
    my $mode = $app->mode;
    $app->attr(
        logger => sub {
            my $self = shift;
            my $logger = Yetie::Log::Logger->new( app => $app );

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
    $c->logging->$level(@_);
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Log

=head1 SYNOPSIS

    # Mojolicious
    $app->plugin('Yetie::I18N');    # dependence
    $app->plugin('Yetie::Log');

    # Mojolicious::Lite
    plugin 'Yetie::I18N';    # dependence
    plugin 'Yetie::Log';

    # In controller
    $c->logging_warn( $msgid, %context );
    $c->logging('error')->error( $msgid, %context );

=head1 DESCRIPTION

=head1 ATTRIBUTES for APPLICATION

L<Yetie::Log> implements the following attributes for application.

=head2 C<logger>

    my $logger = $app->logger;

Return L<Yetie::Log::Logger> object.

=head1 HELPERS

L<Yetie::Log> implements the following helpers.

=head2 C<logging>

    # Emit log message at $app_home/var/log/$log_name.log
    $c->logging($log_name)->info( $msgid, %context );

    # Log file path is controller prefix
    # e.g. controller => 'admin-dashboard'
    # $app_home/var/log/admin.log
    $c->logging->info( $msgid, %context );

Log level see L<Yetie::Log::Logger>.

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

L<Yetie::Log> inherits all methods from L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register helpers in L<Mojolicious> application.

=head1 SEE ALSO

L<Yetie::Log::Logger>, L<Mojo::Log>, L<Mojolicious::Plugin>

=cut
