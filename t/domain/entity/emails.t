use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection qw(c);

my $pkg = 'Yetie::Domain::Entity::Emails';
use_ok $pkg;

subtest 'basic' => sub {
    my $emails = $pkg->new();
    isa_ok $emails->email_list, 'Yetie::Domain::Collection';
    can_ok $emails, 'each';
};

done_testing();
