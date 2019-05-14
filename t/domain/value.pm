package t::domain::value;
use Moo;
extends 'Yetie::Domain::Value';

has foo  => ( is => 'ro' );
has bar  => ( is => 'ro' );
has _foo => ( is => 'ro' );
has _bar => ( is => 'ro' );

1;
