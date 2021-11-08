\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{csse4400}[2022/01/01 Software Architecture]

\newcommand{\headlinecolor}{\normalcolor}
\LoadClass[a4paper,12pt]{article}

\RequirePackage[left=0.5 in,right=0.5 in,top=0.5in,bottom=1in]{geometry}
\RequirePackage{graphicx}

\RequirePackage[sfdefault]{cabin}
\RequirePackage[T1]{fontenc}

\RequirePackage{tcolorbox}

\newcounter{definition}[section]
\newenvironment{definition}[1][]
    {\refstepcounter{definition}
    \begin{tcolorbox}%
    \noindent \textbf{Definition~\thedefinition. #1}
    
    \vspace{4pt}
    }
    {\end{tcolorbox}}

\RequirePackage{hyperref}

\renewcommand{\maketitle}{%
    \noindent\rule{\textwidth}{1pt}\vspace{8pt}
    {\Large \@title} \hfill Software Architecture\vspace{16pt}

    \noindent\@date \hfill \@author

    \noindent\rule{\textwidth}{1pt}
    
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

        Presented for the Sofware Architecture course\\
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
    {\begin{tcolorbox}\color{blue} draft (\today~\currenttime)}{\end{tcolorbox}}