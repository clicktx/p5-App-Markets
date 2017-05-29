use Mojo::Base -strict;

use Test::More;
use Markets::EventEmitter;

# Normal event
my $e = Markets::EventEmitter->new;
my $called = 0;
$e->on(
    {
        name => 'test1',
        cb   => sub { $called++ },
    }
);
$e->emit('test1');
is $called, 1, 'event was emitted once';

# Error
$e->on(
    {
        name => 'die',
        cb   => sub { die "works!\n" },
    }
);
eval { $e->emit('die') };
is $@, "works!\n", 'right error';

# Unhandled error event
eval { $e->emit( error => 'works' ) };
like $@, qr/^Markets::EventEmitter: works/, 'right error';

# has_subscribers
ok !$e->has_subscribers('foo'), 'no subscribers';

# Catch
my $err;
$e->catch( sub { $err = pop } );
ok $e->has_subscribers('error'), 'has subscribers';
$e->emit( error => 'just works!' );
is $err, 'just works!', 'right error';

# Exception in error event
$e->on(
    {
        name => 'error',
        cb   => sub { die "$_[0]entional" },
    }
);
eval { $e->emit( error => 'int' ) };
like $@, qr/^intentional/, 'right error';

# Normal event again
$e->emit('test1');
is $called, 2, 'event was emitted twice';
is scalar @{ $e->subscribers('test1') }, 1, 'one subscriber';
$e->emit('test1');
$e->unsubscribe( test1 => $e->subscribers('test1')->[0] );
is $called, 3, 'event was emitted three times';
is scalar @{ $e->subscribers('test1') }, 0, 'no subscribers';
$e->emit('test1');
is $called, 3, 'event was not emitted again';
$e->emit('test1');
is $called, 3, 'event was not emitted again';

# One-time event
# not support
eval {
    $e->once( error => sub { die "$_[1]entional" } );
};
like $@, qr/not support/, 'once, not support';

# Unsubscribe
$e = Markets::EventEmitter->new;
my $counter;
my $event = $e->on(
    {
        name => 'foo',
        cb   => sub { $counter++ }
    }
);
$e->on(
    {
        name => 'foo',
        cb   => sub { $counter++ }
    }
);
$e->on(
    {
        name => 'foo',
        cb   => sub { $counter++ }
    }
);
$e->unsubscribe(
    foo => $e->on(
        {
            name => 'foo',
            cb   => sub { $counter++ }
        }
    )
);

is scalar @{ $e->subscribers('foo') }, 3, 'three subscribers';
$e->emit('foo')->unsubscribe( foo => $event );
is $counter, 3, 'event was emitted three times';
is scalar @{ $e->subscribers('foo') }, 2, 'two subscribers';
$e->emit('foo');
is $counter, 5, 'event was emitted two times';
ok $e->has_subscribers('foo'), 'has subscribers';
ok !$e->unsubscribe('foo')->has_subscribers('foo'), 'no subscribers';
is scalar @{ $e->subscribers('foo') }, 0, 'no subscribers';
$e->emit('foo');
is $counter, 5, 'event was not emitted again';

done_testing();
