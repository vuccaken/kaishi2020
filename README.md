This is  vuccaken kaishi 2020.

- vuccaken HP: https://vuccaken.github.io
- LaTeX tutorial: https://nukoyama.github.io/mkdocs-test/tex/tutorial01/
- kaishi tutorial: https://nukoyama.github.io/mkdocs-test/tex/kaishi01/


## General

- タイプセットは `latexmk (uplatex -> dvipdfmx)` で行う。


### Directory structure

```
kaishi/
  |- etc/            % 設定メモなど、いろいろ
  |- fonts/          % フォント（源ノ）を入れる
  |- sty/            % texliveで標準インストールされないものや自作スタイルファイル
  |    |- v-hyperref.sty     % hyperref.sty の改造版
  |    |- vkaishi.cls        % 会誌のクラスファイル
  |    `- vuccaken.sty       % 共通設定や細かいマクロ
  |- tex/
  |   |- _BK/         % 表紙や奥付など
  |   |- _sample/     % 会誌記事サンプル
  |   |- _template/   % コピペ用テンプレート
  |   ...
  |
  |- .gitigunore     % git で無視するファイルを指定
  |- .latexmkrc      % latexmk の設定ファイル
  `- marge.tex       % 各texファイルをまとめる
```


