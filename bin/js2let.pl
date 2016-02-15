#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long qw(:config posix_default no_ignore_case bundling auto_help);
use Pod::Usage qw(pod2usage);
use Time::Piece;
#use constant HAVE_TIME_PIECE => eval q{use Time::Piece; 1;}; # 安全側に考えなくても世間はPerl5.10以降だよね

GetOptions(
    \my %options, "wrap", "clipboard"
);

my $js_filename = shift;

if ( !$js_filename || !-f $js_filename ) {
    pod2usage();
}

open my $js_fh, '<', $js_filename
    or die $!;
my $js_code = do { local $/; <$js_fh>; };
close $js_fh;

# TODO: これからの文字が文字列リテラル中にあってもダメなので相当適当

# remove comment
$js_code =~ s{/\*(?!\*).*?\*/}{}sg; # /** ... */ 書式のコメントのみ特別視
# $js_code =~ s{//.*?$}{}mg; "//" は迂闊に消せない
$js_code =~ s{(?<!:)//.*?$}{}mg; # スキーマに出てくる :// に配慮したつもり

# remove spaces
$js_code =~ s{^\s+}{}mg; # ^ is \A and (?<=\n) ???
$js_code =~ s{\s+}{ }g;
$js_code =~ s{ = }{=}g;
$js_code =~ s{, }{,}g;
$js_code =~ s{; }{;}g;
$js_code =~ s{\s+$}{}mg; # $ is (?=\n) ???

# remove newline
$js_code =~ s{\n}{ }g;

# for debug
if ( $js_code =~ /\$Debug-Rev.*?\$/ ) {
    my $now = localtime;
    my $ymd = $now->ymd("/");
    my $hms = $now->hms(":");
    $js_code =~ s{\$Debug-Rev.*?\$}{\$Debug-Rev $ymd $hms\$}g;
}

my $url = sprintf "javascript:%s", $options{wrap} ? "(function(){$js_code})()" : $js_code;

print $url, "\n";

if ( $options{clipboard} ) {
    print "pbcopy\n";
    system qq{pbcopy <<<"$url"};
}

=pod

=encoding utf-8

=head1 NAME

js2let.pl - 非常にルーズなブックマークレット生成ツール

=head1 SYNOPSIS

  bin/js2let.pl [--wrap] [--clipboard] JavaScriptファイル名

ファイルは通常のJavaScriptファイルです。
標準出力に一行のブックマークレットを出力します

=head1 DESCRIPTION

やっていることは、コメント除去、改行除去、空白類文字の圧縮です。

=head1 USEFUL FUNCTION

 /** comment */

この形式のコメントは残します。

 $Debug-Rev$

この文字列はRCS IDのように日時文字列に置換されます。
デバッグ時にスクリプトの末尾に

 /** $Debug-Rev$ */

と入れておくと、いつこのスクリプトで処理した一行ブックマークレットかがわかります。

=haed1 HOW TO USE

Mac であれば pbcopy、UNIX であれば xclip コマンドで処理結果を受け取ると良いでしょう。

  bin/js2let.pl your.js > your.packed.js

  ### Mac
  cat your.packed.js | pbcopy

  ### UNIX
  cat your.packed.js | xsel --input --clipboardl

  ### Windows Cygwin
  cat your.packed.js | putclip

デバッグ時は、普段は /* ... */ 形式のコメントはスクリプト本体では使わずに、
エラーが起こった場合には冒頭以外全体を /* ... */ で覆いながら、
エラーが出るところまでコメント領域を狭めていくとよいでしょう。

参考: L<http://mollifier.hatenablog.com/entry/20100317/p1>

=head1 OPTIONS

=over

=item * --wrap

圧縮結果を (function(){...})() でくくります

=item * --clipboard

出力と同時にクリップボードにも結果を入れます

=back

=head1 LIMITATION

構文解析などは全く行っていません。
特にB<文字列リテラル中のコメントっぽい文字列(// ..., /* ... */)も壊す>
ことは注意してください。

特にURLスキームなどで頻出の :// については対応済みです。

=head1 SEE ALSO

JavaScript をminify/packedもできる統合開発環境はいくつもあります。
Javaの導入が済んでいたり、これらのインストールに特段の障害がなければ
こちらを使うほうがおすすめです。

=over

=item * Google Closure Compiler

=item * YUI Compiler

=item * UglifyJS

=item * JSMin

=item * Packer

=back

=head1 CONCEPT

前出の Closure も YUI もインストールが面倒な Java を必要とすること、
また諸処の事情で秘匿が必要なブックマークレットの開発の際に外部
ウェブサービスを使うことがためらわれること。

=head1 DEPENDENCIES

L<Time::Piece>

Perl5.10 以降ではコアモジュールなので特に気にする必要はないと思います。

Mac OS X の場合、付属の perl は 5.10 系なので特に問題ないはずです。

see: perl- v

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by OGATA Tetsuji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
