use Mojo::Base -strict;

use Test::More;

use_ok $_ for qw(
  Markets
  Markets::Web
  MojoX::Session
  Markets::Session::Store::Teng
  Mojolicious::Plugin::Model
  Mojolicious::Plugin::LocaleTextDomainOO
);

done_testing();
