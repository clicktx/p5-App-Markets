use Mojo::Base -strict;

use Test::More;
use Markets::Event;

# Normal event
my $e = Markets::Event->new;
my $called;
$e->on(
    test1 => {
        code => sub { $called++ }
    }
);
$e->emit('test1');
is $called, 1, 'event was emitted once';

# Error
$e->on(
    die => {
        code => sub { die "works!\n" }
    }
);
eval { $e->emit('die') };
is $@, "works!\n", 'right error';

# Unhandled error event
eval { $e->emit( error => 'works' ) };
like $@, qr/^Markets::Event: works/, 'right error';

# Catch
my $err;
ok !$e->has_subscribers('foo'), 'no subscribers';
$e->catch( sub { $err = pop } );
ok $e->has_subscribers('error'), 'has subscribers';
$e->emit( error => 'just works!' );
is $err, 'just works!', 'right error';

# Exception in error event
eval {
    $e->once( error => sub { die "$_[1]entional" } );
};
like $@, qr/not support/, 'once, not support';

# Normal event again
eval { $e->unsubscribe( test1 => $e->subscribers('test1')->[0] ) };
like $@, qr/not support/, 'unsubscribe is not support';

# Manipulate events
$e = Markets::Event->new;
my $buffer = '';
eval {
    push @{ $e->subscribers('foo') }, sub { $buffer .= 'one' };
};
like $@, '/Method "subscribers" not support/', 'subscribers, not support';

done_testing();
