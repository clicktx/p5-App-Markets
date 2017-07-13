package Markets::Controller::Admin::Preference;
use Mojo::Base 'Markets::Controller::Admin';
use CGI::Expand qw/expand_hash/;

sub index {
    my $self = shift;

    $self->stash( preferences => $self->pref->items );

    my $validation = $self->validation;
    $self->render() unless $validation->has_data;

    use DDP;
    my $form = $self->form_set('admin-preference');
    if ( $form->validate ) {

        # NOTE :
        # filter後の値は$validation->outputに格納されるため、
        # DBに保存する値は$validation->param('name')を使う必要がある

        # $form->param('name') で取得出来るようにする？
        # expand_hashの扱いはどうするか？
        # every_paramの扱いはどうするか？ name[] [name] 必ずarray_ref？（checkbox,select multiple）
        p $validation;

        for my $name ( @{ $form->params->names } ) {
            say $name, $form->param($name);
            $self->pref( $name => $form->param($name) );
        }
        p $self->pref('customer_password_max');
        say $self->pref->is_modified;
    }
    else {
        say 'validation failure!';
        p $validation;
    }

    $self->render();
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
