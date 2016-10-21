package Markets::Plugin::Form::CustomVaridation;
use Mojo::Base -base;

has c          => sub { shift->{c} };
has formfields => sub { shift->{formfields} };

sub length_between {
    my ( $self, $name, $min, $max, $err_msg ) = @_;
    $err_msg ||= $self->c->__x( 'Must be between {min} and {max} symbols',
        { min => $min, max => $max } );
    $self->formfields->is_long_between( $name, $min, $max, $err_msg );
}

# use Mojo::Util qw/monkey_patch/;
# monkey_patch 'Validate::Tiny', is_example => sub {
#     say "is_example";
#     return sub {};
# };
# sub Validate::Tiny::is_example {
#     say "is_example";
#     return sub { };
# }

# use Mojo::Util qw/monkey_patch/;
#
# my @validations = qw/is_example/;
#
# foreach my $method (@validations) {
#     no strict 'refs';    ## no critic
#     monkey_patch 'Validate::Tiny', "$method" => sub { &$method(@_) };
# }
#
# sub is_example {
#     say "is_example";
#     my $err_msg = shift || 'This is example validation';
#     return sub {
#         return if defined $_[0] && $_[0] ne '';
#         return $err_msg;
#     };
# }

package Validate::Tiny;

sub is_example {
    say "is_example";
    my $err_msg = shift || 'This is example validation';
    return sub {
        return if defined $_[0] && $_[0] ne '';
        return $err_msg;
    };
}

1;
