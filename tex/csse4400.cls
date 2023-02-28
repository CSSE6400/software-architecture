\RequirePackage{common}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{csse4400}[2022/01/01 \thecourse]

\newcommand{\headlinecolor}{\normalcolor}
\LoadClass[a4paper,12pt]{article}

\RequirePackage[sfdefault]{cabin}
\RequirePackage[T1]{fontenc}

% Thin margins
\RequirePackage[left=0.5 in,right=0.5 in,top=0.5in,bottom=1in]{geometry}

\RequirePackage{graphicx}

% Pretty quotes
\RequirePackage{xparse}

\let\oldquote\quote
\let\endoldquote\endquote

\RenewDocumentEnvironment{quote}{om}
    {\oldquote}
    {\par\nobreak\smallskip
    \hfill --- #2\IfValueT{#1}{~---~#1}\endoldquote 
    \addvspace{\bigskipamount}}

% htlatex macro for conditional rendering if web or pdf
\newif\ifhtlatex
\ifx\HCode\UnDeFiNeD
  \htlatexfalse
\else
  \htlatextrue
\fi

% Links
\RequirePackage{hyperref}
\newcommand{\link}[2]{%
\href{#2}{#1}\footnote{\url{#2}}%
}

% Highlight hyperlinks in notes with colours for each type of link.
\hypersetup{
    colorlinks=true,
    linkcolor=violet,
    filecolor=purple,      
    urlcolor=blue,
    citecolor=black,
}

% Todo macro
\newcommand{\todo}[1]{
    \begin{tcolorbox}
        {\color{red} TODO: #1}
    \end{tcolorbox}
}

% Teaching macro
\newif\ifteachermode
\newcommand{\teacher}[1]{
    \ifteachermode
    \begin{tcolorbox}[
        title=For the teacher,
        colframe = green!25,
        colback  = green!10,
        coltitle = green!20!black
    ]
        {#1}
    \end{tcolorbox}
    \fi
}

% Undo the effects of an appendix in the full notes
\newcommand\unappendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \gdef\thesection{\@arabic\c@section}}

% Top of page title header
\RequirePackage[absolute]{textpos}

\renewcommand{\maketitle}{%
    \addcontentsline{toc}{part}{\@title}
    \unappendix
    \noindent\rule{\textwidth}{1pt}\vspace{8pt}
    {\Large \@title} \hfill \thecourse\vspace{16pt}

    \noindent\@date \hfill \@author

    \noindent\rule{\textwidth}{1pt}
    
    \iflastupdated
    \begin{textblock*}{\textwidth}(425pt,20pt)
        \footnotesize Last Updated on \lastmodified
    \end{textblock*}
    \fi
    \ifteachermode
    \begin{textblock*}{\textwidth}(225pt,55pt)
        \rotatebox{25}{\large \color{red} Teacher Version}
    \end{textblock*}
    \fi
}

% Full page title
\newcommand{\makecover}{%
\ifhtlatex
\else
\begin{titlepage}
    \begin{center}
        \hfill Lecture Notes in Software Engineering
        \noindent\rule{\textwidth}{1pt}
        
        \vfill
            
        \Huge
        \@title
            
        \vspace{0.5cm}
            
        \large
        \@date
        \vspace{0.5cm}
        
        \@author
            
        \vfill

        Presented for the \thecourse course\\
        at the University of Queensland

        \vspace{1cm}

        \includegraphics[width=0.4\textwidth]{uqlogo}        
            
        \vspace{0.8cm}
            
    \end{center}
\end{titlepage}
\fi
}

% Misc environments
\RequirePackage{tcolorbox}

\definecolor{info}{RGB}{135, 206, 235}
\newcommand{\hint}[1]{
    \begin{tcolorbox}[title=Hint,colframe=info]
    #1
    \end{tcolorbox}
}

% Extra content? Do I use this?
\newenvironment{extra}
    {\begin{center}\begin{tabular}{|p{0.9\textwidth}|}
    \hline\\
    }
    { 
    \\\\\hline
    \end{tabular} 
    \end{center}
    }

% Draft box
\RequirePackage[yyyymmdd,hhmmss]{datetime}
\newenvironment{drafting}
    {\begin{tcolorbox}\color{blue} draft (\today~\currenttime)\\}{\end{tcolorbox}}

% Aside
\definecolor{aside}{RGB}{120, 128, 181}
\newcommand\aside[1]{
    \begin{tcolorbox}[title=Aside]
    #1
    \end{tcolorbox}
}

% Notice
\definecolor{notice}{RGB}{255, 105, 97}
\newcommand\notice[1]{
    \begin{tcolorbox}[title=Notice,colframe=notice]
    #1
    \end{tcolorbox}
}

% Info
\newcommand\info[1]{
    \begin{tcolorbox}[title=Info,colframe=info]
    #1
    \end{tcolorbox}
}

% Warning
\definecolor{warning}{RGB}{255, 204, 0}
\newcommand\warning[1]{
    \begin{tcolorbox}[title=Warning,colframe=warning]
    #1
    \end{tcolorbox}
}

% Defintion
\newcounter{definition}[part]
\newenvironment{definition}[1][]
    {\refstepcounter{definition}
    \begin{tcolorbox}%
    \noindent \textbf{Definition~\thedefinition. #1}
    
    \vspace{4pt}
    }
    {\end{tcolorbox}}

\newcounter{corollary}[part]
\newenvironment{corollary}[1][]
    {\refstepcounter{corollary}
    \begin{tcolorbox}%
    \noindent \textbf{Corollary~\thecorollary. #1}
    
    \vspace{4pt}
    }
    {\end{tcolorbox}}
