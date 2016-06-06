requires 'Mojolicious', '== 6.62';
requires 'File::Find::Rule';
requires 'Mojolicious::Plugin::Model';
requires 'MojoX::Session';
requires 'Teng';
requires 'Teng::Plugin::ResultSet';
requires 'DBI';
requires 'DBD::mysql';

on build => sub {
    requires 'ExtUtils::MakeMaker';
};
