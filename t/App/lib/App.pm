package App;
use Mojo::Base 'Markets::Web';

use File::Spec;
use File::Basename;

my $project_home;
BEGIN { $project_home = File::Spec->catdir( dirname(__FILE__), '..' ) }
use lib glob "$project_home/addons/*/lib";

has project_home => sub { $project_home };
1;
