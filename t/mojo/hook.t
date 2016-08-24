use Mojo::Base -strict;

use Test::More;
use Markets::EventEmitter;
use Markets::Addons;

# Normal event
my $e = Markets::EventEmitter->new;
my $called;
$e->on(
    test1 => {
        cb => sub { $called++ }
    }
);
$e->emit('test1');
is $called, 1, 'event was emitted once';

# Error
$e->on(
    die => {
        cb => sub { die "works!\n" }
    }
);
eval { $e->emit('die') };
is $@, "works!\n", 'right error';

# Unhandled error event
eval { $e->emit( error => 'works' ) };
like $@, qr/^Markets::EventEmitter: works/, 'right error';

# Catch
my $err;
ok !$e->has_subscribers('foo'), 'no subscribers';
$e->catch( sub { $err = pop } );
ok $e->has_subscribers('error'), 'has subscribers';
$e->emit( error => 'just works!' );
is $err, 'just works!', 'right error';

# Exception in error event
$e->on(
    error => {
        cb => sub { die "$_[0]entional" }
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
    foo => {
        cb => sub { $counter++ }
    }
);
$e->on(
    foo => {
        cb => sub { $counter++ }
    }
);
$e->on(
    foo => {
        cb => sub { $counter++ }
    }
);
$e->unsubscribe(
    foo => $e->on(
        foo => {
            cb => sub { $counter++ }
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

# filter priority
$e = Markets::Addons::Filter->new;
$e->add_filter(
    test1 => {
        cb => sub { $called++ }
    },
    { priority => 200 }
);
$e->add_filter(
    test1 => {
        cb => sub { $called++ }
    },
    { priority => 1000 }
);
$e->add_filter(
    test1 => {
        cb => sub { $called++ }
    },
    { priority => 400 }
);
my @priority;
foreach my $event ( @{ $e->{events}{test1} } ) {
    push @priority, $event->{priority};
}
is_deeply \@priority, [ 200, 400, 1000 ], 'add_filter priority';

# action priority
$e = Markets::Addons::Action->new;
$e->add_action(
    test1 => {
        cb => sub { $called++ }
    },
    { priority => 200 }
);
$e->add_action(
    test1 => {
        cb => sub { $called++ }
    },
    { priority => 1000 }
);
$e->add_action(
    test1 => {
        cb => sub { $called++ }
    },
    { priority => 400 }
);

@priority = ();
foreach my $event ( @{ $e->{events}{test1} } ) {
    push @priority, $event->{priority};
}
is_deeply \@priority, [ 200, 400, 1000 ], 'add_action priority';

done_testing();
