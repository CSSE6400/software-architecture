\RequirePackage{common}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{slide}[2022/01/01 \thecourse Slides]

\LoadClass[aspectratio=169]{beamer}

\usefonttheme{serif}

% Colours
\RequirePackage{xcolor}

\definecolor{primary}{RGB}{50, 98, 115}
\definecolor{secondary}{RGB}{92, 158, 173}
\definecolor{focus}{RGB}{227, 151, 116}
\definecolor{focus}{rgb}{1.0,0.27,0.0}
\definecolor{focus}{rgb}{0.79, 0.17, 0.57}
\definecolor{secondary}{rgb}{0.19, 0.84, 0.78}
\definecolor{primary}{rgb}{0.06, 0.3, 0.57}
\definecolor{secondary}{rgb}{0.36, 0.57, 0.9}

\definecolor{tomato}{rgb}{1.0, 0.39, 0.28}

\setbeamercolor{frametitle}{fg=primary}
\setbeamerfont{subtitle}{shape=\itshape}
\setbeamercolor{description item}{fg=secondary}

\setbeamercolor{caption name}{fg=primary}
\setbeamercolor{local structure}{fg=secondary}

\let\oldcite\cite
\renewcommand{\cite}[1]{{\textsuperscript{\color{tomato}\footnotesize\itshape\kern-1ex\oldcite{#1}}}}

\setbeamertemplate{itemize items}[circle]

\RequirePackage{wrapfig}

% Remove navigation
\beamertemplatenavigationsymbolsempty

% Custom title page
\defbeamertemplate*{title page}{customized}[1][]
{
\mbox{}\hfill\raisebox{-1.4\height}[0pt][0pt]{%
{\usebeamercolor[fg]{titlegraphic}\inserttitlegraphic}}
\vspace*{-\baselineskip}

%   \centering
  \usebeamerfont{title}\huge{\color{primary}\inserttitle}\par
  \bigskip
  \usebeamerfont{subtitle}{\Large\color{primary}\insertsubtitle}\par
  \bigskip\vspace{3em}
  \usebeamerfont{author}{\large\color{secondary}\textnormal\insertauthor}\par
  \bigskip
  
  \usebeamerfont{date}{\color{secondary}\textnormal\insertdate}\par
  {\large\color{secondary}\usebeamerfont{institute}\insertinstitute}\par
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
        \noindent {\color{primary}{\textit{Definition~\thedefinition.} #1}}
    
    \vspace{4pt}
    }
    {\end{tcolorbox}}

\newcounter{corollary}[part]
\newenvironment{col}[1][]
    {\refstepcounter{corollary}
    \vspace{1em}
    \begin{tcolorbox}%
        \noindent {\color{primary}{\textit{Corollary~\thecorollary.} #1}}
    
    \vspace{4pt}
    }
    {\end{tcolorbox}}

\newcounter{oxymoron}[part]
\newenvironment{oxy}[1][]
    {\refstepcounter{oxymoron}
    \vspace{1em}
    \begin{tcolorbox}%
        \noindent {\color{primary}{\textit{Oxymoron~\theoxymoron.} #1}}
    
    \vspace{4pt}
    }
    {\end{tcolorbox}}

% The standard `point' to highlight something
\newcommand{\point}[2][]{
    \frame[c,plain]{
        \par\bigskip
        {\color{primary}\textit{#1}}

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
        {\normalsize\color{focus}\textit{Answer}}

    \huge #2
    }}
}

% Point with a definition
\renewcommand{\definition}[3][]{
    \point[#1]{
        {\LARGE
        \begin{defn}[#2]
            #3
        \end{defn}}
    }
}

% Point with a corollary
\renewcommand{\corollary}[3][]{
    \point[#1]{
        {\LARGE
        \begin{col}[#2]
            #3
        \end{col}}
    }
}

% Point with an oxymoron
\newcommand{\oxymoron}[3][]{
    \point[#1]{
        {\LARGE
        \begin{oxy}[#2]
            #3
        \end{oxy}}
    }
}

\renewcommand{\quote}[2][]{
    \frame[c,plain]{
        \par\bigskip
        {\huge\color{black}#2}
        \par
        {\hfill\large\color{primary}\textit{- #1}}
    }
}

\newcommand{\image}[2][width=\textwidth]{
    \begin{frame}
        \begin{center}
            \includegraphics[#1]{#2}
        \end{center}
    \end{frame}
}

% Bibliography styling
\setbeamertemplate{bibliography item}[text]
\setbeamercolor{bibliography item}{fg=tomato}
\setbeamercolor{bibliography entry author}{fg=black}
\setbeamercolor{bibliography entry location}{fg=black}
\setbeamercolor{bibliography entry title}{fg=focus}

\newcommand{\references}[1]{
    \frame[c,plain,allowframebreaks]{
        \par\bigskip
        {\color{primary}References}

        \bibliographystyle{apalike}
        \normalsize \bibliography{#1}
    }
}

% Use the focus font for highlighting
\newcommand{\highlight}[1]{{\color{focus} \textit{#1}}}

\newcommand{\extra}[2][2-]{\only<#1>{\blfootnote{#2}}}

% Add page numbers
% \addtobeamertemplate{navigation symbols}{}{%
%     \usebeamerfont{footline}%
%     {\color{primary}\insertframenumber}{\color{secondary}/\inserttotalframenumber}%
%     \vspace{40pt}%
% }

% Remove cluttered notes formatting
\setbeamertemplate{note page}{\vfill\Large\insertnote\vfill}

% Sectioning
\AtBeginSection[]{
  \begin{frame}
  \vfill
  \fontsize{40}{20}\selectfont\color{primary}\textit{\S\hspace{0.5em}\insertsectionhead}\par%
  \vfill
  \end{frame}
}

