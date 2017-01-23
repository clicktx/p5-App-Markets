package Markets::Model::Logic::Base;
use Mojo::Base 'MojoX::Model';

sub do {
    my ($self) = @_;
    # say "logic->do";
}

1;
__END__

=head1 NAME

Markets::Model::Logic::Base

=head1 SYNOPSIS

Your model

    package Markets::Model::Logic::Base;
    use Mojo::Base 'MojoX::Model';

    sub do {
      my ($self) = @_;
      say "do";
    }

Your app

    sub startup {
        my $self = shift;

        $self->plugin( Model => {
            namespaces   => ['Markets::Model', 'MyApp::CLI::Model'],
            base_classes => ['MyApp::Model'],
            default      => 'MyApp::Model::Pg',
            params => {Pg => {uri => 'postgresql://user@/mydb'}}
        });
        ...

App Controller.
Camel case or Module name.

    package Markets::Controller::Catalog::Example;
    use Mojo::Base 'Markets::Controller::Catalog';

    sub welcome {
        my $self = shift;

        # model
        $self->app->model('logic-base')->do;
        # or
        $self->app->model('Logic::Base')->do;
    }

=head1 DESCRIPTION

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Mojolicious::Plugin::Model> L<MojoX::Model>
