requires 'Mojolicious', '== 6.58';
requires 'File::Find::Rule';
requires 'Mojolicious::Plugin::Model';
requires 'Teng';
requires 'DBI';
requires 'DBD::mysql';

on build => sub {
    requires 'ExtUtils::MakeMaker';
};
