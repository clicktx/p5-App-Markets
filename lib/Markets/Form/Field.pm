package Markets::Form::Field;
use Mojo::Base -base;

has id => sub { $_ = shift->name; s/\./_/g; $_ };
has [qw/field_key name type label help error_message default_value value placeholder/];

# for render tags
has [qw(color email number range search tel text url)] => sub { _input(@_) };
has label_for => sub { _label(@_) };

sub _input {
    my $self = shift;

    my %attrs = %{$self};
    delete $attrs{$_} for qw/label/;

    my $method = $self->type . '_field';
    return sub { shift->$method( $self->name, id => $self->id, %attrs ) };
}

sub _label {
    my $self = shift;
    return sub {
        my $app = shift;
        $app->label_for( $self->id => $app->__( $self->label ) );
    };
}

1;

=encoding utf8

=head1 NAME

Markets::Form::Field

=head1 SYNOPSIS

    package MyForm::Field::User;
    use Markets::Form::Field;

    has_field 'name';

=head1 DESCRIPTION

=head1 SEE ALSO

=cut
