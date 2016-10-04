package Markets::Web::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';
use Markets::Form;

use Data::Dumper;

sub _init_form {
    my $self = shift;

    my $form = Markets::Form->new;
    $form->add_param(
        'name' => '',
        $self->__('hello'), 111, ['validations'], ['filters']
    );
    $form->add_param('password');
    $form;
}

sub index {
    my $self = shift;

    my $form = $self->_init_form;
    say Dumper $form;
    say $form->params;

    $self->render( login => $form );
}

sub attempt {
    my $self = shift;

    my $form = $self->_init_form;
    my $f    = $self->fields('login');

    # Filters
    $f->filter( 'password', 'trim', 'only_digits' );

    # Varidations
    $f->is_required('name');
    $f->is_required('password');

    # $f->_field('name')
    #   ->check( sub { $_[0] =~ /^sshaw$/ ? undef : 'Not sshaw' } );

    use DDP {};
    if ( $self->form_valid ) {
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
