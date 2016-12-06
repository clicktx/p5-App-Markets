package Markets::Addon::Newpage::Example;
use Mojo::Base 'Markets::Controller';
use Data::Dumper;

# This action will render a template
sub welcome {
    my $self = shift;
    say "Controller: " . __PACKAGE__;
# push @{$self->app->renderer->classes}, 'Markets::Addon::Newpage';

    $self->render(
        # template => 'example/welcome',
        msg => 'Welcome to the new page!' );
}

1;
