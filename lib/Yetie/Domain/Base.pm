package Yetie::Domain::Base;
use Carp qw();
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
            my $sub = sub {
                return exists $_[0]{$attr} ? $_[0]{$attr} : ( $_[0]{$attr} = $value->( $_[0] ) )
                  if @_ == 1;
                $_[0]{_is_modified} = 1 if _is_changed( $attr, @_ );
                $_[0]{$attr} = $_[1];
                $_[0];
            };
            Mojo::Util::monkey_patch( $class, $attr, $sub );
        }
        elsif ( defined $value ) {
            my $sub = sub {
                return exists $_[0]{$attr} ? $_[0]{$attr} : ( $_[0]{$attr} = $value )
                  if @_ == 1;
                $_[0]{_is_modified} = 1 if _is_changed( $attr, @_ );
                $_[0]{$attr} = $_[1];
                $_[0];
            };
            Mojo::Util::monkey_patch( $class, $attr, $sub );
        }
        else {
            my $sub = sub {
                return $_[0]{$attr} if @_ == 1;
                $_[0]{_is_modified} = 1 if _is_changed( $attr, @_ );
                $_[0]{$attr} = $_[1];
                $_[0];
            };
            Mojo::Util::monkey_patch( $class, $attr, $sub );
        }
    }
}

sub import {
    my ( $class, $caller ) = ( shift, caller );
    my @flags = @_ ? @_ : ('');

    # Base
    if ( $flags[0] eq '-base' or !$flags[0] ) { $flags[0] = $class }

    # Role
    if ( $flags[0] eq '-role' ) {
        Carp::croak 'Role::Tiny 2.000001+ is required for roles' unless Mojo::Base->ROLES;
        Mojo::Util::monkey_patch( $caller, 'has', sub { attr( $caller, @_ ) } );
        eval "package $caller; use Role::Tiny; 1" or die $@;
    }

    # Module and not -strict
    elsif ( $flags[0] !~ /^-/ ) {
        no strict 'refs';
        require( Mojo::Util::class_to_path( $flags[0] ) ) unless $flags[0]->can('new');
        push @{"${caller}::ISA"}, $flags[0];
        Mojo::Util::monkey_patch( $caller, 'has', sub { attr( $caller, @_ ) } );
    }

    # Add default attributes
    $caller->attr( _is_modified => 0 );

    # Mojo modules are strict!
    $_->import for qw(strict warnings utf8);
    feature->import(':5.10');

    # Signatures (Perl 5.20+)
    if ( ( $flags[1] || '' ) eq '-signatures' ) {
        Carp::croak 'Subroutine signatures require Perl 5.20+' if $] < 5.020;
        require experimental;
        experimental->import('signatures');
    }
}

sub new {
    my $class = shift;
    $class = ref $class || $class;

    my $args = @_ ? @_ > 1 ? {@_} : { %{ $_[0] } } : {};

    my $params = {};
    foreach my $key ( keys %{$args} ) {
        if ( $class->can($key) ) { $params->{$key} = $args->{$key} }
        else                     { Carp::croak "$class has not '$key' attribute" }
    }
    bless $params, $class;
}

sub _is_changed {
    my ( $attr, $obj, $value ) = ( shift, shift, shift // '' );
    $obj->{$attr} = '' unless defined $obj->{$attr};    # undef to ''
    return exists $obj->{$attr} ? $obj->{$attr} eq $value ? 0 : 1 : 1;
}

1;

=encoding utf8

=head1 NAME

Yetie::Domain::Base

=head1 SYNOPSIS

=head1 DESCRIPTION

Override "attr" method and "has" function of L<Mojo::Base>.
Using setter will automatically update "_is_modified" to true.

=head1 FUNCTIONS

L<Yetie::Domain::Base> inherits all functions from L<Mojo::Base> and implements
the following new ones.

=head1 ATTRIBUTES

L<Yetie::Domain::Base> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Base> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Mojo::Base>
