use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

use_ok 'Yetie::Form::Field';

my $t = Test::Mojo->new('App');
my $c = $t->app->build_controller;

sub f {
    return Yetie::Form::Field->new(
        _fieldset     => 'Foo::Bar',
        field_key     => 'item.[].name',
        name          => 'item.0.name',
        label         => 'label text',
        placeholder   => 'example',
        default_value => 'sss',
        required      => 1,
    );
}

sub f2 {
    return Yetie::Form::Field->new(
        _fieldset      => 'Foo::Bar::Baz',
        field_key      => 'title',
        name           => 'title',
        label          => 'label text',
        placeholder    => 'example',
        default_value  => '',
        error_messages => {
            foo => 'bar',
        },
    );
}

subtest 'append_class' => sub {
    my $f = f();
    $f->append_class('foo');
    is $f->{class}, 'foo', 'right append class';

    $f->append_class('bar');
    is $f->{class}, 'foo bar', 'right append class';
};

subtest 'append_error_class' => sub {
    my $f = f();
    $f->append_error_class;
    is $f->{class}, 'field-with-error', 'right append error class';
};

subtest 'data' => sub {
    my $f = f();
    $f->data( foo => 'bar', baz => 'foo' );
    is $f->{'data-foo'}, 'bar', 'right set';
    is $f->{'data-baz'}, 'foo', 'right set';
    is $f->data('foo'), 'bar', 'right get';
    is $f->data('baz'), 'foo', 'right get';
};

subtest 'error_message' => sub {
    my $f = f();

    # getter
    is_deeply $f->error_message(), {}, 'right all error messages';
    is $f->error_message('foo'), undef, 'right getter';

    my $f2 = f2();
    is_deeply $f2->error_message(), { foo => 'bar' }, 'right all error messages';
    is $f2->error_message('foo'), 'bar', 'right getter';

    # setter
    $f->error_message( foo => 'foo', bar => 'bar' );
    is_deeply $f->error_message(), { foo => 'foo', bar => 'bar' }, 'right setter using array';

    $f->error_message( { buz => 'buz', qux => 'qux' } );
    is_deeply $f->error_message(),
      {
        foo => 'foo',
        bar => 'bar',
        buz => 'buz',
        qux => 'qux'
      },
      'right setter using hashref';
};

subtest 'id' => sub {
    my $f = f();
    is $f->id, 'foo-bar-item-0-name', 'right id';

    my $f2 = f2();
    is $f2->id, 'foo-bar-baz-title', 'right id';
};

done_testing();
