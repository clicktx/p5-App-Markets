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

    # $form->add_field( 'name', int, ['filters'], ['validations'] );
    # $form->add_filter('name', [], [], [{is_long_between => []}]);
    
    $form->add_field( 'name', 100, [], ['is_required'] );
    $form->add_field(
        'password',
        [ 8,      256 ],
        [ 'trim', 'only_digits' ],
        ['is_example']
    );
    $form->add_field(
        'confirm_password',
        [ 8,      256 ],
        [ 'trim', 'only_digits' ],
        ['is_required']
    );
    $form;
}

sub index {
    my $self = shift;

    my $form = $self->_init_form;

    # Set default value
    $form->default_value( 'name', 'default_value' );

    p($form);

    say Dumper $form->names;

    $self->render( login => $form );
}

sub attempt {
    my $self = shift;

    my $form = $self->_init_form;
    # my $f    = $self->fields('login');

    # Varidations
    # $f->is_required('name');
    # $f->is_required('password');

    if ( $form->valid ) {
    # if ( $self->form_valid ) {
        say "ok";
        my $param = $self->param('login');
        p($param);
        return $self->redirect_to('/');
    }
    else {
        say "!!!!!!!!!!!!!!!!!!!error!!!!!!!!!!!!!!";
        say Dumper $self->form_errors;
        my $params = $self->param('login');
        p($params);
        p( $self->req->params->to_hash );
    }

    $self->render(
        template => 'login/index',
        login    => $form,
    );
}

1;
