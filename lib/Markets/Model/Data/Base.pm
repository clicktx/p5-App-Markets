package Markets::Model::Data::Base;
use Mojo::Base 'MojoX::Model';

sub do {
    my ($self) = @_;
    say "data->do";
}

1;
