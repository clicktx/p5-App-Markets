package Markets::Form::CustomFilter;
use Mojo::Base -base;

# $Validate::Tiny::FILTERS{only_digits} = sub { _only_digits(@_) };
# sub _only_digits {
#     my $val = shift // return;
#     $val =~ s/\D//g;
#     return $val;
# }
# $Validate::Tiny::FILTERS{only_digits} = sub {
#     my $val = shift // return;
#     $val =~ s/\D//g;
#     return $val;
# };

# my @filters = qw/only_digits/;
# foreach my $method (@filters) {
#     no strict 'refs';    ## no critic
#     $Validate::Tiny::FILTERS{$method} = sub { &$method(@_) };
# }
# 
# sub only_digits {
#     my $val = shift // return;
#     $val =~ s/\D//g;
#     return $val;
# }

package Validate::Tiny;
# our %FILTERS = (
#     trim    => sub { return unless defined $_[0]; $_[0] =~ s/^\s+//; $_[0] =~ s/\s+$//; $_[0]  },
#     strip   => sub { return unless defined $_[0]; $_[0] =~ s/(\s){2,}/$1/g; $_[0] },
#     lc      => sub { return unless defined $_[0]; lc $_[0] },
#     uc      => sub { return unless defined $_[0]; uc $_[0] },
#     ucfirst => sub { return unless defined $_[0]; ucfirst $_[0] },
# );
our %FILTERS = (
    %FILTERS,
    only_digits => sub { return unless defined $_[0]; $_[0] =~ s/\D//g; $_[0] },
);


1;
