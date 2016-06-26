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

# One-time event
my $once;

# $e->once(one_time => sub { $once++ });
# is scalar @{$e->subscribers('one_time')}, 1, 'one subscriber';
# $e->unsubscribe(one_time => sub { });
# is scalar @{$e->subscribers('one_time')}, 1, 'one subscriber';
# $e->emit('one_time');
# is $once, 1, 'event was emitted once';
# is scalar @{$e->subscribers('one_time')}, 0, 'no subscribers';
# $e->emit('one_time');
# is $once, 1, 'event was not emitted again';
# $e->emit('one_time');
# is $once, 1, 'event was not emitted again';
# $e->emit('one_time');
# is $once, 1, 'event was not emitted again';
# $e->once(
#   one_time => sub {
#     shift->once(one_time => sub { $once++ });
#   }
# );
# $e->emit('one_time');
# is $once, 1, 'event was emitted once';
# $e->emit('one_time');
# is $once, 2, 'event was emitted again';
# $e->emit('one_time');
# is $once, 2, 'event was not emitted again';
# $e->once(one_time => sub { $once = shift->has_subscribers('one_time') });
# $e->emit('one_time');
# ok !$once, 'no subscribers';

# Nested one-time events
# $once = 0;
# $e->once(
#   one_time => sub {
#     shift->once(
#       one_time => sub {
#         shift->once(one_time => sub { $once++ });
#       }
#     );
#   }
# );
# is scalar @{$e->subscribers('one_time')}, 1, 'one subscriber';
# $e->emit('one_time');
# is $once, 0, 'only first event was emitted';
# is scalar @{$e->subscribers('one_time')}, 1, 'one subscriber';
# $e->emit('one_time');
# is $once, 0, 'only second event was emitted';
# is scalar @{$e->subscribers('one_time')}, 1, 'one subscriber';
# $e->emit('one_time');
# is $once, 1, 'third event was emitted';
# is scalar @{$e->subscribers('one_time')}, 0, 'no subscribers';
# $e->emit('one_time');
# is $once, 1, 'event was not emitted again';
# $e->emit('one_time');
# is $once, 1, 'event was not emitted again';
# $e->emit('one_time');
# is $once, 1, 'event was not emitted again';

# One-time event used directly
$e = Mojo::EventEmitter->new;
ok !$e->has_subscribers('foo'), 'no subscribers';
$once = 0;
my $cb = $e->once( foo => sub { $once++ } );
ok $e->has_subscribers('foo'), 'has subscribers';
$cb->();
is $once, 1, 'event was emitted once';
ok !$e->has_subscribers('foo'), 'no subscribers';

# Unsubscribe
$e = Mojo::EventEmitter->new;
my $counter;
$cb = $e->on( foo => sub { $counter++ } );
$e->on( foo => sub { $counter++ } );
$e->on( foo => sub { $counter++ } );
$e->unsubscribe( foo => $e->once( foo => sub { $counter++ } ) );
is scalar @{ $e->subscribers('foo') }, 3, 'three subscribers';
$e->emit('foo')->unsubscribe( foo => $cb );
is $counter, 3, 'event was emitted three times';
is scalar @{ $e->subscribers('foo') }, 2, 'two subscribers';
$e->emit('foo');
is $counter, 5, 'event was emitted two times';
ok $e->has_subscribers('foo'), 'has subscribers';
ok !$e->unsubscribe('foo')->has_subscribers('foo'), 'no subscribers';
is scalar @{ $e->subscribers('foo') }, 0, 'no subscribers';
$e->emit('foo');
is $counter, 5, 'event was not emitted again';

# Manipulate events
$e = Mojo::EventEmitter->new;
my $buffer = '';
push @{ $e->subscribers('foo') }, sub { $buffer .= 'one' };
push @{ $e->subscribers('foo') }, sub { $buffer .= 'two' };
push @{ $e->subscribers('foo') }, sub { $buffer .= 'three' };
$e->emit('foo');
is $buffer, 'onetwothree', 'right result';
@{ $e->subscribers('foo') } = reverse @{ $e->subscribers('foo') };
$e->emit('foo');
is $buffer, 'onetwothreethreetwoone', 'right result';

# Pass by reference and assignment to $_
$e      = Mojo::EventEmitter->new;
$buffer = '';
$e->on( one => sub { $_ = $_[1] .= 'abc' . $_[2] } );
$e->on( one => sub { $_[1] .= '123' . pop } );
is $buffer, '', 'no result';
$e->emit( one => $buffer => 'two' );
is $buffer, 'abctwo123two', 'right result';
$e->once( one => sub { $_[1] .= 'def' } );
$e->emit( one => $buffer => 'three' );
is $buffer, 'abctwo123twoabcthree123threedef', 'right result';
$e->emit( one => $buffer => 'x' );
is $buffer, 'abctwo123twoabcthree123threedefabcx123x', 'right result';

done_testing();
