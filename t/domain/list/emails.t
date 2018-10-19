use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection qw(c);

my $pkg = 'Yetie::Domain::List::Emails';
use_ok $pkg;

subtest 'primary' => sub {
    my $vo = 'Yetie::Domain::Value::Email';
    use_ok $vo;
    my $collection = c(
        $vo->new( is_primary => 0, value => 1 ),
        $vo->new( is_primary => 1, value => 2 ),
        $vo->new( is_primary => 0, value => 3 ),
    );
    my $emails = $pkg->new( list => $collection );
    is $emails->primary, 2, 'right primary';
};

done_testing();
