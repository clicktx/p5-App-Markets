use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection qw(c);

my $pkg = 'Yetie::Domain::List::Emails';
my $vo  = 'Yetie::Domain::Value::Email';
use_ok $pkg;
use_ok $vo;

sub _init {
    return $pkg->new(
        list => c(
            $vo->new( is_primary => 0, value => 1 ),
            $vo->new( is_primary => 1, value => 2 ),
            $vo->new( is_primary => 0, value => 3 ),
        )
    );
}

subtest 'find' => sub {
    my $emails = _init();
    isa_ok $emails->find(1), $vo;
    is $emails->find(2)->value, 2, 'right find';
};

subtest 'primary' => sub {
    my $emails = _init();
    is $emails->primary->value, 2, 'right primary';

    $emails = $pkg->new( list => c( $vo->new( value => 'foo' ) ) );
    is $emails->primary->value, 'foo', 'right first element, only one element';
};

done_testing();
