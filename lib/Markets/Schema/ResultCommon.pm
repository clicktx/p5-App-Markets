package Markets::Schema::ResultCommon;
use Mojo::Base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

1;
