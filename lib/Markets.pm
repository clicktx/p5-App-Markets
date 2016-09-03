package Markets;
use Mojo::Base 'Markets::Web';
use File::Spec;
use File::Basename;
our $VERSION = '0.01';

my $project_home;
BEGIN { $project_home = File::Spec->catdir( dirname(__FILE__), '..' ) }
use lib glob "$project_home/addons/*/lib";
has project_home => sub { $project_home };

1;
__END__

=head1 NAME

Markets - Markets

=head1 DESCRIPTION

This is a main context class for Markets

=head1 AUTHOR

Markets authors.
