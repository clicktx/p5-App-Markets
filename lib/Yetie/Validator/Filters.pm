package Yetie::Validator::Filters;
use Mojo::Base 'Mojolicious::Plugin';
use Lingua::JA::Regular::Unicode qw();

my @filters = qw(
  double_byte_char hyphen space
);

sub register {
    my ( $self, $app ) = @_;
    $app->validator->add_filter( $_ => \&{ '_' . $_ } ) for @filters;
}

sub _double_byte_char {
    my ( $validation, $name, $value ) = @_;
    return unless defined($value);

    return Lingua::JA::Regular::Unicode::alnum_z2h($value);
}

# NOTE: [Unicodeにあるハイフン/マイナス/長音符/波線/チルダのコレクション | hydroculのメモ](https://hydrocul.github.io/wiki/blog/2014/1101-hyphen-minus-wave-tilde.html)
# [ハイフンに似てる文字の文字コード - Qiita](https://qiita.com/ryounagaoka/items/4cf5191d1a2763667add)
# [404 Blog Not Found:Unicode - 似た文字同士にご用心](http://blog.livedoor.jp/dankogai/archives/51043693.html)
# U+02D7    ˗   MODIFIER LETTER MINUS SIGN
# U+2010    ‐   HYPHEN
# U+2011    ‑   NON-BREAKING HYPHEN
# U+2012    ‒   FIGURE DASH
# U+2013    –   EN DASH
# U+2014    —   EM DASH
# U+2015    ―   HORIZONTAL BAR
# U+2500    ─   BOX DRAWINGS LIGHT HORIZONTAL
# U+2501    ━   BOX DRAWINGS HEAVY HORIZONTAL
# U+2212    −   MINUS SIGN
# U+30FC    ー  KATAKANA-HIRAGANA PROLONGED SOUND MARK
# U+FE58    ﹘  SMALL EM DASH
# U+FE63    ﹣  SMALL HYPHEN-MINUS
# U+FF0D    －  FULLWIDTH HYPHEN-MINUS
# U+FF70    ｰ   HALFWIDTH KATAKANA-HIRAGANA PROLONGED SOUND MARK
sub _hyphen {
    my ( $validation, $name, $value ) = @_;
    return unless defined($value);

    $value =~ s/[\x{02D7}\x{2010}-\x{2015}\x{2212}\x{2500}-\x{2501}\x{30FC}\x{FE58}\x{FE63}\x{FF0D}\x{FF70}]/-/g;
    return $value;
}

# U+3000    　   IDEOGRAPHIC SPACE
sub _space {
    my ( $validation, $name, $value ) = @_;
    return unless defined($value);

    $value = Lingua::JA::Regular::Unicode::space_z2h($value);
    $value =~ s/\s+/ /g;
    return $value;
}

1;
__END__
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


=encoding utf8

=head1 NAME

Yetie::Validator::Filters

=head1 SYNOPSIS

    # Mojolicious
    $app->plugin('Yetie::Validator::Filters');

    # Mojolicious::Lite
    plugin 'Yetie::Validator::Filters';


=head1 DESCRIPTION



=head1 METHODS

L<Yetie::Validator::Filters> inherits all methods from L<Mojolicious::Plugin> and implements
the following new ones.

=head1 SEE ALSO

L<Yetie::Validator>, L<Lingua::JA::Regular::Unicode>, L<Mojolicious::Plugin>

=cut
