use Mojo::Base -strict;

BEGIN { $ENV{MOJO_REACTOR} = 'Mojo::Reactor::Poll' }

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;

plugin 'Yetie::TagHelpers';

get '/submit_button';

my $t = Test::Mojo->new;

# Submit button
$t->get_ok('/submit_button')->status_is(200)->content_is(<<EOF);
<input type="submit" value="Ok">
<input type="button" value="foo">
EOF

done_testing();

__DATA__
@@ submit_button.html.ep
<%= submit_button %>
<%= submit_button 'foo', type => 'button' %>
