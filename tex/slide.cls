\RequirePackage{xspace}
\newcommand{\thecourse}{Software Architecture\xspace}
\newcommand{\thecoursecode}{CSSE4400\xspace}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{slide}[2022/01/01 \thecourse Slides]

\LoadClass[aspectratio=169]{beamer}

\RequirePackage[sfdefault]{cabin}
\RequirePackage[T1]{fontenc}

% Colours
\RequirePackage{xcolor}

\definecolor{primary}{RGB}{50, 98, 115}
\definecolor{secondary}{RGB}{92, 158, 173}
\definecolor{focus}{RGB}{227, 151, 116}

\setbeamercolor{frametitle}{fg=primary}
\setbeamercolor{description item}{fg=secondary}

\setbeamercolor{caption name}{fg=primary}

\let\oldcite\cite
\renewcommand{\cite}[1]{{\color{primary}\oldcite{#1}}}


% Fonts
\RequirePackage[sfdefault]{cabin}
\RequirePackage[T1]{fontenc}


% Remove navigation
\beamertemplatenavigationsymbolsempty

% Custom title page -- could be better
\defbeamertemplate*{title page}{customized}[1][]
{ \centering
  \usebeamerfont{title}\Huge{\color{primary}\inserttitle}\par
  \bigskip
  \usebeamerfont{subtitle}{\Large\color{primary}\insertsubtitle}\par
  \bigskip\vspace{3em}
  \usebeamerfont{author}{\huge\color{secondary}\insertauthor}\par
  \bigskip
  \usebeamerfont{institute}\insertinstitute\par
  \usebeamerfont{date}{\large\color{secondary}\insertdate}\par
  \usebeamercolor[fg]{titlegraphic}\inserttitlegraphic
}

% Footnote without the numbering
\def\blfootnote{\gdef\@thefnmark{}\@footnotetext}

% Youtube video link with preview
% https://youtube-thumbnail-grabber.com/
\RequirePackage{stackengine}
\newcommand{\youtubevideo}[2]{
    \vspace{1em}
    \href{#2}{%
    \stackinset{c}{0pt}{c}{0pt}{%
    \includegraphics[width=0.15\textwidth]{ytlogo}%
    }{%
    \includegraphics[width=0.6\textwidth]{#1}%
    }
    }\blfootnote{\url{#2}}
    \vspace{1em}
}

% Definition environment which matches the notes
\RequirePackage{tcolorbox}
\newcounter{definition}[part]
\newenvironment{defn}[1][]
    {\refstepcounter{definition}
    \vspace{1em}
    \begin{tcolorbox}%
    \noindent {\color{primary}{Definition~\thedefinition. #1}}
    
    \vspace{4pt}
    }
    {\end{tcolorbox}}

% The standard `point' to highlight something
\newcommand{\point}[2][]{
    \frame[c,plain]{
        \par\bigskip
        {\color{primary}#1}

        \huge #2
    }
}

\newcommand{\todo}[1]{
    \point[Oi!]{{\color{red}#1}}
}

\newcommand{\question}[1]{
    \point[Question]{#1}
}

\newcommand{\questionanswer}[2]{
    \point[Question]{#1
    \par\bigskip
    {\normalsize\color{focus}Answer}

    \huge #2
    }
}

% Point with a definition
\renewcommand{\definition}[3][]{
    \point[#1]{
        {\large
        \begin{defn}[#2]
            #3
        \end{defn}}
    }
}

\renewcommand{\quote}[2][]{
    \frame[c,plain]{
        \par\bigskip
        {\huge\color{black}#2}
        \par
        {\hfill\large\color{primary}- #1}
    }
}

% Bibliography styling
\setbeamertemplate{bibliography item}[text]
\setbeamercolor{bibliography item}{fg=primary}
\setbeamercolor{bibliography entry author}{fg=black}
\setbeamercolor{bibliography entry location}{fg=black}
\setbeamercolor{bibliography entry title}{fg=focus}

\newcommand{\references}[1]{
    \frame[c,plain,allowframebreaks]{
        \par\bigskip
        {\color{primary}References}

        \bibliographystyle{unsrt}
        \normalsize \bibliography{#1}
    }
}

% Use the focus font for highlighting
\newcommand{\highlight}[1]{{\color{focus} \textsl{#1}}}

\newcommand{\extra}[2][2-]{\only<#1>{\blfootnote{#2}}}
