package Yetie::Schema::Result::AuthenticationRequest;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column email_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

unique_column token => {
    data_type   => 'VARCHAR',
    size        => 40,
    is_nullable => 0,
};

column redirect => {
    data_type   => 'VARCHAR',
    size        => 255,
    is_nullable => 1,
};

# 連続リクエストを防止する
# 同一ipは5〜10秒拒否
# 同一emailは1〜3分拒否

# ブラウザごとにcookieでuuidを保存しておく。無い場合はリクエストを拒否する
# cookieなので改変可能だが...
# フィンガープリンティングというのもある
# column client_uuid => {
# data_type   => 'VARCHAR',
# size        => 40,
# is_nullable => 0,
# };

column remote_address => {
    data_type   => 'VARCHAR',
    size        => 45,
    is_nullable => 0,
};

column is_activated => {
    data_type     => 'BOOLEAN',
    is_nullable   => 0,
    default_value => 0,
};

column expires => {
    data_type   => 'INT',
    is_nullable => 0,
};

# Relation
belongs_to
  email => 'Yetie::Schema::Result::Email',
  { 'foreign.id' => 'self.email_id' };

sub to_data {
    my $self = shift;

    return {
        id             => $self->id,
        email          => $self->email->address,
        token          => $self->token,
        redirect       => $self->redirect,
        remote_address => $self->remote_address,
        is_activated   => $self->is_activated,
        expires        => $self->expires,
    };
}

1;
