package Yetie::Service::Test;
use Mojo::Base 'Yetie::Service';

sub foo { }

package Yetie::Service::Test::Story;
use Mojo::Base 'Yetie::Service::Test';

sub bar { }

1;
