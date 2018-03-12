package Yetie::Schema::Result::Category;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

__PACKAGE__->load_components(qw( Tree::NestedSet ));

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column root_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column lft => {
    data_type   => 'INT',
    is_nullable => 0,
};

column rgt => {
    data_type   => 'INT',
    is_nullable => 0,
};

column level => {
    data_type   => 'INT',
    is_nullable => 0,
};

column title => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

has_many
  products => 'Yetie::Schema::Result::Product::Category',
  { 'foreign.category_id' => 'self.id' },
  { cascade_delete        => 0 };

# NOTE: 下記に書いた場合deploy_schema時にテーブル作成に失敗する（relation設定によるもの？）
#       tree_columnsを呼ばないとapplicationで動かないため、App::Commonで読み込む。
# __PACKAGE__->tree_columns(
#     {
#         root_column  => 'root_id',
#         left_column  => 'lft',
#         right_column => 'rgt',
#         level_column => 'level',
#     }
# );

# Add Index
sub sqlt_deploy_hook {
    my ( $self, $sqlt_table ) = @_;

    $sqlt_table->add_index( name => 'idx_root_id', fields => ['root_id'] );
    $sqlt_table->add_index( name => 'idx_level',   fields => ['level'] );
}

sub descendant_ids {
    my $self = shift;

    my @rs = $self->result_source->resultset->search(
        { root_id => $self->root_id, lft => { '>' => $self->lft }, rgt => { '<' => $self->rgt } } );
    my @ids = map { $_->id } @rs;
    unshift @ids, $self->id;

    return wantarray ? @ids : \@ids;
}

# search_related with special handling for relationships
sub search_related {
    my ( $self, $rel, $cond, @rest ) = @_;

    my $columns = [qw( me.id me.root_id me.level me.title)];
    push @rest, { columns => $columns, order_by => 'me.lft' };
    return $self->next::method( $rel, $cond, @rest );
}
*search_related_rs = \&search_related;

sub to_data {
    my ( $self, $options ) = @_;

    my $data = {
        id      => $self->id,
        level   => $self->level,
        root_id => $self->root_id,
        title   => $self->title,
    };

    # Options
    $data->{children} = $self->children->to_data unless $options->{no_children};

    return $data;
}

sub to_breadcrumbs {
    my $self = shift;
    my $app  = $self->schema->app;

    # Ancestors category
    my @breadcrumbs;
    $self->ancestors->each( sub { push @breadcrumbs, $_->_breadcrumb } );

    # Current category
    my $current = $self->_breadcrumb;
    $current->{class} = 'current';
    push @breadcrumbs, $current;

    return \@breadcrumbs;
}

sub _breadcrumb {
    my $self = shift;
    return {
        title => $self->title,
        url   => $self->schema->app->url_for( 'RN_category', category_id => $self->id ),
    };
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::Result::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::Result::Category> inherits all attributes from L<Yetie::Schema::Base::Result> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::Result::Category> inherits all methods from L<Yetie::Schema::Base::Result>
and L<DBIx::Class::Tree::NestedSet> and implements the following new ones.

=head2 C<descendant_ids>

    my $category->find($category_id);

    my @ids = $category->descendant_ids;
    my $ids = $category->descendant_ids;

Return Array or Array refference.

NOTE: return values includes C<me.id> in addition to descendant ids.

=head2 C<search_related>

Getting columns is C<id, root_id, level, title>

See L<DBIx::Class::Tree::NestedSet/search_related>.

=head2 C<to_data>

    my $hashref = $result->to_data;

I<OPTIONS>

=over

=item * no_children

    my $data = $result->to_data( { no_children => 1 } );

Set to C<true>, returns value does not include C<children>.

=back

=head2 C<to_breadcrumbs>

    my $tree = $result->to_breadcrumbs;

Return C<Array reference>.

    [
        {
            title   => '',
            url     => Mojo::URL,
        },
        ...
        {
            class   => 'current',
            title   => '',
            url     => Mojo::URL,
        }
    ]

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<DBIx::Class::Tree::NestedSet>, L<Yetie::Schema::Base::Result>, L<Yetie::Schema>
