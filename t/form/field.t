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

# say $f->label_for->($app);
#
# say $f->email->($app);
# say $f->number->($app);
# say $f->search->($app);
# say $f->tel->($app);
# say $f->text->($app);
# say $f->url->($app);
# say $f->password->($app);
#
# say $f->color->($app);
# say $f->range->($app);
# say $f->date->($app);
# say $f->month->($app);
# say $f->time->($app);
# say $f->week->($app);
# say $f->file->($app);

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

    # say $f->hidden->($app);
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

    # say $f->textarea->($app);
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

    # say $f->radio->($app);
    # say $f->checkbox->($app);

    $f->checked(undef);
    for my $type (qw/radio checkbox/) {
        my $dom = Mojo::DOM->new( $f->$type->($app) );
        is_deeply $dom->at('*')->attr,
          { type => $type, id => 'country', name => 'country', value => 'USA' },
          "right $type unchecked";
    }

    $f->checked(1);

    for my $type (qw/radio checkbox/) {
        my $dom = Mojo::DOM->new( $f->$type->($app) );
        is_deeply $dom->at('*')->attr,
          { checked => 'checked', type => $type, id => 'country', name => 'country', value => 'USA' },
          "right $type checked";
    }

    # say $f->radio->($app);
    # say $f->checkbox->($app);
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
    say $f->select->($app);

    my $child;
    $f->choices( [ 'de', 'en' ] );
    $dom = Mojo::DOM->new( $f->select->($app) );
    is_deeply $dom->at('select')->attr, { id => 'country', name => 'country' }, 'right attr';
    $child = $dom->at('select')->child_nodes;
    is @{$child}[0]->text, 'de', 'right text';
    is_deeply @{$child}[0]->attr, { value => 'de' }, 'right attr';
    is @{$child}[1]->text, 'en', 'right text';
    is_deeply @{$child}[1]->attr, { value => 'en' }, 'right attr';
    say $f->select->($app);

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
    say $f->select->($app);

    $f->choices( [ [ Japan => 'jp' ], [ Germany => 'de', class => 'test-class', selected => 1 ], 'cn' ] );
    $dom   = Mojo::DOM->new( $f->select->($app) );
    $child = $dom->at('select')->child_nodes;
    is_deeply @{$child}[1]->attr, { value => 'de', class => 'test-class', selected => 'selected' }, 'right selected';
    say $f->select->($app);

    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ 'cn', 'jp' ] ) ] );
    say $f->select->($app);

    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ) ] );
    say $f->select->($app);
};

# subtest 'choice' => sub {
#     say $f->choice->($app);
# };

done_testing();
