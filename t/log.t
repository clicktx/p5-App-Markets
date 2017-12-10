use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Mojo::File qw(path);
use Mojo::Util 'decode';

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $dir = path( $app->home, 'var', 'log' )->make_path;

# default
$app->log->info('foo');
$app->log->error('bar');
my $path = $dir->child('test.log');
my $content = decode 'UTF-8', path($path)->slurp;
like $content, qr/\[.*\] \[info\] foo/,  'right log default info message';
like $content, qr/\[.*\] \[error\] bar/, 'right log default error message';

# changed log file
$app->log('foo')->info('foo');
$app->log('foo')->error('bar');
$path = $dir->child('foo.log');
$content = decode 'UTF-8', path($path)->slurp;
like $content, qr/\[.*\] \[info\] foo/,  'right change log info message';
like $content, qr/\[.*\] \[error\] bar/, 'right change log error message';

$dir->remove_tree;
done_testing();
