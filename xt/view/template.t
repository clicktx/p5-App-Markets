use Mojo::Base -strict;

use Test::Mojo;
use Test::More;
use File::Basename 'dirname';
use File::Spec::Functions 'catfile';
use Mojo::Template;
use Markets::View::EPLRenderer;
use t::Util;

# Empty template
my $mt     = Mojo::Template->new;
my $output = $mt->render('');
is $output, '', 'empty string';

my $c = Test::Mojo->new('App');

# File
$mt = Mojo::Template->new;
my $file = catfile dirname(__FILE__), 'templates', 'test.mt';
$output = $mt->render_file_after($c,  $file, 3 );
like $output, qr/23\nHello World!/, 'file';

# Exception in file
$mt     = Mojo::Template->new;
$file   = catfile dirname(__FILE__), 'templates', 'exception.mt';
$output = $mt->render_file_after($c, $file);
isa_ok $output, 'Mojo::Exception', 'right exception';
like $output->message, qr/exception\.mt line 2/, 'message contains filename';
ok $output->verbose, 'verbose exception';
is $output->lines_before->[0][0], 1,      'right number';
is $output->lines_before->[0][1], 'test', 'right line';
is $output->line->[0], 2,        'right number';
is $output->line->[1], '% die;', 'right line';
is $output->lines_after->[0][0], 3,     'right number';
is $output->lines_after->[0][1], '123', 'right line';
like "$output", qr/exception\.mt line 2/, 'right result';

# Exception in file (different name)
$mt     = Mojo::Template->new;
$output = $mt->name('"foo.mt" from DATA section')->render_file_after($c, $file);
isa_ok $output, 'Mojo::Exception', 'right exception';
like $output->message, qr/foo\.mt from DATA section line 2/,
  'message contains filename';
ok $output->verbose, 'verbose exception';
is $output->lines_before->[0][0], 1,      'right number';
is $output->lines_before->[0][1], 'test', 'right line';
is $output->line->[0], 2,        'right number';
is $output->line->[1], '% die;', 'right line';
is $output->lines_after->[0][0], 3,     'right number';
is $output->lines_after->[0][1], '123', 'right line';
like "$output", qr/foo\.mt from DATA section line 2/, 'right result';

# Exception with UTF-8 context
$mt     = Mojo::Template->new;
$file   = catfile dirname(__FILE__), 'templates', 'utf8_exception.mt';
$output = $mt->render_file_after($c, $file);
isa_ok $output, 'Mojo::Exception', 'right exception';
ok $output->verbose, 'verbose exception';
is $output->lines_before->[0][1], '☃', 'right line';
is $output->line->[1], '% die;♥', 'right line';
is $output->lines_after->[0][1], '☃', 'right line';

# Exception in first line with bad message
$mt     = Mojo::Template->new;
$output = $mt->render('<% die "Test at template line 99\n"; %>');
isa_ok $output, 'Mojo::Exception', 'right exception';
is $output->message, "Test at template line 99\n", 'right message';
ok $output->verbose, 'verbose exception';
is $output->lines_before->[0], undef, 'no lines before';
is $output->line->[0],         1,     'right number';
is $output->line->[1], '<% die "Test at template line 99\n"; %>', 'right line';
is $output->lines_after->[0], undef, 'no lines after';

# Different encodings
$mt = Mojo::Template->new( encoding => 'shift_jis' );
$file = catfile dirname(__FILE__), 'templates', 'utf8_exception.mt';
ok !eval { $mt->render_file_after($c, $file) }, 'file not rendered';
like $@, qr/invalid encoding/, 'right error';

# Custom escape function
$mt = Mojo::Template->new( escape => sub { '+' . $_[0] } );
is $mt->render('<%== "hi" =%>'), '+hi', 'right escaped string';

done_testing();
