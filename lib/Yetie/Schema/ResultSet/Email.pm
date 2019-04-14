package Yetie::Schema::ResultSet::Email;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub verified {
    my ( $self, $email_addr ) = @_;
    return unless $email_addr;

    $self->single( { address => $email_addr } )->update( { is_verified => 1 } );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Email

=head1 SYNOPSIS

    my $result = $schema->resultset('Email')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Email> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Email> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<verified>

    $resultset->verified( 'foo@bar.baz' );

Set is_vefified => 1.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
