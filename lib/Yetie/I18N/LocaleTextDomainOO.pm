package Yetie::I18N::LocaleTextDomainOO;
use Mojo::Base 'Mojolicious::Plugin::LocaleTextDomainOO';

use Mojo::Util qw(monkey_patch);
use Carp qw(confess);

{
    no strict 'vars';    ## no critic
    my $escape_maketext = sub {
        my $string = shift;

        defined $string
          or return $string;
        $string =~ s{ ( [\[\]] ) }{~$1}xmsg;

        return $string;
    };

    monkey_patch 'Locale::TextDomain::OO::Translator', translate => sub {
        my ( $self, $msgctxt, $msgid, $msgid_plural, $count, $is_n ) = @_;

        my $key_util =
          Locale::TextDomain::OO::Util::JoinSplitLexiconKeys->instance;
        my $lexicon_key = $key_util->join_lexicon_key(
            {
                (
                    map { $_ => $self->$_; }
                      qw( language category domain project )
                )
            }
        );
        my $lexicon =
          Locale::TextDomain::OO::Singleton::Lexicon->instance->data;
        $lexicon =
          exists $lexicon->{$lexicon_key}
          ? $lexicon->{$lexicon_key}
          : ();

        my $msg_key = $key_util->join_message_key(
            {
                msgctxt      => $msgctxt,
                msgid        => $msgid,
                msgid_plural => $msgid_plural,
            }
        );
        my $maketext_msg_key = sub {
            return $key_util->join_message_key(
                {
                    msgctxt      => $escape_maketext->($msgctxt),
                    msgid        => $escape_maketext->($msgid),
                    msgid_plural => $escape_maketext->($msgid_plural),
                }
            );
        };
        if ($is_n) {
            my $plural_code = $lexicon->{q{}}->{plural_code}
              or confess qq{Plural-Forms not found in lexicon "$lexicon_key"};
            my $multiplural_index =
              ref $count eq 'ARRAY'
              ? $self->_calculate_multiplural_index( $count, $plural_code,
                $lexicon, $lexicon_key )
              : $plural_code->($count);
            my $msgstr_plural =
              exists $lexicon->{$msg_key}
              ? $lexicon->{$msg_key}->{msgstr_plural}->[$multiplural_index]
              : exists $lexicon->{ $maketext_msg_key->() }
              ? $unescape_maketext->(
                $lexicon->{ $maketext_msg_key->() }->{msgstr_plural}
                  ->[$multiplural_index] )
              : ();
            if ( !defined $msgstr_plural ) {    # fallback
                $msgstr_plural =
                    $plural_code->($count)
                  ? $msgid_plural
                  : $msgid;
                my $text =
                  $lexicon
                  ? qq{Using lexicon "$lexicon_key".}
                  : qq{Lexicon "$lexicon_key" not found.};
                $self->language ne 'i-default'
                  and $self->logger
                  and $self->logger->(
                    (
                        sprintf
'%s msgstr_plural not found for msgctxt=%s, msgid=%s, msgid_plural=%s.',
                        $text,
                        ( defined $msgctxt ? qq{"$msgctxt"} : 'undef' ),
                        ( defined $msgid   ? qq{"$msgid"}   : 'undef' ),
                        (
                            defined $msgid_plural
                            ? qq{"$msgid_plural"}
                            : 'undef'
                        ),
                    ),
                    {
                        object => $self,
                        type   => 'warn',
                        event  => 'translation,fallback',
                    },
                  );
            }
            return $msgstr_plural;
        }
        my $msgstr =
            exists $lexicon->{$msg_key} ? $lexicon->{$msg_key}->{msgstr}
          : exists $lexicon->{ $maketext_msg_key->() }
          ? $unescape_maketext->(
            $lexicon->{ $maketext_msg_key->() }->{msgstr} )
          : ();

# Hack. 現在の言語に翻訳がなければデフォルト言語の翻訳を使用
        if ( !defined $msgstr ) {
            my $self_language    = $self->language;
            my $defalut_language = $self->languages->[-1];
            $self->language($defalut_language);

            my $lexicon_key = $key_util->join_lexicon_key(
                {
                    (
                        map { $_ => $self->$_; }
                          qw( language category domain project )
                    )
                }
            );
            my $lexicon =
              Locale::TextDomain::OO::Singleton::Lexicon->instance->data;
            $lexicon =
              exists $lexicon->{$lexicon_key}
              ? $lexicon->{$lexicon_key}
              : ();

            $msgstr =
                exists $lexicon->{$msg_key} ? $lexicon->{$msg_key}->{msgstr}
              : exists $lexicon->{ $maketext_msg_key->() }
              ? $unescape_maketext->(
                $lexicon->{ $maketext_msg_key->() }->{msgstr} )
              : ();
            $self->language($self_language);
        }

        if ( !defined $msgstr ) {    # fallback
            $msgstr = $msgid;

            my $text =
              $lexicon
              ? qq{Using lexicon "$lexicon_key".}
              : qq{Lexicon "$lexicon_key" not found.};
            $self->language ne 'i-default'
              and $self->logger
              and $self->logger->(
                (
                    sprintf '%s msgstr not found for msgctxt=%s, msgid=%s.',
                    $text,
                    ( defined $msgctxt ? qq{"$msgctxt"} : 'undef' ),
                    ( defined $msgid   ? qq{"$msgid"}   : 'undef' ),
                ),
                {
                    object => $self,
                    type   => 'warn',
                    event  => 'translation,fallback',
                },
              );
        }

        return $msgstr;
    };
}

1;
