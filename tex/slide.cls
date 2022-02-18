\RequirePackage{common}

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
\setbeamercolor{local structure}{fg=secondary}

\let\oldcite\cite
\renewcommand{\cite}[1]{{\color{primary}\oldcite{#1}}}

\setbeamertemplate{itemize items}[circle]

% Fonts
\RequirePackage[sfdefault]{cabin}
\RequirePackage[T1]{fontenc}


% Remove navigation
\beamertemplatenavigationsymbolsempty

% Custom title page
\defbeamertemplate*{title page}{customized}[1][]
{ \centering
  \usebeamerfont{title}\Huge{\color{primary}\inserttitle}\par
  \bigskip
  \usebeamerfont{subtitle}{\Large\color{primary}\insertsubtitle}\par
  \bigskip\vspace{3em}
  \usebeamerfont{author}{\huge\color{secondary}\insertauthor}\par
  \bigskip
  
  \usebeamerfont{date}{\large\color{secondary}\insertdate}\par
  {\large\color{secondary}\usebeamerfont{institute}\insertinstitute}\par
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

\RequirePackage[absolute,overlay]{textpos}

\newcommand{\browser}[3]{
    % \begin{center}
    \stackinset{l}{5pt}{t}{30pt}{\parbox{5in}{#3}}{
    \includegraphics[width=\textwidth]{browser-window}
    }
    \put(-400,242.5){\fontsize{5pt}{5pt}\selectfont \hspace{0.45in} #1}
    \put(-400,232.5){\fontsize{5pt}{5pt}\selectfont \hspace{0.55in} #2}
    % \put(-400,212.5){\parbox{5in}{#3}}
    % \end{center}
}

% Tweet environment
\RequirePackage{wrapfig}
\definecolor{tweetborder}{RGB}{239, 243, 244}
\definecolor{tweethandlecolor}{RGB}{83, 100, 113}
\newcommand{\tweet}[5]{
    \begin{tcolorbox}[colframe=white,width=0.5\textwidth]
        \begin{wrapfigure}[2]{l}{2\baselineskip}
            \vspace{-1.3\baselineskip}
            \tikz{\clip circle (\baselineskip) node {\includegraphics[height=2\baselineskip]{#1}}}
        \end{wrapfigure}
        \textbf{#2}\\
        {\color{tweethandlecolor} @#3}\\[0.5em]
        {#4}
    \end{tcolorbox}
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
    \only<2->{\par\bigskip
    {\normalsize\color{focus}Answer}

    \huge #2
    }}
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

% Add page numbers
% \addtobeamertemplate{navigation symbols}{}{%
%     \usebeamerfont{footline}%
%     {\color{primary}\insertframenumber}{\color{secondary}/\inserttotalframenumber}%
%     \vspace{40pt}%
% }
