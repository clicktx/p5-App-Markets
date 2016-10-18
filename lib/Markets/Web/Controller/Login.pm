package Markets::Web::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;
use DDP {

    # deparse => 1,
    # filters => {
    #        'DateTime' => sub { shift->ymd },
    # },
};

sub _init_form {
    my $self = shift;

    # my $form = $self->form('login'); or
    my $form = $self->form->fields('login');

    $form->add_field( 'name', 100, [], ['is_example'] );
    $form->add_field(
        'password',
        [ 8,      256 ],
        [ 'trim', 'only_digits' ],
        ['is_required']
    );
    $form->add_field(
        'confirm_password', [ 8, 256 ],
        [ 'trim', 'only_digits' ], ['is_required']
    );

    $form->add_field( 'cart.[]',    [], ['trim'], ['is_required'] );
    $form->add_field( 'item.[].no', [], ['trim'], ['is_required'] );
    $form->add_field( 'opt.type',   [], ['trim'], ['is_required'] );
    $form->add_field( 'opt.color',  [], ['trim'], ['is_required'] );

    $form;
}

sub index {
    my $self = shift;

    my $form = $self->_init_form;

    # Set default value
    $form->default_value( 'name', 'default_value' );

    p($form);

    say Dumper $form->names;

    # $self->render( login => $form );
    $self->render( $form->to_hash );
}

sub attempt {
    my $self = shift;

    my $form = $self->_init_form;
    if ( $form->valid ) {
        say "ok";
        p( $form->params );

        # return $self->redirect_to('/');
    }
    else {
        say "!!!!!!!!!!!!!!!!!!!error!!!!!!!!!!!!!!";
        say Dumper $self->form_errors;
        say Dumper $form->errors;
        say Dumper $form->errors('name');

        my $params = $self->param('login');
        p($params);
        p( $self->req->params->to_hash );
        p( $form->params );
        p( CGI::Expand->collapse_hash( $form->params ) );
    }

    $self->render(
        template => 'login/index',

        # login    => $form,
        # login => {}
        $form->to_hash
    );
}

1;
