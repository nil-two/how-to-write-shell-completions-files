# 6行から始めるコマンドライン補完スクリプト自作 サンプルファイル

[6行から始めるコマンドライン補完スクリプト自作](https://techbookfest.org/product/bswqrn71FNpHA1gZzMR0tb?productVariantID=dVUPKfByCAU9UDCNGbnAw1)のサンプルファイル。

## 変更点

全体を通して、紙面の都合で行を分けていた箇所を1行に、スペースを切り詰めていた箇所を複数スペースに展開しています。
主にfishの補完スクリプトが読みやすくなっていると思います。

## 修正点

### 2\_bash/202\_egame.bash

$prevを見て処理をしている部分、
COMPREPLYに絞り込み済み補完候補を入れてすぐreturnするように修正しています。
ここにreturnが無い場合、
--color=の後は$splitがtrueになるので$split && returnで抜けるのですが、
-c、--colorの後だと$splitはtrueにならないことでreturnで抜けず、
後続処理でCOMPREPLYが上書きされてしまい、補完候補にauto、always、neverが入らない状態になっていました。
そのため、後続処理でCOMPREPLYに値を入れる可能性がある箇所については、COMPREPLYに値を入れてすぐreturnする必要がありました。

```diff
   case $prev in
     -c|--color)
       COMPREPLY=( $(compgen -W 'auto always never' -- "$cur") )
+      return
       ;;
   esac
   $split && return
```

### 2\_bash/203\_ticket.bash

2\_bash/202\_egame.bash と同じ問題があり、
--status=の後はopen、closed、allが補完候補に表示されるものの、
-s、--statusの後はopen、closed、allが補完候補に表示されないようになっていました。
同じくCOMPREPLYに絞り込み済み補完候補を入れてすぐreturnするように修正しています。

```diff
           case $prev in
             -s|--status)
               COMPREPLY=( $(compgen -W 'open closed' -- "$cur") )
+              return
               ;;
           esac
           $split && return
```

### 4\_fish/403\_ticket.fish

ticket editのオプションの-s、--statusの補完候補をopen、closed、allに修正しています。
修正前は補完候補からallが抜けており、補完候補がopen、closedだけになっていました。

```diff
- complete -c ticket -n '__fish_seen_subcommand_from list' -s s -l status -xa 'open closed' -d 'Ticket status'
+ complete -c ticket -n '__fish_seen_subcommand_from list' -s s -l status -xa 'open closed all' -d 'Ticket status'
```

## 補足点

### Bashの補完スクリプトで使える変数

Bashの補完スクリプトでは、
コマンドライン情報は\_init\_completionを呼び出して得られた変数の値から取れます。
しかし、何らかの理由でbash-completionパッケージを入れることが難しい場合、例えばサーバーで追加のパッケージを入れられない場合などには使用することができません。
その場合は、次の変数からであればコマンドライン情報を取れます。

| 変数 | 値 |
|-|-|
| COMP\_CWORD | カーソル位置の引数番号 |
| COMP\_WORDS | 引数一覧 |

cur、prev、words、cwordについては、次のようにして\_init\_completionを呼び出して得られる値と概ね同じ値を得られます。
しかし、splitは得られません。また、COMP\_WORDBREAKSによるwordsの引数分割は回避できません。
wordsとcwordについては変数の値そのままなので、COMP\_WORDS、COMP\_CWORDについては直接参照していいと思います。

```bash
cur=${COMP_WORDS[COMP_CWORD]}
prev=${COMP_WORDS[COMP_CWORD-1]}
words=( "${COMP_WORDS[@]}" )
cword=$COMP_CWORD
```
