use strict;
use warnings;

use Test::Perl::Metrics::Lite (
    -mccabe_complexity => 15,    # default 10
    -loc               => 60,    # default 60
    -except_file       => [
        qw(lib/Yetie/View/DOM/EP.pm lib/Yetie/Domain/Base.pm lib/Yetie/Domain/Entity.pm),
        qw(lib/Yetie/Form/Field.pm)
    ],
);

all_metrics_ok();
__END__

[Perl コードのメトリクス測定 - @bayashi Wiki](https://bayashi.net/wiki/perl/perl_metrics)

    10      シンプルでテスタビリティも高いはず。しかし、意図的に関数を分割しすぎて全体の処理が見えにくくならないように注意が必要
    11 - 15 通常はこの範囲に収まる。また、テストカバレッジを高く維持するにはこの程度でないと厳しい
    16 - 20 ぱっと読んでちゃんと動くかな？というレベル。一部テストがまともに書けない状態になってくる
    21 - 25 さらりとは読めない。できれば分割したいところ。おそらく細かいテストはもはや書けない
    26 -    黒歴史化確定。といいつつも、処理内容によってはこの程度のものはありえます
