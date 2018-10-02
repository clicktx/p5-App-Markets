use Mojo::Base -strict;
use Test::More;
use Test::Requires { 'Test::Pod::Coverage' => '1.10' };

sub check {
    pod_coverage_ok(
        shift,
        {
            also_private => [
                qr/(?:
                cook            |
                new             |
                register        |
                dummy_dummy
            )/x
            ]
        }
    );
}

my @modules = all_modules;
foreach my $module (@modules) {
    next if $module =~ qr/(?:
        Yetie::Controller::         |
        Yetie::Factory::Entity::    |
        Yetie::Dummy::Dummey
    )/x;
    check($module);
}

done_testing;
