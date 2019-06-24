use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

use_ok 'Yetie::Domain::Entity::Page';

subtest 'basic' => sub {
    my $e = Yetie::Domain::Entity::Page->new();
    isa_ok $e, 'Yetie::Domain::Entity';

    can_ok $e, 'meta_info';
    can_ok $e, 'title';
    can_ok $e, 'breadcrumbs';
    can_ok $e, 'pager';
    can_ok $e, 'form';

    isa_ok $e->breadcrumbs, 'Yetie::Domain::List::Breadcrumbs';
    isa_ok $e->pager,       'Data::Page';
    isa_ok $e->form,        'Yetie::Form::Base';
};

done_testing();
