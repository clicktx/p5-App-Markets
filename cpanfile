requires 'Mojolicious', '== 6.58';
requires 'File::Find::Rule';
requires 'Mojolicious::Plugin::Model';

on build => sub {
    requires 'ExtUtils::MakeMaker';
};
