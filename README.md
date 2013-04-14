#Bookmarklet!

##説明

OGATA Tetsuji \([@xtetsuji](https://twitter.com//xtetsuji)\) のブックマークレット関連ツールです。

実際のブックマークレットは[Hatena::Letのid:xtetsujiページ](http://let.hatelabo.jp/xtetsuji/)で管理しています。Hatena::Letはhatelaboのサービスではありますが、開発から公開、そして提供まで非常に便利なサイトでオススメです。

##簡単な開発ツールの説明

Maekfile があるので make 経由でも起動することができます。
make の知識がある人はこっちのほうが便利かも。

###bin/js2let.pl

>
$ bin/js2let.pl your.js > your.packed.js

ただダサいことしかしていないので、スクリプトが壊れるケースもあります。
詳細はソース中の説明をエディタで見るか、`perldoc bin/js2let.pl`してみてください。

ちゃんとしたpackerをやりたいなら、Hatena::Let自体を使うか、Google Closure Compiler や YUI Compressor などの実績のあるツールを使うとよいでしょう。Java入れるの面倒だったのでPerlで簡単に書いてしまいました。

Perl5.10以降であれば依存関係はありません。例えばMac OS X Mountain Lion のシステムPerlはPerl5.10。see: `perl -v`。

###hatena-let/backup.pl

Hatena::Let のバックアップをします。引数がなければ私 id:xtetsuji のバックアップをとってしまうので、スクリプトを変更するか引数を渡してください。

>
$ cd hatena-let/
$ ./backup.pl YOUR_HATENA_ID
もしくは
$ ./backup.pl YOUR_HATENA_ID BACKUP_DIR

標準でバックアップディレクトリは ./backup です。

###parts/

ブックマークレットに利用できそうな部品置き場です。
まだ少ないですが、今後少しずつ増やしていきます。

##ライセンス

スクリプト中で指定がない場合のライセンスはMITライセンスとします。

