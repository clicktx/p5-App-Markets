package Markets::Controller::Catalog::LoginExample;
use Mojo::Base 'Markets::Controller::Catalog';

my @data = (
    email => 'aa@bb.com',
    'item.0.name' => 'aa',
    'item.1.name' => 'bb',
    'item.2.name' => 'cc',
);
my $item = [
    { id => 0, name => 'aa' },
    { id => 1, name => 'bb' },
    { id => 2, name => 'cc' },
];

sub index {
    my $self = shift;

    my $params = Mojo::Parameters->new( @data );
    # my $form = $self->form( 'example' => $params );
    # my $form = $self->form('example')->append_params($params);

    $self->render( item => $item );
}

sub attempt {
    my $self = shift;
    use DDP;
    # my $form = $self->form('example');

    $self->render( item => $item, template => 'login_example/index', );
}

1;
