use strict;
use warnings;
use Test::More;
use File::Spec;
use File::Basename qw(dirname);

eval {
    require Perl::Critic;
    Perl::Critic->VERSION(1.105);

    require Test::Perl::Critic;
    Test::Perl::Critic->VERSION(1.02);
    my $rcfile = File::Spec->catfile( dirname(__FILE__), '..', '.perlcriticrc' );
    Test::Perl::Critic->import( -profile => $rcfile );
};
note $@ if $@;
plan skip_all => "Perl::Critic 1.105+ or Test::Perl::Critic 1.02+ is not installed." if $@;

all_critic_ok( 'lib', 'script', 'bin' );
