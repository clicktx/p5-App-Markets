requires 'perl',                                    '5.018';
requires 'Scalar::Util',                            '1.47';
requires 'Sub::Util',                               '1.47';
requires 'Try::Tiny',                               '0.28';
requires 'File::Find::Rule',                        '0.34';
requires 'DateTime',                                '1.42';
requires 'DateTime::Format::Strptime',              '1.73';
requires 'Data::Clone',                             '0.004';
requires 'Mojolicious',                             '== 7.32';
requires 'Mojolicious::Plugin::Scrypt',             '0.01';
requires 'Mojolicious::Plugin::Model',              '0.07';
requires 'Mojolicious::Plugin::LocaleTextDomainOO', '0.04';
requires 'Mojolicious::Plugin::FormFields',         '0.05';
requires 'MojoX::Session',                          '0.33';
requires 'Session::Token',                          '1.503';
requires 'DBI',                                     '1.636';
requires 'DBD::mysql',                              '4.033';
requires 'DBIx::Class',                             '0.082840';
requires 'SQL::Translator',                         '0.11021';
requires 'DBIx::Class::Candy',                      '0.005002';
requires 'DBIx::Class::ResultSet::HashRef',         '1.002';
requires 'DBIx::Class::Tree',                       '0.03003';
requires 'Server::Starter',                         '0.32';
requires 'Gazelle',                                 '0.46';
requires 'Tie::IxHash',                             '1.23';
requires 'Struct::Diff',                            '0.86';
requires 'FormValidator::Simple',                   '0.29';

# XS modules. it's a high performance!
# See http://qiita.com/karupanerura/items/e765b23bd3bff806cc27
requires 'HTTP::Parser::XS',          '0.17';
requires 'Time::TZOffset',            '0.04';
requires 'WWW::Form::UrlEncoded::XS', '0.24';
requires 'Cookie::Baker::XS',         '0.07';
requires 'JSON::XS',                  '3.02';
requires 'Cpanel::JSON::XS',          '3.0227';
requires 'Class::C3::XS',             '0.14';
requires 'List::Util::XS',            '1.47';

# requires 'YAML::XS';

on configure => sub {
    requires 'Module::Build',    '0.38';
    requires 'Module::CPANfile', '0.9010';
};

on test => sub {
    requires 'Test::Harness', '3.39';
    requires 'Test::More';
    requires 'Test::Deep';
    requires 'Test::Class';
    requires 'Test::mysqld';
    requires 'Harriet';
    requires 'DateTime::Format::MySQL';
    requires 'Test::Perl::Critic';
};

on develop => sub {
    requires 'DDP';
    requires 'Data::Dumper';
    requires 'DBIx::QueryLog';
    requires 'Test::Vars',         '0.014';
    requires 'ExtUtils::Manifest', '1.70';
    requires 'Test::Perl::Metrics::Lite';
};
