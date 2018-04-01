use Mojo::Base -strict;

use Test::More;
use Mojo::DOM;
use Yetie::View::DOM;

# EP tag(basics)
my $dom = Mojo::DOM->new(<<EOF);
% layout 'default';
% title 'Welcome';
This text
<%= \$msg %>
<% print "a" %>
<%== \$msg %>
<%= link_to '/' => begin %>
  top
<% end %>
<a href="<%= url_for %>">link</a>
% my \$selected = 'selected';
<option <%= \$selected %>>2</option>
<div <%= class %> <%= style %>>
    content
</div>
EOF
is $dom->tree->[0], 'root', 'right type';
is $dom->tree->[1][0],  'ep_line',                   'right type';
is $dom->tree->[1][1],  "% layout 'default';",       'right line';
is $dom->tree->[2][0],  'text',                      'right type';
is $dom->tree->[2][1],  "\n",                        'right line';
is $dom->tree->[3][0],  'ep_line',                   'right type';
is $dom->tree->[3][1],  "% title 'Welcome';",        'right line';
is $dom->tree->[4][0],  'text',                      'right type';
is $dom->tree->[4][1],  "\nThis text\n",             'right text';
is $dom->tree->[5][0],  'ep_tag',                    'right type';
is $dom->tree->[5][1],  '= $msg ',                   'right tag';
is $dom->tree->[6][0],  'text',                      'right type';
is $dom->tree->[6][1],  "\n",                        'right line';
is $dom->tree->[7][0],  'ep_tag',                    'right type';
is $dom->tree->[7][1],  ' print "a" ',               'right tag';
is $dom->tree->[8][0],  'text',                      'right type';
is $dom->tree->[8][1],  "\n",                        'right line';
is $dom->tree->[9][0],  'ep_tag',                    'right type';
is $dom->tree->[9][1],  '== $msg ',                  'right tag';
is $dom->tree->[10][0], 'text',                      'right type';
is $dom->tree->[10][1], "\n",                        'right line';
is $dom->tree->[11][0], 'ep_tag',                    'right type';
is $dom->tree->[11][1], '= link_to \'/\' => begin ', 'right tag';
is $dom->tree->[12][0], 'text',                      'right type';
is $dom->tree->[12][1], "\n  top\n",                 'right tag';
is $dom->tree->[13][0], 'ep_tag',                    'right type';
is $dom->tree->[13][1], ' end ',                     'right tag';
is $dom->tree->[14][0], 'text',                      'right type';
is $dom->tree->[14][1], "\n",                        'right line';
is $dom->tree->[15][0], 'tag',                       'right type';
is $dom->tree->[15][1], 'a',                         'right tag';
is_deeply $dom->tree->[15][2], { href => '<%= url_for %>' }, 'right attr';
is $dom->tree->[16][0], 'text',                           'right type';
is $dom->tree->[16][1], "\n",                             'right line';
is $dom->tree->[17][0], 'ep_line',                        'right type';
is $dom->tree->[17][1], '% my $selected = \'selected\';', 'right tag';
is $dom->tree->[18][0], 'text',                           'right type';
is $dom->tree->[18][1], "\n",                             'right line';
is $dom->tree->[19][0], 'tag',                            'right type';
is $dom->tree->[19][1], 'option',                         'right tag';
is $dom->tree->[19][2]->{'<%= url_for %>'}, undef, 'right attr';
is $dom->tree->[20][0], 'text', 'right type';
is $dom->tree->[20][1], "\n",   'right line';
is $dom->tree->[21][0], 'tag',  'right type';
is $dom->tree->[21][1], 'div',  'right tag';
is $dom->tree->[21][2]->{'<%= class %>'}, undef, 'right attr';
is $dom->tree->[21][2]->{'<%= style %>'}, undef, 'right attr';

done_testing();
