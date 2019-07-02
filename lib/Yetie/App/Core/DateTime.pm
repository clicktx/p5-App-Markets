package Yetie::App::Core::DateTime;
use Mojo::Base -base;
use DateTime qw();

our $TIME_ZONE = 'UTC';

sub now { return DateTime->now( time_zone => shift->TZ ) }

sub time_zone {
    my ( $self, $arg ) = @_;
    return $arg ? $TIME_ZONE = $arg : $TIME_ZONE;
}

sub today { return shift->now->truncate( to => 'day' ) }

sub TZ { return DateTime::TimeZone->new( name => shift->time_zone ) }

1;

=encoding utf8

=head1 NAME

Yetie::App::Core::DateTime

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::App::Core::DateTime> inherits all attributes.

=head1 METHODS

L<Yetie::App::Core::DateTime> inherits all methods.

=head2 C<now>

    $now = $dt->now;

Return L<DateTime> object.

=head2 C<time_zone>

    # Getter
    my $time_zone = $dt->time_zone;

    # Setter
    $dt->time_zone('Asia/Tokyo');

Get/Set time zone.
Default time zone C<UTC>

=head2 C<today>

    my $today = $dt->today;

Return L<DateTime> object.

=head2 C<TZ>

    my $tz = $dt->TZ;

Return L<DateTime::TimeZone> object.
Using time zone L</time_zone>.

=head1 SEE ALSO

L<DateTime>

=cut
