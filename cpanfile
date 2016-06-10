requires 'Mojolicious',                '== 6.62';
requires 'File::Find::Rule',           '0.34';
requires 'Mojolicious::Plugin::Model', '0.07';
requires 'MojoX::Session',             '0.33';
requires 'Teng',                       '0.28';
requires 'Teng::Plugin::ResultSet',    '0.01';
requires 'DBI',                        '1.636';
requires 'DBD::mysql',                 '4.033';
requires 'Data::MessagePack',          '0.49';

on build => sub {
    requires 'ExtUtils::MakeMaker';
};

on develop => sub {
    requires 'Test::mysqld';
};

on test => sub {
    requires 'Test::mysqld';
};
