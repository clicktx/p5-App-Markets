package Yetie::Log::Logger;
use Mojo::Base 'Mojo::Log';
use Role::Tiny::With;

with 'Mojo::Log::Role::Clearable';

has 'app';

sub debug { shift->_convert_message( debug => @_ ) }
sub error { shift->_convert_message( error => @_ ) }
sub fatal { shift->_convert_message( fatal => @_ ) }
sub info  { shift->_convert_message( info  => @_ ) }
sub warn  { shift->_convert_message( warn  => @_ ) }

sub _convert_message {
    my ( $self, $level ) = ( shift, shift );
    my $message = $self->app->__x(@_);
    $self->_log( $level, $message );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Log::Logger

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Log::Logger> inherits all attributes from L<Mojo::Log> and implements the following new ones.

=head1 METHODS

L<Yetie::Log::Logger> inherits all methods from L<Mojo::Log> and implements the following new ones.

=head2 C<debug>

    $logger->debug( $msgid, %context | \%context );

Emit "message" event and log debug message.

=head2 C<info>

    $logger->info( $msgid, %context | \%context );

Emit "message" event and log info message.

=head2 C<warn>

    $logger->warn( $msgid, %context | \%context );

Emit "message" event and log warn message.

=head2 C<error>

    $logger->error( $msgid, %context | \%context );

Emit "message" event and log error message.

=head2 C<fatal>

    $logger->fatal( $msgid, %context | \%context );

Emit "message" event and log fatal message.

=head2 C<path>



=head1 SEE ALSO

L<Yetie::Log>, L<Mojo::Log>

=cut
