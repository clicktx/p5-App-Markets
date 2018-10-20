use Mojo::Base -strict;
use Mojolicious::Lite;

plugin 'Yetie::App::Core::I18N';    # dependence
plugin 'Yetie::Core::Log';

get '/' => sub {
    my $c = shift;

    $c->logging->info('not set log name');    # $mode.log
    $c->logging('foo')->warn('set log name');
    $c->render( json => {} );
};

get '/foo' => sub {
    my $c = shift;

    # Set controller name
    $c->stash( controller => 'foo-bar' );
    $c->logging->error('controller is foo-bar');
    $c->logging_fatal('foo fatal');
    $c->render( json => {} );
};

use t::Util;
use Test::More;
use Test::Mojo;
use Mojo::File;
my $t   = Test::Mojo->new;
my $app = $t->app;

can_ok $app, 'logger';

# Create log dir
my $log_dir = $app->home->child( "var", "log" )->to_string;
my $path = Mojo::File->new($log_dir);
$path->make_path;

$t->get_ok('/')->status_is(200);
$t->get_ok('/foo')->status_is(200);

like do { Mojo::File->new( $path->child('foo.log') )->slurp },  qr/\[warn] set log name/,       'right foo log';
like do { Mojo::File->new( $path->child('test.log') )->slurp }, qr/\[info] not set log name/,   'right test log';
like do { Mojo::File->new( $path->child('foo.log') )->slurp },  qr/\[error] controller is foo/, 'right foo log';
like do { Mojo::File->new( $path->child('foo.log') )->slurp },  qr/\[fatal] foo fatal/,         'right foo log';

# Remove log dir
$path->remove_tree();

done_testing();

__END__
