use Mojo::Base -strict;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;

plugin 'Yetie::TagHelpers';

get '/button';

get '/submit_button';

my $t = Test::Mojo->new;

# Submit button
$t->get_ok('/button')->status_is(200)->content_is(<<EOF);
<button name="foo" type="submit">Ok</button>
<button name="foo" type="button">Ok</button>
<button name="foo" type="submit">bar</button>
<button name="foo" type="button">bar</button>
<button name="foo" type="button" value="1">bar</button>
<button name="foo" type="submit">
bar
</button>
<button name="foo" type="button">
bar
</button>
<button name="foo" type="button" value="1">
bar
</button>
EOF

# Submit button
$t->get_ok('/submit_button')->status_is(200)->content_is(<<EOF);
<input type="submit" value="Ok">
<input type="button" value="foo">
EOF

done_testing();

__DATA__
@@ button.html.ep
<%= button 'foo' %>
<%= button 'foo', type => 'button' %>
<%= button 'foo' => 'bar' %>
<%= button 'foo' => 'bar', type => 'button' %>
<%= button 'foo' => 'bar', type => 'button', value => 1 %>
<%= button 'foo' => begin %>
bar
<% end %>
<%= button 'foo' => ( type => 'button' ) => begin %>
bar
<% end %>
<%= button 'foo' => ( type => 'button', value => 1 ) => begin %>
bar
<% end %>

@@ submit_button.html.ep
<%= submit_button %>
<%= submit_button 'foo', type => 'button' %>
