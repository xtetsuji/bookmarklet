#!/usr/bin/env perl

use strict;
use warnings;

my $js_filename = shift;

open my $js_fh, '<', $js_filename
    or die $!;
my $js_code = do { local $/; <$js_fh>; };
close $js_fh;

# TODO: これからの文字が文字列リテラル中にあってもダメなので相当適当

# remove comment
$js_code =~ s{/\*(?!\*).*?\*/}{}sg; # /** ... */ 書式のコメントのみ特別視
$js_code =~ s{//.*?$}{}mg;

# remove newline
$js_code =~ s{\n}{ }g;

# remove spaces
$js_code =~ s{\s+}{ }g;
$js_code =~ s{ = }{=}g;
$js_code =~ s{, }{,}g;
$js_code =~ s{; }{;}g;

print "javascript:$js_code\n";

=pod

=encoding utf-8

=head1 NAME

js2let.pl - 非常にルーズなブックマークレット生成ツール

=head1 SYNOPSIS

  bin/js2let.pl JavaScriptファイル名

ファイルは通常のJavaScriptファイルです。
標準出力に一行のブックマークレットを出力します

=head1 DESCRIPTION

やっていることは、コメント除去、改行除去、空白類文字の圧縮です。

=head1 LIMITATION

構文解析などは全く行っていません。
特にB<文字列リテラル中のコメントっぽい文字列(// ..., /* ... */)も壊すことは
注意してください。

=head1 SEE ALSO

=over

=item * Google Closure Compiler

=item * YUI Compiler

=item * UglifyJS

=item * JSMin

=item * Packer

=back

=head1 CONCEPT

前出の Closure Library も YUI もインストールが面倒な Java を必要とすること、
また諸処の事情で秘匿が必要なブックマークレットの開発の際に外部
ウェブサービスを使うことがためらわれること。

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by OGATA Tetsuji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
