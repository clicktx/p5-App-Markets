package t::domain::base;
use Moo;
extends 'Yetie::Domain::BaseMoo';

has [qw{foo bar _foo _bar}] => ( is => 'rw' );

1;
