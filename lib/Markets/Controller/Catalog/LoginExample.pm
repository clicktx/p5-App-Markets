package Markets::Controller::Catalog::LoginExample;
use Mojo::Base 'Markets::Controller::Catalog';

use Data::Dumper;
use DDP {

    # deparse => 1,
    # filters => {
    #        'DateTime' => sub { shift->ymd },
    # },
};

sub init_form {
    my ( $self, $form ) = @_;

    $form->add_field( 'name', [], ['is_example'] );
    $form->add_field(
        'password',
        [ 'trim', 'only_digits' ],
        [ 'required', { range_length => [ 4, 8 ] }, ]
    );
    $form->add_field(
        'confirm_password',
        [ 'trim', 'only_digits' ],
        [ 'required', { equal_to => 'password' }, ]
    );

    $form->add_field( 'cart.[]', ['trim'],
        [ 'required', { min_length => 6 }, { max_length => 7 }, ] );
    $form->add_field( 'item.[].no', ['trim'], ['required'] );
    $form->add_field( 'opt.type',   ['trim'], ['required'] );
    $form->add_field( 'opt.color',  ['trim'], ['required'] );

    $form->add_field( 'opt.delete', ['trim'], ['required'] );
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
        p( $self->form_errors );
        p( $form->errors );

        my $params = $self->param('login');
        p($params);
        p( $self->req->params->to_hash );
        p( $form->params );
        p( CGI::Expand->collapse_hash( $form->params ) );
    }

    $self->render(
        template => 'login_example/index',

        # login    => $form,
        # login => { name => 333, cart => [], item => [ {}, {} ], opt => {} }
        # $form->params_expand_hash
        $form->expand_hash
    );
}

1;
