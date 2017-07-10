use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::DOM;
use t::Util;
use Mojo::Collection 'c';

use_ok 'Markets::Form::Field';

my $t = Test::Mojo->new('App');
my $c = $t->app->build_controller;

my $f = Markets::Form::Field->new(
    field_key     => 'item.[].name',
    name          => 'item.0.name',
    label         => 'label text',
    placeholder   => 'example',
    default_value => 'sss',
    required      => 1,
);

subtest 'label' => sub {
    my $dom = Mojo::DOM->new( $f->label_for($c) );
    is_deeply $dom->at('*')->attr, { for => 'item_0_name' }, 'right attr';
    is $dom->at('*')->text, 'label text', 'right text';
};

subtest 'input basic' => sub {
    my @types = qw(email number search tel text url);
    for my $type (@types) {
        my $dom = Mojo::DOM->new( $f->$type($c) );
        is_deeply $dom->at('*')->attr,
          {
            type        => $type,
            id          => 'item_0_name',
            name        => 'item.0.name',
            placeholder => 'example',
            required    => undef,
            value       => 'sss',
          },
          "right $type";
    }

    # password_field
    my $dom = Mojo::DOM->new( $f->password($c) );
    is_deeply $dom->at('*')->attr,
      {
        type        => 'password',
        id          => 'item_0_name',
        name        => 'item.0.name',
        placeholder => 'example',
        required    => undef,
      },
      "right password";
};

subtest 'input other' => sub {
    my @types = qw(color range date month time week);
    my $dom;
    for my $type (@types) {
        $dom = Mojo::DOM->new( $f->$type($c) );
        is_deeply $dom->at('*')->attr,
          {
            type     => $type,
            id       => 'item_0_name',
            name     => 'item.0.name',
            required => undef,
            value    => 'sss',
          },
          "right $type";
    }

    # datetime-local
    $dom = Mojo::DOM->new( $f->datetime($c) );
    is_deeply $dom->at('*')->attr,
      {
        type     => 'datetime-local',
        id       => 'item_0_name',
        name     => 'item.0.name',
        required => undef,
        value    => 'sss',
      },
      "right datetime";

    # file_field
    $dom = Mojo::DOM->new( $f->file($c) );
    is_deeply $dom->at('*')->attr,
      {
        type     => 'file',
        id       => 'item_0_name',
        name     => 'item.0.name',
        required => undef,
      },
      "right datetime";
};

subtest 'hidden' => sub {
    $f->value('abc');
    my $dom = Mojo::DOM->new( $f->hidden($c) );
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
    my $dom = Mojo::DOM->new( $f->textarea($c) );
    is $dom->at('*')->tag, 'textarea', 'right tag';
    is_deeply $dom->at('*')->attr, { id => 'order_note', name => 'order.note', cols => 40 }, 'right textarea';
    is $dom->at('*')->text, 'default text', 'right text';
};

subtest 'radio checkbox' => sub {
    my $f = Markets::Form::Field->new(
        name  => 'agreed',
        value => 'yes',
        label => 'I agreed',
    );

    for my $type (qw/radio checkbox/) {
        my $dom = Mojo::DOM->new( $f->$type($c) );
        is $dom->at('*')->tag, 'label', "right $type parent";
        is $dom->at('*')->text, '私は同意した', "right $type label text";
        is_deeply $dom->at('input')->attr, { type => $type, name => 'agreed', value => 'yes' }, "right $type";
    }

    $f->checked(0);
    for my $type (qw/radio checkbox/) {
        my $dom = Mojo::DOM->new( $f->$type($c) );
        is_deeply $dom->at('input')->attr, { type => $type, name => 'agreed', value => 'yes' }, "right $type unchecked";
    }

    # bool "checked"
    $f->checked(1);
    for my $type (qw/radio checkbox/) {
        my $dom = Mojo::DOM->new( $f->$type($c) );
        is_deeply $dom->at('input')->attr, { checked => undef, type => $type, name => 'agreed', value => 'yes' },
          "right $type checked";
    }
};

subtest 'select' => sub {
    my $f = Markets::Form::Field->new(
        field_key => 'country',
        name      => 'country',
    );

    my $dom;
    $dom = Mojo::DOM->new( $f->select($c) );
    is $dom->at('*')->tag, 'select', 'right tag';
    is_deeply $dom->at('*')->attr, { id => 'country', name => 'country' }, 'right attr';

    my $child;
    $f->choices( [ 'de', 'en' ] );
    $dom = Mojo::DOM->new( $f->select($c) );
    is_deeply $dom->at('select')->attr, { id => 'country', name => 'country' }, 'right attr';
    $child = $dom->at('select')->child_nodes;
    is @{$child}[0]->text, 'de', 'right text';
    is_deeply @{$child}[0]->attr, { value => 'de' }, 'right attr';
    is @{$child}[1]->text, 'en', 'right text';
    is_deeply @{$child}[1]->attr, { value => 'en' }, 'right attr';

    # using I18N t/share/locale/en.po
    $f->choices( [ [ Japan => 'jp' ], [ Germany => 'de', class => 'test-class', selected => 0 ], 'cn' ] );
    $dom   = Mojo::DOM->new( $f->select($c) );
    $child = $dom->at('select')->child_nodes;
    is @{$child}[0]->text, '日本', 'right text';
    is_deeply @{$child}[0]->attr, { value => 'jp' }, 'right attr';
    is @{$child}[1]->text, 'ドイツ', 'right text';
    is_deeply @{$child}[1]->attr, { value => 'de', class => 'test-class' }, 'right attr';
    is @{$child}[2]->text, 'cn', 'right text';
    is_deeply @{$child}[2]->attr, { value => 'cn' }, 'right attr';

    $f->choices( [ [ Japan => 'jp' ], [ Germany => 'de', class => 'test-class', selected => 1 ], 'cn' ] );
    $dom   = Mojo::DOM->new( $f->select($c) );
    $child = $dom->at('select')->child_nodes;
    is_deeply @{$child}[1]->attr, { value => 'de', class => 'test-class', selected => 'selected' }, 'right selected';

    my $child_child;
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ 'cn', 'jp' ], class => 'test-class' ) ] );
    $dom   = Mojo::DOM->new( $f->select($c) );
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
    $dom         = Mojo::DOM->new( $f->select($c) );
    $child       = $dom->at('select')->child_nodes;
    $child_child = @{$child}[1]->child_nodes;
    is @{$child_child}[0]->text, '中国', 'right option text';
    is_deeply @{$child_child}[0]->attr, { value => 'cn' }, 'right option attr';
    is @{$child_child}[1]->text, '日本', 'right option text';
    is_deeply @{$child_child}[1]->attr, { value => 'jp', selected => 'selected' }, 'right option selected';
};

subtest 'choice' => sub {
    my $f = Markets::Form::Field->new(
        field_key => 'country',
        name      => 'country',
    );
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ) ] );

    my $dom;

    # select
    $f->multiple(0);
    $f->expanded(0);
    $dom = Mojo::DOM->new( $f->choice($c) );
    is $dom->at('*')->tag, 'select', 'right tag';

    # select (multiple)
    $f->multiple(1);
    $f->expanded(0);
    $dom = Mojo::DOM->new( $f->choice($c) );
    is $dom->at('*')->attr->{multiple}, undef, 'right multiple';

    # radio list
    my $input;
    $f->multiple(0);
    $f->expanded(1);
    $f->choices( [ [ Japan => 'jp' ], [ Germany => 'de', checked => 0 ], 'cn' ] );
    $dom = Mojo::DOM->new( $f->choice($c) );
    is_deeply $dom->at('ul')->attr, { class => 'form-choices' },     'right class';
    is_deeply $dom->at('li')->attr, { class => 'form-choice-item' }, 'right class';
    $input = $dom->find('input');
    is_deeply $input->[1]->attr, { name => 'country', type => 'radio', value => 'de' }, 'right type is radio';

    $f->choices( [ [ Japan => 'jp' ], [ Germany => 'de', checked => 1 ], 'cn' ] );
    $dom   = Mojo::DOM->new( $f->choice($c) );
    $input = $dom->find('input');
    is_deeply $input->[1]->attr, { checked => undef, name => 'country', type => 'radio', value => 'de' }, 'right attr';

    $f->choices( [ c( EU => [ 'de', 'en' ], class => 'test-class' ) ] );
    $dom = Mojo::DOM->new( $f->choice($c) );
    is_deeply $dom->at('li')->attr, { class => 'test-class' }, 'right class';

    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', checked => 1 ] ] ) ] );
    $dom = Mojo::DOM->new( $f->choice($c) );
    is_deeply $dom->at('ul')->attr, { class => 'form-choice-groups' }, 'right class';
    is_deeply $dom->at('li')->attr, { class => 'form-choice-group' },  'right class';
    my $child;
    $child = $dom->at('ul')->child_nodes;
    is $child->[0]->text, 'ヨーロッパ', 'right group label';
    is $child->[1]->text, 'アジア',       'right group label';
    $input = $dom->find('input');
    is_deeply $input->[3]->attr, { checked => undef, name => 'country', type => 'radio', value => 'jp' }, 'right attr';

    # checkbox list (multiple)
    $f->multiple(1);
    $f->expanded(1);
    $dom   = Mojo::DOM->new( $f->choice($c) );
    $input = $dom->find('input');
    is_deeply $input->[0]->attr, { name => 'country[]', type => 'checkbox', value => 'de' }, 'right type is checkbox';
    is_deeply $input->[3]->attr, { checked => undef, name => 'country[]', type => 'checkbox', value => 'jp' },
      'right checked';
};

subtest 'field-with-error' => sub {
    my $f = Markets::Form::Field->new(
        field_key => 'country.[].id',
        name      => 'country.0.id',
        label     => 'Country Name',
    );

    # Set validaion error
    $c->validation->error( 'country.0.id' => ['custom_check'] );

    # label
    my $dom = Mojo::DOM->new( $f->label_for($c) );
    ok $dom->find('.field-with-error')->size, 'right class';

    # choice
    $f->choices( [ c( EU => [ 'de', 'en' ] ), c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ) ] );
    $f->multiple(1);
    $f->expanded(1);

    $c->validation->error( 'country.0.id[]' => ['custom_check'] );
    $dom = Mojo::DOM->new( $f->choice($c) );
    ok $dom->find('ul.field-with-error')->size, 'right class';
};

subtest 'help_block' => sub {
    my $f = Markets::Form::Field->new(
        field_key => 'name',
        name      => 'name',
        help      => 'my name',
    );
    my $dom = Mojo::DOM->new( $f->help_block($c) );
    is_deeply $dom->at('span')->attr, { class => 'form-help-block' }, 'right attrs';
    is $dom->at('span')->text, 'my name', 'right text';

    $f = Markets::Form::Field->new(
        field_key => 'name',
        name      => 'name',
        help      => sub { shift->__x( '{hoge} name', hoge => 'my' ) },
    );
    $dom = Mojo::DOM->new( $f->help_block($c) );
    is_deeply $dom->at('span')->attr, { class => 'form-help-block' }, 'right attrs';
    is $dom->at('span')->text, 'my name', 'right text';
};

subtest 'error_block' => sub {
    my $f = Markets::Form::Field->new(
        field_key      => 'name',
        name           => 'name',
        required       => 1,
        error_messages => { required => 'Name is required.' },
    );
    my $dom = Mojo::DOM->new( $f->error_block($c) );
    is $dom, '', 'right empty';

    # invalid field
    $c->validation->error( name => [ 'required', 1 ] );
    $dom = Mojo::DOM->new( $f->error_block($c) );
    is_deeply $dom->at('span')->attr, { class => 'form-error-block' }, 'right attrs';
    is $dom->at('span')->text, 'Name is required.', 'right message';
};

done_testing();