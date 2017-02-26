package Markets::View::EPLRenderer;
use Mojo::Base 'Mojolicious::Plugin';

use Mojo::Template;
use Mojo::Util qw(encode md5_sum monkey_patch decode);
use Carp 'croak';

monkey_patch 'Mojo::Template', render_file_after_hook => sub {
    my ( $self, $c, $template_file_path ) = ( shift, shift, shift );

    $self->name($template_file_path) unless defined $self->{name};
    my $template_source = Mojo::File::path($template_file_path)->slurp;

    # emit filter. This filter was used to addons.
    $c->app->addons->action_hook->emit(
        action_replace_template => $c,
        $template_file_path, \$template_source,
    );

    my $encoding = $self->encoding;
    croak qq{Template "$template_file_path" has invalid encoding}
      if $encoding
      && !defined( $template_source = decode $encoding, $template_source );

    return $self->render( $template_source, @_ );
};

sub register {
    my ( $self, $app ) = @_;
    $app->renderer->add_handler( epl => sub { _render( @_, Mojo::Template->new, $_[1] ) } );
}

sub _render {
    my ( $renderer, $c, $output, $options, $mt, @args ) = @_;

    # Cached
    if ( $mt->compiled ) {
        $c->app->log->debug("Rendering cached @{[$mt->name]}");
        $$output = $mt->process(@args);
    }

    # Not cached
    else {
        my $inline = $options->{inline};
        my $name = defined $inline ? md5_sum encode( 'UTF-8', $inline ) : undef;
        return unless defined( $name //= $renderer->template_name($options) );

        # Inline
        if ( defined $inline ) {
            $c->app->log->debug(qq{Rendering inline template "$name"});
            $$output = $mt->name(qq{inline template "$name"})->render( $inline, @args );
        }

        # File
        else {
            if ( my $encoding = $renderer->encoding ) {
                $mt->encoding($encoding);
            }

            # Try template
            if ( defined( my $template_file_path = $renderer->template_path($options) ) ) {
                $c->app->log->debug(qq{Rendering template "$name"});
                $$output =
                  $mt->name(qq{template "$name"})
                  ->render_file_after_hook( $c, $template_file_path, @args );
            }

            # Try DATA section
            elsif ( defined( my $d = $renderer->get_data_template($options) ) ) {
                $c->app->log->debug(qq{Rendering template "$name" from DATA section});
                $$output = $mt->name(qq{template "$name" from DATA section})->render( $d, @args );
            }

            # No template
            else { $c->app->log->debug(qq{Template "$name" not found}) }
        }
    }

    # Exception
    die $$output if ref $$output;
}

1;

=encoding utf8

=head1 NAME

Markets::Renderer::EPLRenderer - Embedded Perl Lite renderer plugin

=head1 SYNOPSIS

  # Mojolicious
  $app->plugin('Markets::Renderer::EPLRenderer');

  # Mojolicious::Lite
  plugin 'Markets::Renderer::EPLRenderer';

=head1 DESCRIPTION

forked from L<Mojolicious::Plugin::EPLRenderer> Mojolicious v6.64

L<Markets::Renderer::EPLRenderer> is a renderer for C<epl> templates, which
are pretty much just raw L<Mojo::Template>.

This is a core plugin, that means it is always enabled and its code a good
example for learning to build new plugins, you're welcome to fork it.

See L<Mojolicious::Plugins/"PLUGINS"> for a list of plugins that are available
by default.

=head1 METHODS

L<Markets::Renderer::EPLRenderer> inherits all methods from
L<Markets::Renderer> and implements the following new ones.

=head2 C<register>

  $plugin->register(Mojolicious->new);

Register renderer in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=cut
