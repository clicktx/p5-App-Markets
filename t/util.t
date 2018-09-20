use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Util';

subtest 'array_to_hash' => sub {
    my @array = (qw/a b c/);

    my %hash = Yetie::Util::array_to_hash(@array);
    is_deeply \%hash, { 0 => 'a', 1 => 'b', 2 => 'c' }, 'right convert to hash';
    %hash = Yetie::Util::array_to_hash('a');
    is_deeply \%hash, { 0 => 'a' }, 'right convert to hash(single argument)';
    %hash = Yetie::Util::array_to_hash();
    is_deeply \%hash, {}, 'right convert to hash(no argument)';

    my $hashref = Yetie::Util::array_to_hash(@array);
    is_deeply $hashref, { 0 => 'a', 1 => 'b', 2 => 'c' }, 'right convert to hash reference';

    %hash = Yetie::Util::array_to_hash( \@array );
    is_deeply \%hash, { 0 => 'a', 1 => 'b', 2 => 'c' }, 'right convert to hash(arguments array reference)';

    $hashref = Yetie::Util::array_to_hash( \@array );
    is_deeply $hashref, { 0 => 'a', 1 => 'b', 2 => 'c' }, 'right convert to hash reference(arguments array reference)';
};

subtest 'directories' => sub {
    my $themes = Yetie::Util::directories( 'themes', { ignore => [ 'admin', 'common', 'default' ] } );
    is_deeply $themes, ['mytheme'], 'loading mytheme';

    my $addons = Yetie::Util::directories('addons');
    is ref $addons, 'ARRAY', 'loading addons';
};

done_testing();
