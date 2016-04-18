package Markets;
use Mojo::Base 'Mojolicious';
our $VERSION = '0.01';

# dispatcher is Mojolicious::Plugin
sub dispatcher { shift->plugin(@_) }

1;
__END__

=head1 NAME

Markets - Markets

=head1 DESCRIPTION

This is a main context class for Markets

=head1 AUTHOR

Markets authors.
