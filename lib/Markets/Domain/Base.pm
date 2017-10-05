package Markets::Domain::Base;
use Carp qw(croak);
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
    my ( $class, $flag ) = ( shift, shift // '' );

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

sub new {
    my $class = shift;
    $class = ref $class || $class;

    my $args = @_ ? @_ > 1 ? {@_} : { %{ $_[0] } } : {};

    my $params = {};
    foreach my $key ( keys %{$args} ) {
        if ( $class->can($key) ) { $params->{$key} = $args->{$key} }
        else                     { croak "$class has not '$key' attribute" }
    }
    bless $params, $class;
}

sub _is_changed {
    my ( $attr, $obj, $value ) = @_;
    $obj->{$attr} = '' unless defined $obj->{$attr};    # undef to ''
    return exists $obj->{$attr} ? $obj->{$attr} eq $value ? 0 : 1 : 1;
}

1;

=encoding utf8

=head1 NAME

Markets::Domain::Base

=head1 SYNOPSIS

=head1 DESCRIPTION

Override "attr" method and "has" function of L<Mojo::Base>.
Using setter will automatically update "_is_modified" to true.

=head1 FUNCTIONS

=head2 C<has>

=head1 ATTRIBUTES

L<Markets::Domain::Base> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Base> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<attr>

=head2 C<new>

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Mojo::Base>
