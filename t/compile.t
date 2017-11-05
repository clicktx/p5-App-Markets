use Mojo::Base -strict;

use Test::More;

use_ok $_ for qw(
  Yetie
  MojoX::Session
  Yetie::Session::Store::Dbic
  Mojolicious::Plugin::Model
  Mojolicious::Plugin::LocaleTextDomainOO
);

done_testing();
