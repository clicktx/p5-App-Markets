package Markets::Model::Common;
use Mojo::Base 'Markets::Model';

sub dbic_txn_failed {
    my ( $self, $err ) = @_;

    if ( $err =~ /Rollback failed/ ) {

        # ロールバックに失敗した場合
        $self->app->log->fatal($err);
        die $err;
    }
    else {
        # 何らかのエラーによりロールバックした
        $self->app->log->warn($err);
        warn $err;
    }
}

1;
__END__

=head1 NAME

Markets::Model::Common

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 C<dbic_txn_failed>

    use Try::Tiny;
    ...
    try {
        $schema->txn_do($cb);
    } catch {
        $c->model('common')->dbic_txn_failed($_);
    }
    ...

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Model> L<Mojolicious::Plugin::Model> L<MojoX::Model>
