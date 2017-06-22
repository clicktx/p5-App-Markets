use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::DOM;
use t::Util;
use Mojo::Collection 'c';

use_ok 'Markets::Form::Field';

my $t   = Test::Mojo->new('App');
my $app = $t->app;

my $f = Markets::Form::Field->new(
    field_key   => 'item.[].name',
    name        => 'item.0.name',
    label       => 'label text',
    placeholder => 'example',
);

subtest 'label' => sub {
    my $dom = Mojo::DOM->new( $f->label_for->($app) );
    is_deeply $dom->at('*')->attr, { for => 'item_0_name' }, 'right attr';
    is $dom->at('*')->text, 'label text', 'right text';
};

subtest 'input basic' => sub {
    my @types = qw(email number search tel text url password);
    for my $type (@types) {
        my $dom = Mojo::DOM->new( $f->$type->($app) );
        is_deeply $dom->at('*')->attr,
          { type => $type, id => 'item_0_name', name => 'item.0.name', placeholder => 'example' }, "right $type";
    }
};

subtest 'input other' => sub {
    my @types = qw(color range date month time week file);
    for my $type (@types) {
        my $dom = Mojo::DOM->new( $f->$type->($app) );
        is_deeply $dom->at('*')->attr, { type => $type, id => 'item_0_name', name => 'item.0.name' }, "right $type";
    }
};

subtest 'hidden' => sub {
    $f->value('abc');
    my $dom = Mojo::DOM->new( $f->hidden->($app) );
    is_deeply $dom->at('*')->attr, { type => 'hidden', name => 'item.0.name', value => 'abc' }, 'right hidden';
};

subtest 'textarea' => sub {
    my $f = Markets::Form::Field->new(
        field_key     => 'order.note',
        name          => 'order.note',
        type          => 'textarea',
        label         => 'Note',
        cols          => 40,
        default_value => 'default text',
    );
    my $dom = Mojo::DOM->new( $f->textarea->($app) );
    is $dom->at('*')->tag, 'textarea', 'right tag';
    is_deeply $dom->at('*')->attr, { id => 'order_note', name => 'order.note', cols => 40 }, 'right textarea';
    is $dom->at('*')->text, 'default text', 'right text';
};

subtest 'radio checkbox' => sub {
    my $f = Markets::Form::Field->new(
        field_key => 'country',
        name      => 'country',
        value     => 'USA',
    );

    for my $type (qw/radio checkbox/) {
        my $dom = Mojo::DOM->new( $f->$type->($app) );
        is_deeply $dom->at('*')->attr, { type => $type, id => 'country', name => 'country', value => 'USA' },
          "right $type";
    }

    $f->checked(undef);
    for my $type (qw/radio checkbox/) {
        my $dom = Mojo::DOM->new( $f->$type->($app) );
        is_deeply $dom->at('*')->attr,
          { type => $type, id => 'country', name => 'country', value => 'USA' },
          "right $type unchecked";
    }

    # bool "checked"
    $f->checked(1);
    for my $type (qw/radio checkbox/) {
        my $dom = Mojo::DOM->new( $f->$type->($app) );
        is_deeply $dom->at('*')->attr,
          { checked => 'checked', type => $type, id => 'country', name => 'country', value => 'USA' },
          "right $type checked";
    }
};

subtest 'select' => sub {
    my $f = Markets::Form::Field->new(
        field_key => 'country',
        name      => 'country',
    );

    my $dom;
    $dom = Mojo::DOM->new( $f->select->($app) );
    is $dom->at('*')->tag, 'select', 'right tag';
    is_deeply $dom->at('*')->attr, { id => 'country', name => 'country' }, 'right attr';

    my $child;
    $f->choices( [ 'de', 'en' ] );
    $dom = Mojo::DOM->new( $f->select->($app) );
    is_deeply $dom->at('select')->attr, { id => 'country', name => 'country' }, 'right attr';
    $child = $dom->at('select')->child_nodes;
    is @{$child}[0]->text, 'de', 'right text';
    is_deeply @{$child}[0]->attr, { value => 'de' }, 'right attr';
    is @{$child}[1]->text, 'en', 'right text';
    is_deeply @{$child}[1]->attr, { value => 'en' }, 'right attr';

    # using I18N t/share/locale/en.po
    $f->choices( [ [ Japan => 'jp' ], [ Germany => 'de', class => 'test-class', selected => 0 ], 'cn' ] );
    $dom   = Mojo::DOM->new( $f->select->($app) );
    $child = $dom->at('select')->child_nodes;
    is @{$child}[0]->text, '日本', 'right text';
    is_deeply @{$child}[0]->attr, { value => 'jp' }, 'right attr';
    is @{$child}[1]->text, 'ドイツ', 'right text';
    is_deeply @{$child}[1]->attr, { value => 'de', class => 'test-class' }, 'right attr';
    is @{$child}[2]->text, 'cn', 'right text';
    is_deeply @{$child}[2]->attr, { value => 'cn' }, 'right attr';

    $f->choices( [ [ Japan => 'jp' ], [ Germany => 'de', class => 'test-class', selected => 1 ], 'cn' ] );
    $dom   = Mojo::DOM->new( $f->select->($app) );
    $child = $dom->at('select')->child_nodes;
    is_deeply @{$child}[1]->attr, { value => 'de', class => 'test-class', selected => 'selected' }, 'right selected';

    my $child_child;
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ 'cn', 'jp' ], class => 'test-class' ) ] );
    $dom   = Mojo::DOM->new( $f->select->($app) );
    $child = $dom->at('select')->child_nodes;
    is_deeply @{$child}[0]->attr, { label => 'ヨーロッパ' }, 'right optgroup attr';
    $child_child = @{$child}[0]->child_nodes;
    is_deeply @{$child_child}[0]->attr, { value => 'de' }, 'right option attr';
    is_deeply @{$child_child}[1]->attr, { value => 'en' }, 'right option attr';
    is_deeply @{$child}[1]->attr, { label => 'アジア', class => 'test-class' }, 'right optgroup attr';
    $child_child = @{$child}[1]->child_nodes;
    is_deeply @{$child_child}[0]->attr, { value => 'cn' }, 'right option attr';
    is_deeply @{$child_child}[1]->attr, { value => 'jp' }, 'right option attr';

    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ) ] );
    $dom         = Mojo::DOM->new( $f->select->($app) );
    $child       = $dom->at('select')->child_nodes;
    $child_child = @{$child}[1]->child_nodes;
    is @{$child_child}[0]->text, '中国', 'right option text';
    is_deeply @{$child_child}[0]->attr, { value => 'cn' }, 'right option attr';
    is @{$child_child}[1]->text, '日本', 'right option text';
    is_deeply @{$child_child}[1]->attr, { value => 'jp', selected => 'selected' }, 'right option selected';
};

# subtest 'choice' => sub {
#     say $f->choice->($app);
# };

done_testing();
