\RequirePackage{xspace}
\newcommand{\thecourse}{Software Architecture\xspace}
\newcommand{\thecoursecode}{CSSE4400\xspace}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{csse4400}[2022/01/01 \thecourse]

\newcommand{\headlinecolor}{\normalcolor}
\LoadClass[a4paper,12pt]{article}

\RequirePackage[left=0.5 in,right=0.5 in,top=0.5in,bottom=1in]{geometry}
\RequirePackage{graphicx}

\RequirePackage[sfdefault]{cabin}
\RequirePackage[T1]{fontenc}

\RequirePackage{tcolorbox}

\newcounter{definition}[part]
\newenvironment{definition}[1][]
    {\refstepcounter{definition}
    \begin{tcolorbox}%
    \noindent \textbf{Definition~\thedefinition. #1}
    
    \vspace{4pt}
    }
    {\end{tcolorbox}}

\RequirePackage{xparse}

\let\oldquote\quote
\let\endoldquote\endquote

\RenewDocumentEnvironment{quote}{om}
    {\oldquote}
    {\par\nobreak\smallskip
    \hfill --- #2\IfValueT{#1}{~---~#1}\endoldquote 
    \addvspace{\bigskipamount}}


\RequirePackage{hyperref}

\newif\iflastupdated
\lastupdatedtrue

\RequirePackage{filemod}
\RequirePackage{currfile}
\RequirePackage[absolute]{textpos}

\newcommand{\lastmodified}{%
    \filemodprintdate{\currfilepath}%
}

\newcommand\unappendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \gdef\thesection{\@arabic\c@section}}

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
}

\newcommand{\makecover}{%
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
}

\newcommand{\hint}[1]{
    #1
}

\newcommand{\todo}[1]{
    \begin{tcolorbox}
        {\color{red} TODO: #1}
    \end{tcolorbox}
}

\newenvironment{extra}
    {\begin{center}\begin{tabular}{|p{0.9\textwidth}|}
    \hline\\
    }
    { 
    \\\\\hline
    \end{tabular} 
    \end{center}
    }

\RequirePackage[yyyymmdd,hhmmss]{datetime}

\newenvironment{drafting}
    {\begin{tcolorbox}\color{blue} draft (\today~\currenttime)\\}{\end{tcolorbox}}

\definecolor{aside}{RGB}{120, 128, 181}

\newcommand\aside[1]{
    \begin{tcolorbox}[title=Aside]
    #1
    \end{tcolorbox}
}

\newcommand{\link}[2]{%
\href{#2}{#1}\footnote{\url{#2}}%
}
