package Markets::Domain::Base;
use Mojo::Base -base;
use Mojo::Util ();

# Override "attr" method and "has" function of Mojo::Base
sub attr {
    my ( $self, $attrs, $value ) = @_;
    return unless ( my $class = ref $self || $self ) && $attrs;

    Carp::croak 'Default has to be a code reference or constant value'
      if ref $value && ref $value ne 'CODE';

    for my $attr ( @{ ref $attrs eq 'ARRAY' ? $attrs : [$attrs] } ) {
        Carp::croak qq{Attribute "$attr" invalid} unless $attr =~ /^[a-zA-Z_]\w*$/;

        # Very performance-sensitive code with lots of micro-optimizations
        # NOTE: Automatic update of "_is_modified" in case of setter
        if ( ref $value ) {
            Mojo::Util::monkey_patch $class, $attr, sub {
                return exists $_[0]{$attr} ? $_[0]{$attr} : ( $_[0]{$attr} = $value->( $_[0] ) )
                  if @_ == 1;
                $_[0]{_is_modified} = 1 if _is_changed( $attr, @_ );
                $_[0]{$attr} = $_[1];
                $_[0];
            };
        }
        elsif ( defined $value ) {
            Mojo::Util::monkey_patch $class, $attr, sub {
                return exists $_[0]{$attr} ? $_[0]{$attr} : ( $_[0]{$attr} = $value )
                  if @_ == 1;
                $_[0]{_is_modified} = 1 if _is_changed( $attr, @_ );
                $_[0]{$attr} = $_[1];
                $_[0];
            };
        }
        else {
            Mojo::Util::monkey_patch $class, $attr, sub {
                return $_[0]{$attr} if @_ == 1;
                $_[0]{_is_modified} = 1 if _is_changed( $attr, @_ );
                $_[0]{$attr} = $_[1];
                $_[0];
            };
        }
    }
}

sub import {
    my $class = shift;
    my $flag  = shift || '';

    # Base
    if ( $flag eq '-base' or !$flag ) { $flag = $class }
    # Module
    elsif ( ( my $file = $flag ) && !$flag->can('new') ) {
        $file =~ s!::|'!/!g;
        require "$file.pm";
    }

    # ISA
    {
        my $caller = caller;
        no strict 'refs';
        push @{"${caller}::ISA"}, $flag;
        Mojo::Util::monkey_patch $caller, 'has', sub { attr( $caller, @_ ) };

        # Add default attributes
        $caller->attr( _is_modified => 0 );
    }

    # Mojo modules are strict!
    $_->import for qw(strict warnings utf8);
    feature->import(':5.10');
}

sub _is_changed {
    my ( $attr, $obj, $value ) = @_;
    return exists $obj->{$attr} ? $obj->{$attr} eq $value ? 0 : 1 : 1;
}

1;

=encoding utf8

=head1 NAME

Markets::Domain::Entity::Base

=head1 SYNOPSIS

=head1 DESCRIPTION

Override "attr" method and "has" function of L<Mojo::Base>.
Using setter will automatically update "_is_modified" to true.

=head1 ATTRIBUTES

=head2 C<_is_modified>

=head1 FUNCTIONS

=head2 C<has>

=head1 METHODS

=head2 C<attr>

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Mojo::Base>
