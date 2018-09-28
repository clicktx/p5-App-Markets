package Yetie::Controller::Catalog::LoginExample;
use Mojo::Base 'Yetie::Controller::Catalog';

my @data = (
    email         => 'aa@bb.com',
    'item.0.name' => 'aa',
    'item.1.name' => 'bb',
    'item.2.name' => 'cc',
);
my $item = [ { id => 0, name => 'aa' }, { id => 1, name => 'bb' }, { id => 2, name => 'cc' }, ];

sub index {
    my $c = shift;

    $c->stash( item => $item );

    my $form = $c->form('example');
    return $c->render() unless $form->has_data;

    use DDP;
    my $validation = $c->validation;
    if ( $form->do_validate ) {

        # NOTE :
        # filter後の値は$validation->outputに格納されるため、
        # DBに保存する値は$validation->param('name')を使う必要がある

        # $form->param('name') で取得出来るようにする？
        # expand_hashの扱いはどうするか？
        # every_paramの扱いはどうするか？ name[] [name] 必ずarray_ref？（checkbox,select multiple）
        p $validation;
    }
    else {
        say 'validation failure!';
        p $validation;
    }

    $c->render();
}

package Yetie::Controller::Catalog::LoginExample::Before;
use Mojo::Base 'Yetie::Controller::Catalog';

use Data::Dumper;
use DDP {

    # deparse => 1,
    # filters => {
    #        'DateTime' => sub { shift->ymd },
    # },
};

sub init_form {
    my ( $c, $form ) = @_;

    $form->add_field( 'name', [], ['is_example'] );
    $form->add_field( 'password', [ 'trim', 'only_digits' ], [ 'required', { range_length => [ 4, 8 ] }, ] );
    $form->add_field( 'confirm_password', [ 'trim', 'only_digits' ], [ 'required', { equal_to => 'password' }, ] );

    $form->add_field( 'cart.[]', ['trim'], [ 'required', { min_length => 6 }, { max_length => 7 }, ] );
    $form->add_field( 'item.[].no', ['trim'], ['required'] );
    $form->add_field( 'opt.type',   ['trim'], ['required'] );
    $form->add_field( 'opt.color',  ['trim'], ['required'] );

    $form->add_field( 'opt.delete', ['trim'], ['required'] );
    $form->remove_field('opt.delete');
}

sub index {
    my $c = shift;

    my $form = $c->form('login');    #or
                                        # my $form = $c->form->fields('login');
    $c->init_form($form);

    # Set default value
    $form->default_value( 'name',      'default_value' );
    $form->default_value( 'cart.0',    'cart0' );
    $form->default_value( 'cart.2',    'cart2' );
    $form->default_value( 'item.0.no', 33 );
    $form->default_value( 'item.1.no', 55 );
    $form->default_value( 'opt.type',  'tablet' );
    $form->default_value( 'opt.color', 'red' );
    p($form);

    # $c->render( login => $form );
    # $c->render( $form->default_value );
    $c->render( $form->expand_hash );
}

sub attempt {
    my $c = shift;

    my $form = $c->form('login');
    $c->init_form($form);

    if ( $form->valid ) {
        say "ok";
        p( $form->params );

        # return $c->redirect_to('/');
    }
    else {
        say "!!!!!!!!!!!!!!!!!!!error!!!!!!!!!!!!!!";
        p( $c->form_errors );
        p( $form->errors );

        my $params = $c->param('login');
        p($params);
        p( $c->req->params->to_hash );
        p( $form->params );
        p( CGI::Expand->collapse_hash( $form->params ) );
    }

    $c->render(
        template => 'login_example/index',

        # login    => $form,
        # login => { name => 333, cart => [], item => [ {}, {} ], opt => {} }
        # $form->params_expand_hash
        $form->expand_hash
    );
}

1;
