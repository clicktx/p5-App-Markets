use strict;
use warnings;

use Test::Perl::Metrics::Lite (
    -mccabe_complexity => 30,
    -loc               => 100,
    -except_file       => [ 'lib/Markets/View/DOM/EP.pm' ]
);

all_metrics_ok();
