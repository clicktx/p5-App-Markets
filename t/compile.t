use Mojo::Base -strict;

use Test::More;

use_ok $_ for qw(
  Yetie
  MojoX::Session
  Yetie::App::Core::Session::Store::Dbic
  Mojolicious::Plugin::LocaleTextDomainOO
  Mojolicious::Plugin::Scrypt
);

done_testing();
