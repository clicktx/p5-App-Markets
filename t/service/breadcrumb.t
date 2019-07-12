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

    # my $e = $s->create_domain_entity( foo => { customer_id => 111 } );
    # isa_ok $e, 'Yetie::Domain::Entity::Activity';
    my $list = $s->get_list_by_category_id(3);
    is_deeply $list->to_data, [ { class => q{}, title => 'Sports' }, { class => 'current', title => 'Golf' } ],
      'right get list';

    $list = $s->get_list_by_category_id(999);
    is_deeply $list->to_data, [], 'right not found category';
}

__PACKAGE__->runtests;
