use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;
use Mojo::DOM;

my $t         = Test::Mojo->new('App');
my $stash_key = 'yetie.form';

subtest 'helpers' => sub {
    my $c = $t->app->build_controller;

    can_ok $c->helpers, 'form';
    can_ok $c->helpers, 'form_field';
    can_ok $c->helpers, 'form_error';
    can_ok $c->helpers, 'form_help';
    can_ok $c->helpers, 'form_label';
    can_ok $c->helpers, 'form_widget';

    ok $c->form_widget('test#name'), 'right form widget';
};

subtest 'form' => sub {
    my $c = $t->app->build_controller;
    $c->form('test');
    ok $c->stash($stash_key)->{test}, 'right store stash';
    is $c->stash( $stash_key . '.topic' ), 'test', 'right topic form';

    $c->form('search');
    ok $c->stash($stash_key)->{search}, 'right store stash';
    is $c->stash( $stash_key . '.topic' ), 'search', 'right topic form';
};

subtest 'form_field' => sub {
    my $c = $t->app->build_controller;

    $c->form_field('email');
    is $c->stash( $stash_key . '.topic_field' ), 'email', 'right topic field';

    $c->form_field('#email');
    is $c->stash( $stash_key . '.topic_field' ), 'email', 'right topic field';

    $c->form_field('test#email');
    ok $c->stash($stash_key)->{test}, 'right create form object';
    is $c->stash( $stash_key . '.topic' ),       'test',  'right topic form';
    is $c->stash( $stash_key . '.topic_field' ), 'email', 'right topic field';

    $c->form_field('search#q');
    is $c->stash( $stash_key . '.topic' ),       'search', 'right switch topic form';
    is $c->stash( $stash_key . '.topic_field' ), 'q',      'right switch topic field';

    $c->form_field('order.*123.name');
    is $c->stash( $stash_key . '.topic_field' ), 'order.*123.name', 'right topic field';

    $c->form_field('#order.*123.name');
    is $c->stash( $stash_key . '.topic_field' ), 'order.*123.name', 'right topic field';

    $c->form_field('test#order.*123.name');
    is $c->stash( $stash_key . '.topic' ),       'test',            'right topic form';
    is $c->stash( $stash_key . '.topic_field' ), 'order.*123.name', 'right topic field';
};

subtest 'exception' => sub {
    my $c = $t->app->build_controller;

    eval { $c->form_widget('foo#bar') };
    ok $@, 'right unable to set form';

    eval { $c->form_widget() };
    ok $@, 'right unable to set field name';
};

subtest 'form_error' => sub {
    my $c = $t->app->build_controller;

    my $dom = Mojo::DOM->new( $c->form_error('test#email') );
    is $dom, '', 'right empty';

    $c->validation->error( email => ['required'] );
    $dom = Mojo::DOM->new( $c->form_error('test#email') );
    is_deeply $dom->at('span')->attr, { class => 'form-error-block' }, 'right attrs';
};

subtest 'form_help' => sub {
    my $c = $t->app->build_controller;

    my $dom = Mojo::DOM->new( $c->form_help('test#email') );
    is_deeply $dom->at('span')->attr, { class => 'form-help-block' }, 'right attrs';
    is $dom->at('span')->text, 'Your email', 'right text';
};

subtest 'form_label' => sub {
    my $c = $t->app->build_controller;

    my $dom = Mojo::DOM->new( $c->form_label('test#email') );
    is_deeply $dom->at('*')->attr, { for => 'form-widget-email' }, 'right attr';
    is $dom->at('*')->text, 'E-mail', 'right text';
    is $dom->at('*')->children->first, undef, 'right required';

    $dom = Mojo::DOM->new( $c->form_label( 'test#email', class => 'my-label-class' ) );
    is $dom->at('*')->attr->{class}, 'my-label-class', 'right add class';

    $dom = Mojo::DOM->new( $c->form_label('test#nickname') );
    is $dom->at('*')->children->first->tag, 'span', 'right optional';
};

subtest 'form_widget' => sub {
    my $c = $t->app->build_controller;

    my $dom;
    $dom = Mojo::DOM->new( $c->form_widget('search#q') );
    is_deeply $dom->at('*')->attr,
      {
        type => 'text',
        id   => 'form-widget-q',
        name => 'q',
      },
      'right widget basic';

    $dom = Mojo::DOM->new( $c->form_widget( 'search#q', class => 'foo', 'data-bar' => 'buz' ) );
    is_deeply $dom->at('*')->attr,
      {
        type       => 'text',
        id         => 'form-widget-q',
        name       => 'q',
        class      => 'foo',
        'data-bar' => 'buz',
      },
      'right widget add attrs';

    $c->form_field('test#name');
    $dom = Mojo::DOM->new( $c->form_widget() );
    is_deeply $dom->at('*')->attr,
      {
        type     => 'text',
        id       => 'form-widget-name',
        name     => 'name',
        required => undef,
      },
      'right switch form';

    $dom = Mojo::DOM->new( $c->form_widget( class => 'foo' ) );
    is $dom->at('*')->attr->{class}, 'foo', 'right only attributes';

    $c->form_field('#email');
    $dom = Mojo::DOM->new( $c->form_widget() );
    is $dom->at('*')->attr->{name}, 'email', 'right #field_name';
};

done_testing();
