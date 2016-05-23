requires 'Mojolicious', '== 6.58';
requires 'File::Find::Rule';
requires 'Mojolicious::Plugin::Model';
requires 'Teng';

on build => sub {
    requires 'ExtUtils::MakeMaker';
};
