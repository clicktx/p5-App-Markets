package Markets::Plugin::Form::CustomVaridations;
use Mojo::Base -base;

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
