package Markets::Model::Common;
use Mojo::Base 'Markets::Model';
use Try::Tiny;

has resultset_pref => sub { shift->app->schema->resultset('Preference') };

sub load_pref {
    my $self = shift;

    my $pref = $self->app->defaults('pref') || {};
    return $pref if %$pref;

    # Load from DB
    my $rs = $self->resultset_pref->search;
    while ( my $row = $rs->next ) {
        $pref->{ $row->key_name } = $row->value ? $row->value : $row->default_value;
    }

    $self->app->defaults( pref => $pref );
    return $pref;
}

sub pref {
    my $self = shift;

    my $pref = $self->load_pref;
    return @_ > 1 ? $self->_store_pref(@_) : @_ ? $pref->{ $_[0] } : $pref;
}

sub reload_pref {
    my $self = shift;
    $self->app->defaults( pref => {} );
    $self->load_pref;
}

sub _store_pref {
    my $self = shift;
    return undef if @_ == 0 || @_ % 2;

# DB更新
# keyは必ず存在している必要がある。複数更新時は全てのkeyが存在している必要がある。
    my $rs   = $self->resultset_pref;
    my %pref = @_;
    my $cb   = sub {
        my $cnt = 0;
        foreach my $key ( keys %pref ) {
            $rs->search( { key_name => $key } )->update( { value => $pref{$key} } ) < 1
              ? $self->app->log->error("Don't update preference. '$key' is not found.")
              : $cnt++;
        }
        $cnt;
    };

    return 0
      unless try { $self->app->schema->txn_do($cb) }
    catch {
        $self->app->log->error( "Don't update preference. " . $_ );
        return 0;
    };

    $self->app->defaults('pref')->{$_} = $pref{$_} for keys %pref;
    return 1;
}

1;
__END__

=head1 NAME

Markets::Model::Common

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 C<load_pref>

    my $preferences = $app->model('common')->load_pref;

Return %$preferences

=head2 C<pref>

    # Getter
    my $preferences = $app->pref;
    my $pref = $app->pref('pref_key');

    # Setter
    $app->pref( pref_key => 'pref_value', pref_key2 => 'pref_value2', ... );

Get/Set preference.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Model> L<Mojolicious::Plugin::Model> L<MojoX::Model>
