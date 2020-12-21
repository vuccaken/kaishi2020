#!/usr/bin/env perl

## latex command 共通 options
$latex_options = '-synctex=1 -halt-on-error -file-line-error -interaction=nonstopmode';

## OS 判定
if ($^O eq 'MSWin32') { # Windows の場合
  $latex   = "uplatex %O $latex_options -kanji=utf8 -no-guess-input-enc %P";
} else { # Windows 以外の OS の場合 (Linux, macOS)
  $latex   = "uplatex %O $latex_options %P";
}
$pdflatex  = "pdflatex %O $latex_options %S";
$lualatex  = "lualatex %O $latex_options %S";
$xelatex   = "xelatex %O $latex_options -no-pdf -shell-escape %S";
$biber     = "biber %O --bblencoding=utf8 -u -U --output_safechars %B";
$bibtex    = "upbibtex %O %B";
$makeindex = "upmendex %O -o %D %S";
$dvipdf    = "dvipdfmx %O -o %D %S";
$dvips     = "dvips %O -z -f %S | convbkmk -u > %D";
$ps2pdf    = "ps2pdf.exe %O %S %D";

## *latex コマンドの最大実行回数
$max_repeat = 5;

## tex ソースの前に、tex コマンドを挿入
## latexmk "$pre_tex_code\input{hoge.tex}"
# $pre_tex_code = '\AtBeginDocument{An initial message\par}';

## PDF の作成方法を指定するオプション
# $pdf_mode = 0; # PDF を作成しません。
# $pdf_mode = 1; # $pdflatex を利用して PDF を作成します。
# $pdf_mode = 2; # $ps2pdf を利用して .ps ファイルから PDF を作成します。
$pdf_mode = 3; # $dvipdf を利用して .dvi ファイルから PDF を作成します。
# $pdf_mode = 4; # $lualatex を利用して .dvi ファイルから PDF を作成します。
# $pdf_mode = 5; # xdvipdfmx を利用して .xdv ファイルから PDF を作成します。

## PDF ビュアーの設定（OS 別）
if ($^O eq 'MSWin32') { # Windows の場合
  if (-f 'C:/Program Files/SumatraPDF/SumatraPDF.exe') {
    $pdf_previewer = '"C:/Program Files/SumatraPDF/SumatraPDF.exe" -reuse-instance';
  } elsif (-f 'C:/Program Files (x86)/SumatraPDF/SumatraPDF.exe') {
    $pdf_previewer = '"C:/Program Files (x86)/SumatraPDF/SumatraPDF.exe" -reuse-instance';
  } else {
    $pdf_previewer = 'texworks';
  }
} elsif ($^O eq 'darwin') { # macOS の場合
  ## 一時ファイルの作成を抑止するオプション(0: 抑止)
  ## Skim 等の変更検知機構のあるビュアーで変更箇所を検知できるようにするため
  $pvc_view_file_via_temporary = 0;
  $pdf_previewer = "open -ga /Applications/Skim.app";
} else { # Linux の場合
  $pdf_previewer = "xdg-open";
}

## specify cleanup mode
# $cleanup_mode = 0; # 何も消さない (default)
$cleanup_mode = 2; # equivalent to -c option

## -c option で消すファイルの拡張子
$clean_ext = "dvi";

## show CPU time used
$show_time = 1;


## --- special settings for kaishi ---

## for vscode
## ルートディレクトリの探索
$merge_file = 'merge.tex';
if (-e $merge_file) {
  $root_dir = '.';
} elsif (-e '../../' . $merge_file) {
  $root_dir = './../..';
}

## for command line
# $root_dir = '.';

## sty や font を探索するパスを追加
if ($root_dir){
  ensure_path(TEXMFHOME, $root_dir . '//;');
  # $ENV{'TEXMFHOME'} = $root_dir . '//;'; # 上と同じ意味
}
