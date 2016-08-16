requires 'Mojolicious',                             '== 6.66';
requires 'File::Find::Rule',                        '0.34';
requires 'Mojolicious::Plugin::Model',              '0.07';
requires 'Mojolicious::Plugin::LocaleTextDomainOO', '0.03';
requires 'MojoX::Session',                          '0.33';
requires 'Teng',                                    '0.28';
requires 'Teng::Plugin::ResultSet',                 '0.01';
requires 'DBI',                                     '1.636';
requires 'DBD::mysql',                              '4.033';
requires 'Data::MessagePack',                       '0.49';
requires 'Class::Inspector',                        '1.28';

on configure => sub {
    requires 'Module::Build',    '0.38';
    requires 'Module::CPANfile', '0.9010';
};

on test => sub {
    requires 'Test::More';
    requires 'Test::mysqld';
    requires 'Harriet';
    requires 'Test::Perl::Critic';
    requires 'Safe', '2.32';    # Hack for Devel::Cover
};
