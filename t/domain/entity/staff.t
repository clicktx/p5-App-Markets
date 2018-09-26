use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

use_ok 'Yetie::Domain::Entity::Staff';
my $pkg = 'Yetie::Domain::Entity::Staff';

subtest 'basic' => sub {
    my $staff = $pkg->new( id => 1 );
    isa_ok $staff, 'Yetie::Domain::Entity';

    is $staff->id, 1, 'right staff ID';
    isa_ok $staff->password, 'Yetie::Domain::Value::Password';

    can_ok $staff, 'login_id';
    can_ok $staff, 'created_at';
    can_ok $staff, 'updated_at';
};

subtest 'is_staff' => sub {
    my $staff = $pkg->new();
    ok !$staff->is_staff;
    $staff = $pkg->new( id => 1 );
    ok $staff->is_staff;
};

done_testing();
