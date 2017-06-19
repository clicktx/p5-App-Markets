package Markets::FormExpand;

use Mojo::Base 'Mojolicious::Plugin';
use CGI::Expand qw/expand_hash/;

sub register {
    my ( $self, $app ) = @_;

    # This code from Mojolicious::Plugin::ParamExpand
    $app->hook(
        before_dispatch => sub {
            my $c = shift;
            my $hash;

            eval { $hash = expand_hash( $c->req->params->to_hash ) };
            if ($@) {

                # Mojolicious < 6.0 uses render_exception
                if ( $c->can('render_exception') ) {
                    $c->render_exception($@);
                }
                else {
                    $c->reply->exception($@);
                }

                return;
            }

            # $c->param( $_ => $hash->{$_} ) for keys %$hash;
            $c->param( 'form.fields' => $hash );

            # original params
            # my $params = $c->req->params->to_hash;
            # $c->param( $_ => $params->{$_} ) for keys %$params;
        }
    );

    $app->helper(
        field => sub {
            my ( $self, $name ) = ( shift, shift );
            return $self->stash->{'mojo.captures'}{'form.fields'}{$name} unless @_;
            $self->stash->{'mojo.captures'}{'form.fields'}{$name} = @_ > 1 ? [@_] : $_[0];
            return $self;
        }
    );
}

1;

=encoding utf8

=head1 NAME

Markets::Form - Form for Markets

=head1 DESCRIPTION

=head1 SEE ALSO

L<Mojolicious::Plugin::ParamExpand>

=cut
