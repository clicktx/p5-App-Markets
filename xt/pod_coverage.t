use Mojo::Base -strict;
use Test::More;
use Test::Requires { 'Test::Pod::Coverage' => '1.10' };

sub check {
    pod_coverage_ok(
        shift,
        {
            also_private => [
                qr/(?:
                attr            |
                cook            |
                new             |
                register        |
                to_data         |
                to_hash         |
                BUILD           |
                dummy_dummy
            )/x
            ]
        }
    );
}

my @modules = all_modules;
@modules = sort { $a cmp $b } @modules;

foreach my $module (@modules) {
    say "skip ... $module" and next if $module =~ qr/(?:
        Yetie::Controller::         |
        Yetie::Factory::Entity::    |
        Yetie::Form::FieldSet::     |
        Yetie::Schema::Result::     |
        Yetie::Routes               |
        Yetie::Dummy::Dummey
    )/x;
    check($module);
}

done_testing;
