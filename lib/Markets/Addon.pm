package Markets::Addon;
use Mojo::Base 'Mojolicious::Plugin';

use Carp 'croak';

sub install   { croak 'Method "install" not implemented by subclass' }
sub uninstall { croak 'Method "install" not implemented by subclass' }
sub update    { croak 'Method "update" not implemented by subclass' }
sub enable    { croak 'Method "enable" not implemented by subclass' }
sub disable   { croak 'Method "disable" not implemented by subclass' }

1;
