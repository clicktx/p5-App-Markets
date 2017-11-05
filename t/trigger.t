use Mojo::Base -strict;

use Test::More;
use Yetie::Trigger;

# priority
my $e = Yetie::Trigger->new;

my $custom;
my $cb = sub { $custom += shift };
$e->on(
    {
        name     => 'test1',
        cb       => $cb,
        priority => 400,
    }
);
$e->on(
    {
        name     => 'test1',
        cb       => $cb,
        priority => 200,
    }
);
$e->on(
    {
        name     => 'test1',
        cb       => $cb,
        priority => 1000,
    }
);
$e->on(
    {
        name     => 'test1',
        cb       => $cb,
        priority => 400,
    }
);

my @priority;
foreach my $event ( @{ $e->{events}{test1} } ) {
    push @priority, $event->{priority};
}
is_deeply \@priority, [ 200, 400, 400, 1000 ], 'right priority';

$e->on(
    {
        name     => 'test2',
        cb       => $cb,
    }
);
$e->emit( test2 => 1 );
is $custom, 1, 'trigger has been emited';

$e->emit( test1 => 1 );
is $custom, 5, 'trigger has been emited';

done_testing();
