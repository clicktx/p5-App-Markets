use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Factory;

use_ok 'Yetie::Domain::Entity::Page';

subtest 'basic' => sub {
    my $e = Yetie::Domain::Entity::Page->new();
    isa_ok $e, 'Yetie::Domain::Entity';

    can_ok $e, 'title';
    can_ok $e, 'description';
    can_ok $e, 'keywords';
    can_ok $e, 'robots';
    can_ok $e, 'breadcrumb';
    can_ok $e, 'pager';
    can_ok $e, 'form';

    isa_ok $e->breadcrumb, 'Yetie::Domain::Collection';
    isa_ok $e->pager,      'Data::Page';
    isa_ok $e->form,       'Yetie::Form::Base';
};

done_testing();
