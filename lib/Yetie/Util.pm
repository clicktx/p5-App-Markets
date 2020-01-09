package Yetie::Util;
use Mojo::Base -strict;

use Carp qw(croak);
use Exporter 'import';
use File::Find::Rule;
use Hashids;
use List::Util qw/reduce/;
use Mojo::Loader;
use Session::Token;

our @EXPORT_OK = (
    qw/args2array args2hash array_to_hash
      directories create_token load_class uuid/
);

=head1 FUNCTIONS

L<Yetie::Util> implements the following functions, which can be imported
individually.

=head2 C<args2array>

    use Yetie::Util qw/args2array/;
    sub foo{
        my $self = shift;

        # array
        my @args = args2array(@_);

        # array reference
        my $args = args2array(@_);
    }

    # Arguments array or array reference
    foo( 'foo', 'bar', 'baz' );
    foo( ['foo', 'bar', 'baz'] );

    # Bad argumnts
    foo( \@array, 'foo', 'bar', ... );

Convert arguments.

Arguments C<Array> or C<Array reference>.

Return C<Array> or C<Array reference>.
=cut

sub args2array {
    my $args = ref $_[0] ne 'ARRAY' ? +[@_] : shift || [];
    return wantarray ? @{$args} : $args;
}

=head2 C<args2hash>

    use Yetie::Util qw/args2hash/;
    sub foo{
        my $self = shift;

        # hash
        my %args = args2hash(@_);

        # hash reference
        my $args = args2hash(@_);
    }

    # Arguments hash or hash reference
    foo( foo => 1, bar => 2, baz => 3 );
    foo( {foo => 1, bar => 2, baz => 3} );

Convert arguments.

Arguments C<Hash> or C<Hash reference>.

Return C<Hash> or C<Hash reference>.
=cut

sub args2hash {
    my $args = @_ > 1 ? +{@_} : shift || {};
    return wantarray ? %{$args} : $args;
}

=head2 C<array_to_hash>

    # { 0 => 'a', 1 => 'b', 2 => 'c' }
    my %hash = array_to_hash( 'a', 'b', 'c' );
    my %hash = array_to_hash( [ 'a', 'b', 'c' ] );
    my $hash = array_to_hash( 'a', 'b', 'c' );
    my $hash = array_to_hash( [ 'a', 'b', 'c' ] );

Convert array to hash.

Return C<Hash> or C<Hash reference>.

=cut

sub array_to_hash {
    my @array = @_ > 1 ? @_ : ref $_[0] eq 'ARRAY' ? @{ $_[0] } : @_;

    my $hashref = {};
    reduce { $hashref->{$a} = $b; ++$a } 0, @array;
    return wantarray ? %{$hashref} : $hashref;
}

=head2 C<directories>

List all subdirectories in the directory.

B<options>

ignore - ignore directory name.

    use Yetie::Util qw(directories);

    $sub_directories = directories('hoge', { ignore => ['huga'] });
    @sub_directories = directories('hoge', { ignore => ['huga'] });

=cut

sub directories {
    my ( $dir, $options ) = ( shift, shift // {} );
    my @sub_directories;
    my $ignore_dir = $options->{ignore} // '';

    my $rule = File::Find::Rule->new;
    if ($ignore_dir) {    # Hack the `Use of uninitialized value $regex in regexp compilation at Text/Glob.pm`
        $rule->not( File::Find::Rule->name($ignore_dir) );
    }
    $rule->maxdepth(1)->directory->start($dir);

    while ( my $sub_dir = $rule->match ) {
        $sub_dir =~ s/$dir\/?//;
        push @sub_directories, $sub_dir if $sub_dir;
    }
    return wantarray ? @sub_directories : \@sub_directories;
}

=head2 C<create_token>

Generate secure token. based L<Session::Token>

    use Yetie::Util qw(create_token);
    my $token = create_token( { length => 30 } );
    # -> ZVZdkwIfNrvsk9N8f3jB0zBZ12kePJ

B<options>

    # Defaults
    create_token(
        length => 40,
        alphabet => [ 'a' .. 'z', '0' .. '9' ],
    );

SEE ALSO L<Session::Token>

=cut

sub create_token {
    my @args = @_;
    return Session::Token->new(@_)->get if @args;

    # Default
    return Session::Token->new(
        length   => 40,
        alphabet => [ 'a' .. 'z', '0' .. '9' ],
    )->get;
}

=head2 C<hashids>

Generate short unique ids.

    use Yetie::Util qw(hashids);
    my $hashids = hashids($salt);

    my $hash = $hashids->encode(123);

    # 123
    my $int  = $hashids->decode($hash);

SEE ALSO L<Hashids>

=cut

sub hashids {
    my $salt = Mojo::Util::md5( shift // '' );
    return Hashids->new(
        salt          => $salt,
        alphabet      => 'ABCDEFGHJKLMNQRSTWXYZ123456789',
        minHashLength => 6
    );
}

=head2 C<load_class>

Load a class.

    use Yetie::Util qw(load_class);

    load_class 'Foo::Bar';

SEE ALSO L<Mojo::Loader/load_class>

=cut

sub load_class {
    my $class = shift;

    if ( my $e = Mojo::Loader::load_class($class) ) {
        croak ref $e ? "Exception: $e" : "$class not found!";
    }
    1;
}

=head2 C<uuid>

Create UUID version 4 token.

    use Yetie::Util qw(uuid);
    my $token = uuid();

SEE ALSO L<Session::Token/TOKEN-TEMPLATES>

=cut

sub uuid {
    my $t = _token_template(
        x => [ 0 .. 9, 'a' .. 'f' ],
        y => [ 8, 9, 'a', 'b' ],
    );

    my $uuid = $t->('xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx');
    return uc $uuid;
}

sub _token_template {
    my (%m) = @_;

    %m = map { $_ => Session::Token->new( alphabet => $m{$_}, length => 1 ) } keys %m;

    return sub {
        my $v = shift;
        $v =~ s/(.)/exists $m{$1} ? $m{$1}->get : $1/eg;
        return $v;
    };
}

1;
