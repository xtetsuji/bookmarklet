#Bookmarklet!

\(Do you want English description? Please reply to [@xtetsuji](https://twitter.com/xtetsuji)\)

##説明

OGATA Tetsuji \([@xtetsuji](https://twitter.com//xtetsuji)\) のブックマークレット関連ツールです。

実際のブックマークレットは[Hatena::Letのid:xtetsujiページ](http://let.hatelabo.jp/xtetsuji/)で管理しています。[Hatena::Let](http://let.hatelabo.jp/)はhatelaboのサービスではありますが、開発から公開、そして提供まで非常に便利なサイトでオススメです。

##簡単な開発ツールの説明

Maekfile があるので make 経由でも起動することができます。
make の知識がある人はこっちのほうが便利かも。

###bin/js2let.pl

非常に単純な処理で複数行のJavaScriptを一行に変換します。

    $ bin/js2let.pl your.js > your.packed.js

ただダサいことしかしていないので、スクリプトが壊れるケースもあります。
詳細はソース中の説明をエディタで見るか、`perldoc bin/js2let.pl`してみてください。

ちゃんとしたpackをやりたいなら、Hatena::Let自体を使うか、Google Closure Compiler や YUI Compressor などの実績のあるツールを使うとよいでしょう。今回はJava入れるの面倒だったので、Perlで簡単に書いてしまいました。

Perl5.10以降であれば依存関係はありません。例えばMac OS X Mountain Lion のシステムPerlはPerl5.10。see: `perl -v`。

###hatena-let/backup.pl

Hatena::Let のバックアップをします。引数がなければ私 id:xtetsuji のバックアップをとってしまうので、スクリプトを変更するか引数を渡してください。

    $ cd hatena-let/
    $ ./backup.pl YOUR_HATENA_ID
    もしくは
    $ ./backup.pl YOUR_HATENA_ID BACKUP_DIR

標準でバックアップディレクトリは ./backup です。

[Web::Query](http://search.cpan.org/dist/Web-Query/) というPerlモジュールに依存しています。またWeb::Queryが必要とする各種モジュールも同時に必要になります。少しインストールが面倒かもしれません。perlbrewやplenvでユーザPerlの環境がセッティングされている場合は、`cpanm Web::Query` ですんなり入るかとは思います。

多数のスクリプトを抱えている人は、もしかしたらHatena::Let側で
ページング処理が入るかもしれません。
そういった場合の考慮を(2013/04/14現在)していないので、
もし不都合があったらお知らせください。

###parts/

ブックマークレットに利用できそうな部品置き場です。
まだ少ないですが、今後少しずつ増やしていきます。

##ライセンス (LICENSE)

スクリプト中で指定がない場合のライセンスは **MITライセンス** とします。

Those "bookmarklet" project's scripts are **MIT license**
without it includes especially mentioned.
