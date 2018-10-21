use strict;
use warnings;
use Test::Spellunker;

add_stopwords(
    qw/charset checksum clicktx yetie xxx/
);

all_pod_files_spelling_ok();
