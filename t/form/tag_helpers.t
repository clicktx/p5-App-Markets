use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::DOM;
use t::Util;

my $t = Test::Mojo->new('App');

{
    my $c = $t->app->build_controller;

    eval { $c->form_widget('foo#bar') };
    ok $@, 'right unable to set form';

    eval { $c->form_widget() };
    ok $@, 'right unable to set field name';

    my $dom;
    $dom = Mojo::DOM->new( $c->form_widget('search#q') );
    is_deeply $dom->at('*')->attr,
      {
        type => 'text',
        id   => 'form_widget_q',
        name => 'q',
      },
      'right widget basic';

    $dom = Mojo::DOM->new( $c->form_widget( 'search#q', class => 'foo', 'data-bar' => 'buz' ) );
    is_deeply $dom->at('*')->attr,
      {
        type       => 'text',
        id         => 'form_widget_q',
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
        id       => 'form_widget_name',
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

sub f {
    return Yetie::Form::Field->new(
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

done_testing();
