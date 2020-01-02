package t::service::breadcrumb;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub _init {
    my $self = shift;
    my $c    = $self->t->app->build_controller;
    return ( $c, $c->service('breadcrumb') );
}

sub t01_get_list_by_category_id : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init;

    my $list = $s->get_list_by_category_id(16);
    is_deeply $list->to_data,
      [
        { class => q{},       title => 'Foods',  url => '/category/15' },
        { class => 'current', title => 'Drinks', url => '/category/16' },
      ],
      'right get list';

    $list = $s->get_list_by_category_id(999);
    is_deeply $list->to_data, [], 'right not found category';
}

sub t02_get_list_by_product : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init;

    my $product = $c->service('product')->find_product(3);
    my $list    = $s->get_list_by_product($product);
    is_deeply $list->to_data,
      [
        { class => q{},       title => 'Foods',            url => '/category/15' },
        { class => q{},       title => 'Alcoholic Drinks', url => '/category/18' },
        { class => 'current', title => 'Beer',             url => '/category/19' },
      ],
      'right get list';

    $product = $c->service('product')->find_product(6);
    $list    = $s->get_list_by_product($product);
    is_deeply $list->to_data, [], 'right not found category';
}

__PACKAGE__->runtests;
