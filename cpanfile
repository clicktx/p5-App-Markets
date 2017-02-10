requires 'perl',                                    '5.018';
requires 'Scalar::Util',                            '1.47';
requires 'Mojolicious',                             '== 7.20';
requires 'File::Find::Rule',                        '0.34';
requires 'Mojolicious::Plugin::Model',              '0.07';
requires 'Mojolicious::Plugin::LocaleTextDomainOO', '0.04';
requires 'Mojolicious::Plugin::FormFields',         '0.05';
requires 'MojoX::Session',                          '0.33';
requires 'Session::Token',                          '1.503';
requires 'DBI',                                     '1.636';
requires 'DBD::mysql',                              '4.033';
requires 'Teng',                                    '0.28';
requires 'Data::MessagePack',                       '0.49';
requires 'Class::Inspector',                        '1.28';
requires 'Server::Starter',                         '0.32';
requires 'Gazelle',                                 '0.46';

# XS modules. it's a high performance!
# See http://qiita.com/karupanerura/items/e765b23bd3bff806cc27
requires 'HTTP::Parser::XS', '0.17';
requires 'Time::TZOffset',   '0.04';

#requires 'Cookie::Baker::XS', '0.06';
#requires 'JSON::XS',          '3.02';

on configure => sub {
    requires 'Module::Build',    '0.38';
    requires 'Module::CPANfile', '0.9010';
};

on test => sub {
    requires 'Test::More';
    requires 'Test::mysqld';
    requires 'Harriet';
    requires 'Test::Perl::Critic';
};

on develop => sub {
    requires 'DDP';
    requires 'Data::Dumper';
    requires 'DBIx::QueryLog';
};
