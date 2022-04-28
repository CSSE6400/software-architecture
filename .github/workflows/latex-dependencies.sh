#!/bin/bash
# Install latex dependencies

tlmgr option repository ftp://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2021/tlnet-final/
tlmgr update --self
tlmgr install cabin
tlmgr install fontaxes
tlmgr install tcolorbox
tlmgr install environ
tlmgr install datetime
tlmgr install fmtcount
tlmgr install filemod
tlmgr install currfile
tlmgr install textpos
tlmgr install stackengine
tlmgr install xifthen
tlmgr install ifmtarg
tlmgr install enumitem
tlmgr install changepage
tlmgr install datenumber
tlmgr install thmtools
tlmgr install cjk
tlmgr install wrapfig
tlmgr install tabto-ltx
tlmgr install multirow
tlmgr install xltabular
tlmgr install ltablex
tlmgr install pdflscape
tlmgr install accsupp
tlmgr install tikzmark
