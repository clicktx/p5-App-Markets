use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection qw(c);

my $pkg = 'Yetie::Domain::List::Emails';
use_ok $pkg;

subtest 'primary' => sub {
    my $vo = 'Yetie::Domain::Value::Email';
    use_ok $vo;
    my $emails = $pkg->new(
        list => c(
            $vo->new( is_primary => 0, value => 1 ),
            $vo->new( is_primary => 1, value => 2 ),
            $vo->new( is_primary => 0, value => 3 ),
        )
    );
    is $emails->primary->value, 2, 'right primary';

    $emails = $pkg->new( list => c( $vo->new( value => 'foo' ) ) );
    is $emails->primary->value, 'foo', 'right first element, only one element';
};

done_testing();
