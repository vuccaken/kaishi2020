%%
%%  This file is 'vkaishi.cls'
%%

%% クラスファイルの宣言
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{vkaishi}[2020/08/23 vuccaken kaishi class]

%% 新規 if 文の宣言
\newif\ifanalog
\newif\ifmarge


%% vkaishi クラスの新規オプション
\DeclareOption{analog}{\analogtrue}
\DeclareOption{marge}{\margetrue}

%% \documentclass で与えたオプションを、jsbook クラスにも与える。
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{jsbook}}
\ProcessOptions\relax

%% デフォルトでオプションを与えつつ、jsbook クラスをロード。
\LoadClass[10pt,b5paper,papersize]{jsbook}


%% inner margin settings
\ifanalog\v@set@innermargin\fi
\newcommand\v@set@innermargin{
  \addtolength{\oddsidemargin}{10truemm}   % odd(right) page
  \addtolength{\evensidemargin}{-10truemm} % even(left) page
}

%% hyperref.styを読み込んでいなくてもOK。
%% そのときは \texorpdfstring をエスケープ。
\ifdefined\texorpdfstring\else
  \newcommand{\texorpdfstring}[2]{#1}
\fi

%% 見出しのフォントを変更
%% original (jsclsass): \gtfamily\sffamily
\renewcommand{\headfont}{\bfseries}

%% 強調のフォント
\newcommand\vEmphFont{\headfont}

%% カラー・白黒の場合分け
\newif\ifcolor
\colortrue % default でカラーON
\newcommand{\vcolor}[2]{\ifcolor#1\else#2\fi}

%% sub tex file での目次出力
\setcounter{tocdepth}{2} % 目次にどこまで表示するか
\newif\iftoc % 目次の出力制御
\ifmarge\else\toctrue\fi % marge.tex 以外で true
\newcommand\mokuji[1]{%
  \iftoc
    \setcounter{tocdepth}{#1} % 目次に表示する深さ
    \tableofcontents % 目次出力
  \fi
}

%% - - - - - - - - - - - - - - - - - - - - - %%
%% \vcmaketitle の定義
%% - - - - - - - - - - - - - - - - - - - - - %%

\newcommand\vcmaketitle{
  \kaishititle{\vc@title}{\vc@belong\vc@grade}{\vc@author}
  \vctitle{}
  \vcauthor{}
  \vcbelong{}
  \vcgrade{}
}

\newcommand\vctitle[1]{\renewcommand\vc@title{#1}}
\newcommand\vc@title{}

\newcommand\vcauthor[1]{\renewcommand\vc@author{#1}}
\newcommand\vc@author{}

\newcommand\vcbelong[1]{\renewcommand\vc@belong{#1}}
\newcommand\vc@belong{}

\newcommand\vcgrade[1]{\renewcommand\vc@grade{#1\vc@grade@name}}
\newcommand\vc@grade{}
\newcommand\vc@grade@name{回生}

%% - - - - - - - - - - - - - - - - - - - - - %%
%% 各章のタイトル出力コマンド \kaishititle の定義
%% - - - - - - - - - - - - - - - - - - - - - %%

%% \kaishititle{title}{na}{me}
\newcommand{\kaishititle}[3]{%
  \vchapter{#2\hspace{1zw}#3}{#1}
  \vspace{-40pt}
  \begin{flushright}
    {\vEmphFont \large #2} \\ \vspace{3pt} %所属
    {\vEmphFont \large #3} \\ \vspace{30pt} %名前
  \end{flushright}}

%% \vchapter{name}{title}
\newcommand{\vchapter}[2]{%
  \if@openleft\cleardoublepage\else
  \if@openright\cleardoublepage\else\clearpage\fi\fi
  \plainifnotempty % 元: \thispagestyle{plain}
  \global\@topnum\z@
  \if@english \@afterindentfalse \else \@afterindenttrue \fi
  \@omit@numberfalse
  \@vchapter{#1}{#2}}

%% \@vchapter{name}{title}
\def\@vchapter#1#2{%
  \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
      \refstepcounter{chapter}%
      \typeout{\@chapapp\thechapter\@chappos}%
      \vaddcontentsline{toc}{chapter}%
        {\protect\numberline
        % {\if@english\thechapter\else\@chapapp\thechapter\@chappos\fi}%
        {\@chapapp\thechapter\@chappos}#2}{#1}%
    \else\vaddcontentsline{toc}{chapter}{#2}{#1}\fi
  \else
    \vaddcontentsline{toc}{chapter}{#2}{#1}%
  \fi
  \chaptermark{#2}%
  \addtocontents{lof}{\protect\addvspace{10\jsc@mpt}}%
  \addtocontents{lot}{\protect\addvspace{10\jsc@mpt}}%
  \if@twocolumn
    \@topnewpage[\@makechapterhead{#2}]%
  \else
    \@makechapterhead{#2}%
    \@afterheading
  \fi}

% %% 弄ってない
% %% \addcontents{toc}{\vcontentsline{chapter}{title}{name}{page}}
% \long\def\addtocontents#1#2{%
%   \protected@write\@auxout
%       {\let\label\@gobble \let\index\@gobble \let\glossary\@gobble}%
%       {\string\@writefile{#1}{#2}}}

%%% - - - - v-hyperref.sty で上書きされる - - - - %%%

%% \vaddcontentsline{toc}{chapter}{title}{name}
\def\vaddcontentsline#1#2#3#4{%
  \addtocontents{#1}{\protect\vcontentsline{v#2}{#3}{#4}{\thepage}}\protected@file@percent
}

%% \contentsline{chapter}
\def\vcontentsline#1{\csname l@#1\endcsname}

%%% - - - - - - - - - - - - - - - - - - - - - - %%%

%% \l@vchapter{title}{name}{page}
\newcommand*{\l@vchapter}[3]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \addvspace{1.0em \@plus\jsc@mpt}
    \begingroup
      \parindent\z@
      \rightskip\@tocrmarg
      \parfillskip-\rightskip
      \leavevmode\headfont
      % \if@english\setlength\@lnumwidth{5.5em}\else\setlength\@lnumwidth{4.683zw}\fi
      \setlength\@lnumwidth{\jsc@tocl@width}\advance\@lnumwidth 2.683zw
      \advance\leftskip\@lnumwidth \hskip-\leftskip
      {\large #1}\\\samepage\nobreak\hfil#2\nobreak\hbox to\@pnumwidth{\hss#3}\par % 2019-08-06 \samepage 挿入
      \penalty\@highpenalty
    \endgroup
  \fi}

%% 本物の方も弄る（#1のフォントサイズ -> \large）
\renewcommand*{\l@chapter}[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \addvspace{1.0em \@plus\jsc@mpt}
    \begingroup
      \parindent\z@
      \rightskip\@tocrmarg
      \parfillskip-\rightskip
      \leavevmode\headfont
      % \if@english\setlength\@lnumwidth{5.5em}\else\setlength\@lnumwidth{4.683zw}\fi
      \setlength\@lnumwidth{\jsc@tocl@width}\advance\@lnumwidth 2.683zw
      \advance\leftskip\@lnumwidth \hskip-\leftskip
      {\large #1}\nobreak\hfil\nobreak\hbox to\@pnumwidth{\hss#2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}
%% - - - end of definition: \kaishititle - - - - -


%% 参考文献の thebibliography 環境は、
%% デフォだと chapter なので、section に変更
\renewenvironment{thebibliography}[1]{%
  \global\let\presectionname\relax
  \global\let\postsectionname\relax
  % \chapter*{\bibname}\@mkboth{\bibname}{}% 元
  % \addcontentsline{toc}{chapter}{\bibname}% 元
  \section*{\bibname}\markright{\bibname}% 変更
  \addcontentsline{toc}{section}{\bibname}% 変更
  \list{\@biblabel{\@arabic\c@enumiv}}%
      {\settowidth\labelwidth{\@biblabel{#1}}%
        \leftmargin\labelwidth
        \advance\leftmargin\labelsep
        \@openbib@code
        \usecounter{enumiv}%
        \let\p@enumiv\@empty
        \renewcommand\theenumiv{\@arabic\c@enumiv}}%
  \sloppy
  \clubpenalty4000
  \@clubpenalty\clubpenalty
  \widowpenalty4000%
  \sfcode`\.\@m
}{%
  \def\@noitemerr
    {\@latex@warning{Empty `thebibliography' environment}}%
    \endlist
}

%% 巻頭言・編集後記
%% usage: \begin{preface}{巻頭言 or 編集後記}{役職}{学部}{名前}{日付}
\newenvironment{preface}[5]{%
  \newcommand\pf@name{#1}%
  \newcommand\pf@position{#2}%
  \newcommand\pf@belong{#3}%
  \newcommand\pf@author{#4}%
  \newcommand\pf@date{#5}%
  \cleardoublepage%
  % \section*{\pf@name}\@mkboth{}{\pf@name}% 本文では section
  \chapter*{\pf@name}\@mkboth{\pf@name}{}% 本文では chapter
  \addcontentsline{toc}{chapter}{\pf@name}% 目次では chapter
}{%
  \begin{flushright}%
    \ifdefined\vEmphFont\vEmphFont\else\headfont\fi
    \pf@date\par
    \pf@position\hspace{1zw}\ignorespaces
    \pf@belong\hspace{1zw}\pf@author
  \end{flushright}\par%
}


%%
%%  End of vkaishi.cls
%%