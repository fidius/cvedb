\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fidius-p}[2009/11/28 v1.3 FIDIUS Presentation]

% decompress headline
\newif\iffidius@decompress \fidius@decompressfalse
\DeclareOption{decompress}{\fidius@decompresstrue}

% add author to footline
\newif\iffidius@authorinfoot \fidius@authorinfootfalse
\DeclareOption{authorinfoot}{\fidius@authorinfoottrue}

% english instead of ngerman hyphenation
\newif\iffidius@english \fidius@englishfalse
\DeclareOption{english}{\fidius@englishtrue}

% unknown options
\DeclareOption*{\PackageWarning{FIDIUS Presentation}{Unknown `\CurrentOption`}}
\ProcessOptions\relax

\pagenumbering{arabic}
\LoadClass[10pt,xcolor=table]{beamer}

% ----------------
% loading packages
% ----------------
\iffidius@english
	\RequirePackage[presentation,english]{fidius-common}
\else
	\RequirePackage[presentation]{fidius-common}
\fi

% --------------
% defining theme
% --------------

% basic layout
\usetheme[compress]{Dresden}
\usecolortheme[named=black]{structure}
\useinnertheme{rectangles}

% redefine beamers colors to be conform with FIDIUS' color scheme
\setbeamercolor*{palette primary}{fg=Black,bg=White}
\setbeamercolor*{palette secondary}{fg=Black,bg=Light Khaki}
\setbeamercolor*{palette tertiary}{fg=Black,bg=Light Khaki}
\setbeamercolor*{palette quaternary}{fg=Strong Blue,bg=Dark Beige}

\setbeamercolor*{separation line}{bg=Night Red}
\setbeamercolor*{alerted text}{fg=Red}
\setbeamercolor*{frametitle}{fg=Red}

\setbeamercolor*{item}{fg=Red}
\setbeamercolor*{titlelike}{parent=palette primary}


\setbeamertemplate{headline}{%
	\begin{beamercolorbox}{section in head/foot}%
		\vskip2pt%
		\iffidius@decompress%
			\insertsectionnavigationhorizontal{\paperwidth}{}{}%
			\vskip2pt%
			\insertsubsectionnavigationhorizontal{\paperwidth}{}{}%
		\else%
			\insertnavigation{\paperwidth}%
		\fi%
		\vskip2pt%
	\end{beamercolorbox}%
	\begin{beamercolorbox}[colsep=.25pt]{separation line}%
	\end{beamercolorbox}%
}

\pgfdeclareimage[height=1.75ex]{logos}{fidius-logos}
\setbeamertemplate{footline}{%
	\begin{beamercolorbox}[colsep=.25pt]{separation line}%
	\end{beamercolorbox}
	\begin{beamercolorbox}[ht=4ex,dp=2.5ex,leftskip=2ex,rightskip=2ex]{title in head/foot}%
		\begingroup%
			\usebeamerfont{title in head/foot}%
			\raisebox{-1ex}{\pgfuseimage{logos}}%
			\hspace*{1em}%
			\iffidius@authorinfoot\insertshortauthor, \fi\insertshortinstitute: \insertshorttitle%
		\endgroup%
		\hfill%
		\begingroup%
			\usebeamerfont{institute in head/foot}%
			\usebeamercolor[fg]{institute in head/foot}%
			\insertframenumber/\inserttotalframenumber%
		\endgroup%
	\end{beamercolorbox}%
}

% disable navigation symbols
\setbeamertemplate{navigation symbols}{}

% set bullet symbols
\setbeamertemplate{itemize item}{\textbf{\frqq}}
\setbeamertemplate{itemize subitem}{\frqq}
\setbeamertemplate{itemize subsubitem}{\frq}
\setbeamertemplate{enumerate item}{\insertenumlabel.}

% reduce left margin of list environments
\setlength\leftmargini{0pt}
\setlength\leftmarginii{1em}
\setlength\leftmarginiii{1em}

\setbeamerfont{title}{series=\bfseries}
\setbeamerfont{subtitle}{series=\normalfont}
\setbeamerfont{frametitle}{series=\bfseries}
\setbeamerfont{framesubtitle}{series=\bfseries}

% ------------------
% defining variables
% ------------------
\institute[Uni-Bremen, TZI, FIDIUS]{Universit{\"a}t Bremen, TZI, FIDIUS}
\date{\today}

% ----------------------------------
% redefining internal LaTeX commands
% ----------------------------------
% reduce fontsize within verbatim environments
\def\verbatim@font{\footnotesize\ttfamily}

% -----------------
% defining commands
% -----------------
% section frame:
%	#1 = subsection name
%	#2 = frame content as usual
\newcommand{\sectionframe}[1] {%
	\section{#1}
	\frame[c]{
		\begin{center}
			\color{Red}\huge\bfseries #1
		\end{center}
	}
}

% subsection frame:
%	#1 = subsection name
%	#2 = frame content as usual
\newcommand{\secframe}[2] {%
	\subsection{#1}
	\frame{
		\frametitle{#1}
		#2
	}
}

% let \href be blue
\let\hr@f\href
\def\href#1#2{\hr@f{#1}{\color{Strong Blue} #2}}

% hyperlinked email address:
%	#1    = email address (without 'mailto:' prefix
%	usage = \email{dmke@tzi.de}
\newcommand{\email}[1] {%
	\texttt{\href{mailto:#1}{#1}}
}

% single lined, nested itemize environment
%	#1 (optional) = beamers default overlay specification for lists
%	#2            = the items content
%   usage 1       = \subitem{this is a bullet point, which will be discovered, when the parental item is discovered}
%	usage 2       = \subitem[]{this bullet item will be discovered with the default specification rule}
%   usage 3       = \subitem[<2->]{bullet point visible on slide two and further}
\newcommand\subitem[2][<.->]{
	\begin{itemize}[#1]
		\item #2
	\end{itemize}
}

\endinput