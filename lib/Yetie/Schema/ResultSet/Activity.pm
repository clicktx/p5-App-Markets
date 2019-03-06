package Yetie::Schema::ResultSet::Activity;
use Mojo::Base 'Yetie::Schema::Base::ResultSet';

sub add_activity {
    my ( $self, $domain_entity ) = @_;

    my $data = _adapt_data_structure($domain_entity);
    return $self->create($data);
}

sub _adapt_data_structure {
    my $domain_entity = shift;

    my $data      = $domain_entity->to_data;
    my $type      = $domain_entity->type;
    my $target_id = delete $data->{"$type\_id"};
    $data->{"$type\_activities"} = [ { "$type\_id" => $target_id } ];
    return $data;
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Activity

=head1 SYNOPSIS

    my $result = $schema->resultset('Activity')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Activity> inherits all attributes from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Activity> inherits all methods from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<add_activity>

    my $resutl = $resultset->add_activity($domain_entity);

Return L<Yetie::Schema::Result::Activity> object.

Store activity.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Base::ResultSet>, L<Yetie::Schema>
