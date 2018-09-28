requires 'perl',                                    '5.010';
requires 'CGI::Expand',                             '2.05';
requires 'DateTime',                                '1.42';
requires 'DateTime::Format::Strptime',              '1.73';
requires 'Data::Clone',                             '0.004';
requires 'Data::Page::Navigation',                  '0.06';
requires 'DBD::mysql',                              '4.033';
requires 'DBI',                                     '1.636';
requires 'DBIx::Sunny',                             '0.24';
requires 'DBIx::Class',                             '0.082840';
requires 'DBIx::Class::Candy',                      '0.005002';
requires 'DBIx::Class::ResultSet::HashRef',         '1.002';
requires 'DBIx::Class::Tree::NestedSet',            '0.10';
requires 'File::Find::Rule',                        '0.34';
requires 'FormValidator::Simple',                   '0.29';
requires 'Gazelle',                                 '0.46';
requires 'Mojolicious',                             '== 7.72';
requires 'Mojolicious::Plugin::LocaleTextDomainOO', '0.04';
requires 'Mojolicious::Plugin::Scrypt',             '0.01';
requires 'MojoX::Session',                          '0.33';
requires 'Mojo::Log::Clearable',                    '1.000';
requires 'Scalar::Util',                            '1.47';
requires 'Session::Token',                          '1.503';
requires 'Server::Starter',                         '0.32';
requires 'SQL::Translator',                         '0.11021';
requires 'Struct::Diff',                            '0.86';
requires 'Sub::Util',                               '1.47';
requires 'Tie::IxHash',                             '1.23';
requires 'Try::Tiny',                               '0.28';
requires 'Lingua::JA::Regular::Unicode',            '0.13';

# XS modules. it's a high performance!
# See http://qiita.com/karupanerura/items/e765b23bd3bff806cc27
# requires 'YAML::XS';
requires 'Class::C3::XS',             '0.14';
requires 'Cookie::Baker::XS',         '0.07';
requires 'Cpanel::JSON::XS',          '3.0227';
requires 'Date::Calc::XS',            '6.4';
requires 'HTTP::Parser::XS',          '0.17';
requires 'JSON::XS',                  '3.02';
requires 'List::Util::XS',            '1.47';
requires 'Time::TZOffset',            '0.04';
requires 'WWW::Form::UrlEncoded::XS', '0.24';

# NOTE: Mojolicious optional
# OPTIONAL
#   EV 4.0+                 (n/a)
#   IO::Socket::Socks 0.64+ (n/a)
#   IO::Socket::SSL 1.94+   (2.059)
#   Net::DNS::Native 0.15+  (n/a)
#   Role::Tiny 2.000001+    (2.000005)

on configure => sub {
    requires 'Module::Build',    '0.38';
    requires 'Module::CPANfile', '0.9010';
};

on test => sub {
    requires 'DateTime::Format::MySQL';
    requires 'Harriet';
    requires 'Test::Class';
    requires 'Test::Deep';
    requires 'Test::Exception';
    requires 'Test::Harness', '3.39';
    requires 'Test::More';
    requires 'Test::mysqld';
    requires 'Test::Perl::Critic';
};

on develop => sub {
    requires 'DBIx::QueryLog';
    requires 'Data::Dumper';
    requires 'DDP';
    requires 'ExtUtils::Manifest', '1.70';
    requires 'Test::Perl::Metrics::Lite';
    requires 'Test::Vars', '0.014';
};
