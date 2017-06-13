package Markets::Controller::Admin::Preference;
use Mojo::Base 'Markets::Controller::Admin';
use CGI::Expand qw/expand_hash/;

sub index {
    my $self = shift;
    $self->render( preferences => $self->pref->items );
}

sub update {
    my $self = shift;

    my $params = $self->req->params->to_hash;
    my $hash   = expand_hash($params);

    # NOTE: Markets::Formを直してから書き直す
    my $params_pref = $hash->{pref};
    foreach my $key ( keys %{$params_pref} ) {
        $self->pref( $key => $params_pref->{$key} );
    }
    $self->service('preference')->store if $self->pref->is_modified;

    $self->template('admin/preference/index');
    $self->render( preferences => $self->pref->items );
}

1;
