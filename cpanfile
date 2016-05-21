requires 'Mojolicious', '== 6.58';
requires 'File::Find::Rule';

on build => sub {
    requires 'ExtUtils::MakeMaker';
};
