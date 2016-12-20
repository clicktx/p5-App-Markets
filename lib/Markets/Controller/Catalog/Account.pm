package Markets::Controller::Catalog::Account;
use Mojo::Base 'Markets::Controller';
use Data::Dumper;

sub auth {
    my $self = shift;
    say "auth";
    my $session = $self->markets_session;
    say Dumper $session;
    $self->redirect_to('/login') and return 0 unless 1;
    return 1;
}

1;
