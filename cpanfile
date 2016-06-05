requires 'Mojolicious', '== 6.62';
requires 'File::Find::Rule';
requires 'Mojolicious::Plugin::Model';
requires 'MojoX::Session';
requires 'Teng';
requires 'DBI';
requires 'DBIx::Connector';
requires 'DBD::mysql';

on build => sub {
    requires 'ExtUtils::MakeMaker';
};
