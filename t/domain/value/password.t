use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Value::Password';
use_ok $pkg;

subtest 'basic' => sub {
    my $p = $pkg->new( value => '' );
    isa_ok $p, 'Yetie::Domain::Value';
};

subtest 'is_verify' => sub {

    # Password: 12345678
    my $p =
      $pkg->new( value =>
          'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4='
      );
    ok !$p->is_verify('123'), 'right unverified';
    ok $p->is_verify('12345678'), 'right verified';
};

done_testing();
