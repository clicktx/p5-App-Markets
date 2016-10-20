package Markets::Web::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;
use DDP {

    # deparse => 1,
    # filters => {
    #        'DateTime' => sub { shift->ymd },
    # },
};

sub init_form {
    my ( $self, $form ) = @_;

    $form->add_field( 'name', 100, [], ['is_example'] );
    $form->add_field(
        'password',
        [ 8,      256 ],
        [ 'trim', 'only_digits' ],
        [
            'is_required',
            { is_long_between => [ 4, 8 ] },
            { is_equal        => ['confirm_password'] },
        ]
    );
    $form->add_field(
        'confirm_password', [ 8, 256 ],
        [ 'trim', 'only_digits' ], ['is_required']
    );

    $form->add_field( 'cart.[]',    [], ['trim'], ['is_required'] );
    $form->add_field( 'item.[].no', [], ['trim'], ['is_required'] );
    $form->add_field( 'opt.type',   [], ['trim'], ['is_required'] );
    $form->add_field( 'opt.color',  [], ['trim'], ['is_required'] );

    $form->add_field( 'opt.delete', [], ['trim'], ['is_required'] );
    $form->remove_field('opt.delete');
}

sub index {
    my $self = shift;

    my $form = $self->form('login');  #or
                                      # my $form = $self->form->fields('login');
    $self->init_form($form);

    # Set default value
    $form->default_value( 'name',      'default_value' );
    $form->default_value( 'cart.0',    'cart0' );
    $form->default_value( 'cart.2',    'cart2' );
    $form->default_value( 'item.0.no', 33 );
    $form->default_value( 'item.1.no', 55 );
    $form->default_value( 'opt.type',  'tablet' );
    $form->default_value( 'opt.color', 'red' );
    p($form);

    # $self->render( login => $form );
    # $self->render( $form->default_value );
    $self->render( $form->expand_hash );
}

sub attempt {
    my $self = shift;

    my $form = $self->form('login');
    $self->init_form($form);

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
        # login => { name => 333, cart => [], item => [ {}, {} ], opt => {} }
        # $form->params_expand_hash
        $form->expand_hash
    );
}

1;
