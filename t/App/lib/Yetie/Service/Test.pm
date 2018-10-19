package Yetie::Service::Test;
use Mojo::Base 'Yetie::Service';

has 'baz';

sub foo { }

package Yetie::Service::Test::Story;
use Mojo::Base 'Yetie::Service::Test';

sub bar { }

1;
