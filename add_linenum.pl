#!/usr/bin/perl -w
#
# ecmartin 11/07/2008
#
# Adds line numbers to a Latex document
#
# Creates a new Latex document which is a modified version
# of the original that contains line numbers.
# Must be used with revtex_linenum.cls and lineno4.sty

use strict;


my $lineno4_redefinitions = <<"END";
%
% Overwrite two revtex4 definitions after the 
% documentclass command has been executed.
%
\\catcode`\\\@=11\\relax
\\def\\\@makecol{%
 \\setbox\\\@outputbox\\vbox{%
  \\boxmaxdepth\\\@maxdepth
 \\protected\@write\\\@auxout{}{% 
         % \\string\\\@LN\@col{\\if\@firstcolumn1\\else2\\fi}%
 \\string\\\@LN\@col{\\\@ifnum{\\pagegrid\@cur=\\\@ne}{1}{2}}
      }%
  \\\@tempdima\\dp\\\@cclv
  \\unvbox\\\@cclv
  \\vskip-\\\@tempdima
 }%
 \\xdef\\\@freelist{\\\@freelist\\\@midlist}\\global\\let\\\@midlist\\\@empty
 \\\@combinefloats
 \\\@combineinserts\\\@outputbox\\footins
  \\set\@adj\@colht\\dimen\@
  \\count\@\\vbadness
  \\vbadness\\\@M
  \\setbox\\\@outputbox\\vbox to\\dimen\@{%
   \\\@texttop
   \\dimen\@\\dp\\\@outputbox
   \\unvbox\\\@outputbox
   \\vskip-\\dimen\@
   \\\@textbottom
  }%
  \\vbadness\\count\@
 \\global\\maxdepth\\\@maxdepth
}%
%
\\def\\balance\@two#1#2{%
%\\immediate\\message{in balance\@two to split the cols}
\\outputdebug\@sw{{\\tracingall\\scrollmode\\showbox#1\\showbox#2}}{}%
 \\setbox\\\@ne\\vbox{%
  \\\@ifvoid#1{}{%
   \\unvcopy#1\\recover\@footins
   \\\@ifvoid#2{}{\\marry\@baselines}%
  }%
  \\\@ifvoid#2{}{%
   \\unvcopy#2\\recover\@footins
  }%
 }%
 \\dimen\@\\ht\\\@ne\\divide\\dimen\@\\tw\@
 \\dimen\@i\\dimen\@
 \\vbadness\\\@M
 \\vfuzz\\maxdimen
 \\loopwhile{%
  \\dimen\@i=.5\\dimen\@i
  \\outputdebug\@sw{\\saythe\\dimen\@\\saythe\\dimen\@i\\saythe\\dimen\@ii}{}%
  \\setbox\\z\@\\copy\\\@ne\\setbox\\tw\@\\vsplit\\z\@ to\\dimen\@
  \\setbox\\z\@ \\vbox{%
 \\protected\@write\\\@auxout{}{% 
         % \\string\\\@LN\@col{\\if\@firstcolumn1\\else2\\fi}%
 \\string\\\@LN\@col{\\\@ifnum{\\pagegrid\@cur=\\\@ne}{1}{2}}
      }%
   \\unvcopy\\z\@
   \\setbox\\z\@\\vbox{\\unvbox\\z\@ \\setbox\\z\@\\lastbox\\aftergroup\\vskip\\aftergroup-\\expandafter}\\the\\dp\\z\@\\relax
  }%
  \\setbox\\tw\@\\vbox{%
   \\unvcopy\\tw\@
   \\setbox\\z\@\\vbox{\\unvbox\\tw\@\\setbox\\z\@\\lastbox\\aftergroup\\vskip\\aftergroup-\\expandafter}\\the\\dp\\z\@\\relax
  }%
  \\dimen\@ii\\ht\\tw\@\\advance\\dimen\@ii-\\ht\\z\@
  \\\@ifdim{\\dimen\@i>.5\\p\@}{%
   \\advance\\dimen\@\\\@ifdim{\\dimen\@ii<\\z\@}{}{-}\\dimen\@i
   \\true\@sw
  }{%
   \\\@ifdim{\\dimen\@ii<\\z\@}{%
    \\advance\\dimen\@\\tw\@\\dimen\@i
    \\true\@sw
   }{%
    \\false\@sw
   }%
  }%
 }%
 \\outputdebug\@sw{\\saythe\\dimen\@\\saythe\\dimen\@i\\saythe\\dimen\@ii}{}%
\\\@ifdim{\\ht\\z\@=\\z\@}{%
\\\@ifdim{\\ht\\tw\@=\\z\@}{%
\\true\@sw
}{%
\\false\@sw
}%
}{%
\\true\@sw
}%
{%
}{%
\\ltxgrid\@info{Unsatifactorily balanced columns: giving up}%
\\setbox\\tw\@\\box#1%
\\setbox\\z\@ \\box#2%
}%
 \\setbox\\tw\@\\vbox{\\unvbox\\tw\@\\vskip\\z\@skip}%
 \\setbox\\z\@ \\vbox{\\unvbox\\z\@ \\vskip\\z\@skip}%
 \\set\@colroom
\\dimen\@\\ht\\z\@\\\@ifdim{\\dimen\@<\\ht\\tw\@}{\\dimen\@\\ht\\tw\@}{}%
\\\@ifdim{\\dimen\@>\\\@colroom}{\\dimen\@\\\@colroom}{}%
 \\outputdebug\@sw{\\saythe{\\ht\\z\@}\\saythe{\\ht\\tw\@}\\saythe\\\@colroom\\saythe\\dimen\@}{}%
\\setbox#1\\vbox to\\dimen\@{\\unvbox\\tw\@\\unskip\\raggedcolumn\@skip}%
\\setbox#2\\vbox to\\dimen\@{\\unvbox\\z\@ \\unskip\\raggedcolumn\@skip}%
\\outputdebug\@sw{{\\tracingall\\scrollmode\\showbox#1\\showbox#2}}{}%
}%
\\catcode`\\\@=12\\relax
END


# the following is a version of lineno.sty 
# adapted from lineno.sty version 4.41
# see http://tug.ctan.org/info?id=lineno
 
    

sub createLinenoRevtex{

my $lineno_babar_file = "lineno_babar_revtex.sty";

open(LINENOFILE, "> $lineno_babar_file");
#print LINENOFILE $lineno_babar_code ;
#close(LINENOFILE);
#my $lineno_babar_code = << "END_LINENO4";
print LINENOFILE <<END_LINENO_REVTEX;

%              \\iffalse; awk '/S[H]ELL1/' lineno.sty|sh;exit; 
%             ... see bottom for .tex documentation ... 
%
% Macro file lineno.sty for LaTeX: attach line numbers, refer to them. 
%                                                                           \\fi 
\\def\\fileversion{v4.41} \\def\\filedate{2005/11/02}                     %VERSION
%%% Copyright 1995--2003 Stephan I. B"ottcher <boettcher\@physik.uni-kiel.de>; 
%%% Copyright 2002--2005 Uwe L"uck, http://www.contact-ednotes.sty.de.vu 
%%%                      for version 4 and code from former Ednotes bundle 
%%%                      --author-maintained. 
%%% 
%%% This file can be redistributed and/or modified under 
%%% the terms of the LaTeX Project Public License; either 
%%% version 1.3a of the License, or any later version.
%%% The latest version of this license is in
%%%     http://www.latex-project.org/lppl.txt
%%% We did our best to help you, but there is NO WARRANTY. 
\\NeedsTeXFormat{LaTeX2e}[1994/12/01] 
%%                                                                [1994/11/04] 
\\ProvidesPackage{lineno_babar_revtex} 
  [\\filedate\\space line numbers on paragraphs \\fileversion] 

\\newcount\\linenopenalty\\linenopenalty=-100000

\\mathchardef\\linenopenaltypar=32000

\\mathchardef\\\@Mllbcodepen=11111 
\\mathchardef\\\@Mppvacodepen=11112

\\let\\\@tempa\\output
\\newtoks\\output
\\let\\\@LN\@output\\output
\\output=\\expandafter{\\the\\\@tempa}

\\\@tempa={%
            \\LineNoTest
            \\if\@tempswa

             \\ifnum\\outputpenalty=-\\\@Mllbcodepen 
                \\WriteLineNo 

              \\else 
                \\ifnum\\outputpenalty=-\\\@Mppvacodepen 
                  \\PassVadjustList 
                \\else 
   \\LineNoLaTeXOutput 
                \\fi 
              \\fi 
            \\else  
              \\MakeLineNo
            \\fi
            }

\\def\\LineNoTest{%
  \\let\\\@\@par\\\@\@\@par
  \\ifnum\\interlinepenalty<-\\linenopenaltypar
     \\advance\\interlinepenalty-\\linenopenalty
     \\\@LN\@nobreaktrue
     \\fi
  \\\@tempswatrue
  \\ifnum\\outputpenalty>-\\linenopenaltypar\\else
     \\ifnum\\outputpenalty>-188000\\relax
       \\\@tempswafalse
       \\fi
     \\fi
  }

\\def\\\@LN\@nobreaktrue{\\let\\if\@nobreak\\iftrue} % renamed v4.33

\\def\\LineNoLaTeXOutput{% 
  \\ifnum \\holdinginserts=\\thr\@\@   % v4.33 without \\\@tempswafalse
    \\global\\holdinginserts-\\thr\@\@ 
    \\unvbox\\\@cclv 
    \\ifnum \\outputpenalty=\\\@M \\else \\penalty\\outputpenalty \\fi 
  \\else
  %  \\if\@twocolumn \\let\\\@makecol\\\@LN\@makecol \\fi
 \\\@ifnum{\\pagegrid\@col>\\\@ne}{
\\let\\\@makecol\\\@LN\@makecol}{
%\\immediate\\message{the test on column number fails}
}
%{\\ifnum(\\the\\c\@LN\@truepage=6){\\let\\\@makecol\\\@LN\@makecol}{}}
%\\let\\\@makecol\\\@LN\@makecol
    \\the\\\@LN\@output % finally following David Kastrup's advice. 
    \\ifnum \\holdinginserts=-\\thr\@\@ 
      \\global\\holdinginserts\\thr\@\@ \\fi 
  \\fi
}

\\def\\MakeLineNo{%
   \\\@LN\@maybe\@normalLineNumber                        % v4.31 
   \\boxmaxdepth\\maxdimen\\setbox\\z\@\\vbox{\\unvbox\\\@cclv}%
   \\\@tempdima\\dp\\z\@ \\unvbox\\z\@
   \\sbox\\\@tempboxa{\\hb\@xt\@\\z\@{\\makeLineNumber}}%
   \\stepLineNumber
   \\ht\\\@tempboxa\\z\@ \\\@LN\@depthbox 
   \\\@LN\@do\@vadjusts 
   \\count\@\\lastpenalty
   \\ifnum\\outputpenalty=-\\linenopenaltypar 
     \\ifnum\\count\@=\\z\@ \\else  
       \\xdef\\\@LN\@parpgbrk{% 
         \\penalty\\the\\count\@
         \\global\\let\\noexpand\\\@LN\@parpgbrk
                      \\noexpand\\\@LN\@screenoff\@pen}% v4.4 
     \\fi
   \\else
     \\\@tempcnta\\outputpenalty
     \\advance\\\@tempcnta -\\linenopenalty
     \\penalty \\ifnum\\count\@<\\\@tempcnta \\\@tempcnta \\else \\count\@ \\fi 
   \\fi
   }
\\newcommand\\stepLineNumber{\\stepcounter{linenumber}} 
\\def\\\@LN\@depthbox{% 
  \\dp\\\@tempboxa=\\\@tempdima
  \\nointerlineskip \\kern-\\\@tempdima \\box\\\@tempboxa} 

\\let\\\@\@\@par\\\@\@par
\\newcount\\linenoprevgraf

\\def\\linenumberpar{% 
  \\ifvmode \\\@\@\@par \\else 
    \\ifinner \\\@\@\@par \\else
      \\xdef\\\@LN\@outer\@holdins{\\the\\holdinginserts}% v4.2 
      \\advance \\interlinepenalty \\linenopenalty
      \\linenoprevgraf \\prevgraf
      \\global \\holdinginserts \\thr\@\@ 
      \\\@\@\@par
      \\ifnum\\prevgraf>\\linenoprevgraf
        \\penalty-\\linenopenaltypar
      \\fi
      \\\@LN\@parpgbrk 
      \\global\\holdinginserts\\\@LN\@outer\@holdins % v4.2
      \\advance\\interlinepenalty -\\linenopenalty
    \\fi     % from \\ifinner ... \\else 
  \\fi}      % from \\ifvmode ... \\else 

\\def\\\@LN\@screenoff\@pen{% 
  \\ifdim\\lastskip=\\z\@ 
    \\\@tempdima\\prevdepth \\setbox\\\@tempboxa\\null 
    \\\@LN\@depthbox                           \\fi}

\\global\\let\\\@LN\@parpgbrk\\\@LN\@screenoff\@pen 

\\newif\\ifLineNumbers \\LineNumbersfalse 

\\def\\linenumbers{% 
     \\LineNumberstrue                            % v4.00 
     \\xdef\\\@LN\@outer\@holdins{\\the\\holdinginserts}% v4.3 
     \\let\\\@\@par\\linenumberpar
 %      \\let\\linelabel\\\@LN\@linelabel % v4.11, removed v4.3 
     \\ifx\\\@par\\\@\@\@par\\let\\\@par\\linenumberpar\\fi
     \\ifx\\par\\\@\@\@par\\let\\par\\linenumberpar\\fi
     \\\@LN\@maybe\@moduloresume         % v4.31 
     \\\@ifnextchar[{\\resetlinenumber}%]
                 {\\\@ifstar{\\resetlinenumber}{}}%
     }


\\def\\nolinenumbers{% 
  \\LineNumbersfalse                              % v4.00
  \\let\\\@\@par\\\@\@\@par
 %   \\let\\linelabel\\\@LN\@LLerror      % v4.11, removed v4.3 
  \\ifx\\\@par\\linenumberpar\\let\\\@par\\\@\@\@par\\fi
  \\ifx\\par\\linenumberpar\\let\\par\\\@\@\@par\\fi
  }

\\def\\pagewiselinenumbers{\\linenumbers\\setpagewiselinenumbers}
\\def\\runninglinenumbers{\\setrunninglinenumbers\\linenumbers}

\\\@namedef{linenumbers*}{\\par\\linenumbers*}
\\\@namedef{runninglinenumbers*}{\\par\\runninglinenumbers*}

\\def\\endlinenumbers{\\par\\\@endpetrue}
\\let\\endrunninglinenumbers\\endlinenumbers
\\let\\endpagewiselinenumbers\\endlinenumbers
\\expandafter\\let\\csname endlinenumbers*\\endcsname\\endlinenumbers
\\expandafter\\let\\csname endrunninglinenumbers*\\endcsname\\endlinenumbers
\\let\\endnolinenumbers\\endlinenumbers
\\newcommand\\linenomathNonumbers{%
  \\ifLineNumbers 
%%  \\ifx\\\@\@par\\\@\@\@par\\else 
    \\ifnum\\interlinepenalty>-\\linenopenaltypar
      \\global\\holdinginserts\\thr\@\@ 
      \\advance\\interlinepenalty \\linenopenalty
     \\ifhmode                                   % v4.3 
      \\advance\\predisplaypenalty \\linenopenalty
     \\fi 
    \\fi
  \\fi
  \\ignorespaces
  }

\\newcommand\\linenomathWithnumbers{%
  \\ifLineNumbers 
%%  \\ifx\\\@\@par\\\@\@\@par\\else
    \\ifnum\\interlinepenalty>-\\linenopenaltypar
      \\global\\holdinginserts\\thr\@\@ 
      \\advance\\interlinepenalty \\linenopenalty
     \\ifhmode                                   % v4.3 
      \\advance\\predisplaypenalty \\linenopenalty
     \\fi 
      \\advance\\postdisplaypenalty \\linenopenalty
      \\advance\\interdisplaylinepenalty \\linenopenalty
    \\fi
  \\fi
  \\ignorespaces
  }


\\newcommand\\linenumberdisplaymath{%
  \\def\\linenomath{\\linenomathWithnumbers}%
  \\\@namedef{linenomath*}{\\linenomathNonumbers}%
  }

\\newcommand\\nolinenumberdisplaymath{%
  \\def\\linenomath{\\linenomathNonumbers}%
  \\\@namedef{linenomath*}{\\linenomathWithnumbers}%
  }

\\def\\endlinenomath{% 
  \\ifLineNumbers                            % v4.3 
   \\global\\holdinginserts\\\@LN\@outer\@holdins % v4.21 
  \\fi 
   \\global % v4.21 support for LaTeX2e earlier than 1996/07/26. 
   \\\@ignoretrue
}
\\expandafter\\let\\csname endlinenomath*\\endcsname\\endlinenomath

\\nolinenumberdisplaymath

\\let\\\@LN\@ExtraLabelItems\\\@empty

\\def\\\@LN\@xnext#1\\\@lt#2\\\@\@#3#4{\\def#3{#1}\\gdef#4{#2}}

\\global\\let\\\@LN\@labellist\\\@empty 

\\def\\WriteLineNo{% 
  \\unvbox\\\@cclv 
  \\expandafter \\\@LN\@xnext \\\@LN\@labellist \\\@\@ 
                          \\\@LN\@label \\\@LN\@labellist 
  \\protected\@write\\\@auxout{}{\\string\\newlabel{\\\@LN\@label}% 
         {{\\theLineNumber}{\\thepage}\\\@LN\@ExtraLabelItems}}% 
}

\\def\\\@LN\@LLerror{\\PackageError{lineno}{% 
  \\string\\linelabel\\space without \\string\\linenumbers}{% 
  Just see documentation. (New feature v4.11)}\\\@gobble}


\\newcommand\\linelabel{% 
  \\ifLineNumbers \\expandafter \\\@LN\@linelabel 
  \\else          \\expandafter \\\@LN\@LLerror   \\fi}

\\gdef\\\@LN\@linelabel#1{% 
  \\ifx\\protect\\\@typeset\@protect 
   \\ifvmode
       \\ifinner \\else 
          \\leavevmode \\\@bsphack \\\@savsk\\p\@
       \\fi
   \\else
       \\\@bsphack
   \\fi
   \\ifhmode
     \\ifinner
       \\\@parmoderr
     \\else
       \\\@LN\@postlabel{#1}% 
       \\\@esphack 
     \\fi
   \\else
     \\\@LN\@mathhook{#1}%
   \\fi
  \\fi 
   }

\\def\\\@LN\@postlabel#1{\\g\@addto\@macro\\\@LN\@labellist{#1\\\@lt}%
       \\vadjust{\\penalty-\\\@Mllbcodepen}} 
\\def\\\@LN\@mathhook#1{\\\@parmoderr}

\\def\\makeLineNumberLeft{% 
  \\hss\\linenumberfont\\LineNumber\\hskip\\linenumbersep}

\\def\\makeLineNumberRight{% 
  \\linenumberfont\\hskip\\linenumbersep\\hskip\\columnwidth
  \\hb\@xt\@\\linenumberwidth{\\hss\\LineNumber}\\hss}

\\def\\linenumberfont{\\normalfont\\tiny\\sffamily}

\\newdimen\\linenumbersep
\\newdimen\\linenumberwidth

\\linenumberwidth=10pt
\\linenumbersep=10pt

\\def\\switchlinenumbers{\\\@ifstar
    {\\let\\makeLineNumberOdd\\makeLineNumberRight
     \\let\\makeLineNumberEven\\makeLineNumberLeft}%
    {\\let\\makeLineNumberOdd\\makeLineNumberLeft
     \\let\\makeLineNumberEven\\makeLineNumberRight}%
    }

\\def\\setmakelinenumbers#1{\\\@ifstar
  {\\let\\makeLineNumberRunning#1%
   \\let\\makeLineNumberOdd#1%
   \\let\\makeLineNumberEven#1}%
  {\\ifx\\c\@linenumber\\c\@runninglinenumber
      \\let\\makeLineNumberRunning#1%
   \\else
      \\let\\makeLineNumberOdd#1%
      \\let\\makeLineNumberEven#1%
   \\fi}%
  }

\\def\\leftlinenumbers{\\setmakelinenumbers\\makeLineNumberLeft}
\\def\\rightlinenumbers{\\setmakelinenumbers\\makeLineNumberRight}

\\leftlinenumbers*

\\newcounter{linenumber}
\\newcount\\c\@pagewiselinenumber
\\let\\c\@runninglinenumber\\c\@linenumber

\\newcommand*\\resetlinenumber[1][\\\@ne]{% 
  \\global                             % v4.22
  \\c\@runninglinenumber#1\\relax}

\\def\\makeRunningLineNumber{\\makeLineNumberRunning}

\\def\\setrunninglinenumbers{%
   \\def\\theLineNumber{\\thelinenumber}%
   \\let\\c\@linenumber\\c\@runninglinenumber
   \\let\\makeLineNumber\\makeRunningLineNumber
   }

\\setrunninglinenumbers\\resetlinenumber

\\def\\setpagewiselinenumbers{%
   \\let\\theLineNumber\\thePagewiseLineNumber
   \\let\\c\@linenumber\\c\@pagewiselinenumber
   \\let\\makeLineNumber\\makePagewiseLineNumber
   }

\\def\\makePagewiseLineNumber{\\logtheLineNumber\\getLineNumber
  \\ifoddNumberedPage
     \\makeLineNumberOdd
  \\else
     \\makeLineNumberEven
  \\fi
  }

\\def\\logtheLineNumber{\\protected\@write\\\@auxout{}{%
   \\string\\\@LN{\\the\\c\@linenumber}{% 
     \\noexpand\\the\\c\@LN\@truepage}}
%\\immediate\\message{\\string\\\@LN{\\the\\c\@linenumber}{\\the\\c\@LN\@truepage}}
} 
\\newcount\\c\@LN\@truepage 
\\g\@addto\@macro\\cl\@page{\\global\\advance\\c\@LN\@truepage\\\@ne}
\\\@addtoreset{LN\@truepage}{\@ckpt}

\\def\\LastNumberedPage{first} 
\\def\\LN\@Pfirst{\\nextLN\\relax}

\\let\\lastLN\\relax  % compare to last line on this page
\\let\\firstLN\\relax % compare to first line on this page
\\let\\pageLN\\relax  % get the page number, compute the linenumber
\\let\\nextLN\\relax  % move to the next page


\\AtEndDocument{
\\let\\\@LN\\\@gobbletwo
%\\onecolumngrid
}

\\def\\\@LN#1#2{{\\expandafter\\\@\@LN
                 \\csname LN\@P#2C\\\@LN\@column\\expandafter\\endcsname
                 \\csname LN\@PO#2\\endcsname
                 {#1}{#2}}}

\\def\\\@\@LN#1#2#3#4{\\ifx#1\\relax
    \\ifx#2\\relax\\gdef#2{#3}\\fi
    \\expandafter\\\@\@\@LN\\csname LN\@P\\LastNumberedPage\\endcsname#1% 
    \\xdef#1{\\lastLN{#3}\\firstLN{#3}% 
            \\pageLN{#4}{\\\@LN\@column}{#2}\\nextLN\\relax}%
  \\else
    \\def\\lastLN##1{\\noexpand\\lastLN{#3}}%
    \\xdef#1{#1}%
  \\fi
  \\xdef\\LastNumberedPage{#4C\\\@LN\@column}}

\\def\\\@\@\@LN#1#2{{\\def\\nextLN##1{\\noexpand\\nextLN\\noexpand#2}%
                \\xdef#1{#1}}}


\\def\\NumberedPageCache{\\LN\@Pfirst}

\\def\\testLastNumberedPage#1{\\ifnum#1<\\c\@linenumber
      \\let\\firstLN\\\@gobble
  \\fi}

\\def\\testFirstNumberedPage#1{\\ifnum#1>\\c\@linenumber
     \\def\\nextLN##1{\\testNextNumberedPage\\LN\@Pfirst}%
  \\else
      \\let\\nextLN\\\@gobble
      \\def\\pageLN{\\gotNumberedPage{#1}}%
  \\fi}

\\long\\def \\\@gobblethree #1#2#3{}

\\def\\testNumberedPage{%
  \\let\\lastLN\\testLastNumberedPage
  \\let\\firstLN\\testFirstNumberedPage
  \\let\\pageLN\\\@gobblethree
  \\let\\nextLN\\testNextNumberedPage
  \\NumberedPageCache
  }

\\def\\testNextNumberedPage#1{\\ifx#1\\relax
     \\global\\def\\NumberedPageCache{\\gotNumberedPage0000}%
     \\PackageWarningNoLine{lineno}%
                    {Linenumber reference failed,
      \\MessageBreak  rerun to get it right}%
   \\else
     \\global\\let\\NumberedPageCache#1%
   \\fi
   \\testNumberedPage
   }

\\let\\getLineNumber\\testNumberedPage


\\newif\\ifoddNumberedPage
\\newif\\ifcolumnwiselinenumbers
\\columnwiselinenumbersfalse

\\def\\gotNumberedPage#1#2#3#4{\\oddNumberedPagefalse
%  \\ifodd \\if\@twocolumn #3\\else #2\\fi\\relax\\oddNumberedPagetrue\\fi
\\ifodd \\\@ifnum{\\pagegrid\@col>\\\@ne}{#3
%\\immediate\\message{we are not failing the twocolumn test}
}{#2
%\\ifnum(\\the\\c\@LN\@truepage=6){#3}{#2}
%\\immediate\\message{we are failing the twocolumn test}
}
\\relax\\oddNumberedPagetrue\\fi
  \\advance\\c\@linenumber\\\@ne 
  \\ifcolumnwiselinenumbers
     \\subtractlinenumberoffset{#1}%
  \\else
     \\subtractlinenumberoffset{#4}%
  \\fi
  }


\\def\\runningpagewiselinenumbers{%
  \\let\\subtractlinenumberoffset\\\@gobble
  }

\\def\\realpagewiselinenumbers{%
  \\def\\subtractlinenumberoffset##1{\\advance\\c\@linenumber-##1\\relax}%
  }

\\realpagewiselinenumbers


\\def\\thePagewiseLineNumber{\\protect 
       \\getpagewiselinenumber{\\the\\c\@linenumber}}%

\\def\\getpagewiselinenumber#1{{%
  \\c\@linenumber #1\\relax\\testNumberedPage
  \\thelinenumber
  }}

\\AtBeginDocument{% v4.2, revtex4.cls (e.g.). 
 % <- TODO v4.4+: Or better in \\LineNoLaTeXOutput!? 
  \\let\\\@LN\@orig\@makecol\\\@makecol} 
\\def\\\@LN\@makecol{%
   \\\@LN\@orig\@makecol
} %% TODO cf. revtexln.sty. 
\\def\\\@LN\@col{\\def\\\@LN\@column} % v4.22, removed #1. 
\\\@LN\@col{1}

\\def\\themodulolinenumber{\\relax
  \\ifnum\\c\@linenumber<\\c\@firstlinenumber \\else 
    \\begingroup 
      \\\@tempcnta\\c\@linenumber
      \\advance\\\@tempcnta-\\c\@firstlinenumber 
      \\divide\\\@tempcnta\\c\@linenumbermodulo
      \\multiply\\\@tempcnta\\c\@linenumbermodulo
      \\advance\\\@tempcnta\\c\@firstlinenumber 
      \\ifnum\\\@tempcnta=\\c\@linenumber \\thelinenumber \\fi
    \\endgroup 
  \\fi 
}

\\newcommand\\modulolinenumbers{% 
  \\\@ifstar
    {\\def\\\@LN\@maybe\@moduloresume{% 
       \\global\\let\\\@LN\@maybe\@normalLineNumber
                            \\\@LN\@normalLineNumber}% 
                                       \\\@LN\@modulolinenos}% 
    {\\let\\\@LN\@maybe\@moduloresume\\relax \\\@LN\@modulolinenos}%
}

\\global\\let\\\@LN\@maybe\@normalLineNumber\\relax 
\\let\\\@LN\@maybe\@moduloresume\\relax 
\\gdef\\\@LN\@normalLineNumber{% 
  \\ifnum\\c\@linenumber=\\c\@firstlinenumber \\else 
    \\ifnum\\c\@linenumber>\\\@ne
      \\def\\LineNumber{\\thelinenumber}% 
    \\fi 
  \\fi 

  \\global\\let\\\@LN\@maybe\@normalLineNumber\\relax}

\\newcommand*\\\@LN\@modulolinenos[1][\\z\@]{%
  \\let\\LineNumber\\themodulolinenumber
  \\ifnum#1>\\\@ne 
    \\chardef                      % v4.22, note below 
      \\c\@linenumbermodulo#1\\relax
  \\else\\ifnum#1=\\\@ne 
    \\def\\LineNumber{\\\@LN\@ifgreat\\thelinenumber}% 
  \\fi\\fi
  }

\\let\\\@LN\@ifgreat\\relax

\\newcommand*\\firstlinenumber[1]{% 
  \\chardef\\c\@firstlinenumber#1\\relax 

  \\let\\\@LN\@ifgreat\\\@LN\@ifgreat\@critical} 

\\def\\\@LN\@ifgreat\@critical{%
  \\ifnum\\c\@linenumber<\\c\@firstlinenumber 
    \\expandafter \\\@gobble 
  \\fi}% 

\\let\\c\@firstlinenumber=\\z\@

\\chardef\\c\@linenumbermodulo=5      % v4.2; ugly? 
\\modulolinenumbers[1]

\\DeclareOption{addpageno}{% 
  \\AtEndOfPackage{\\RequirePackage{vplref}[2005/04/25]}} 

\\DeclareOption{mathrefs}{\\AtBeginDocument 
  {\\RequirePackage{ednmath0}[2004/08/20]}} 

\\let\\if\@LN\@edtable\\iffalse 

\\DeclareOption{edtable}{\\let\\if\@LN\@edtable\\iftrue}

\\DeclareOption{longtable}{\\let\\if\@LN\@edtable\\iftrue 
  \\PassOptionsToPackage{longtable}{edtable}}

\\DeclareOption{nolongtablepatch}{% 
  \\PassOptionsToPackage{nolongtablepatch}{edtable}}

\\DeclareOption{left}{\\leftlinenumbers*}

\\DeclareOption{right}{\\rightlinenumbers*}

\\DeclareOption{switch}{\\setpagewiselinenumbers
                       \\switchlinenumbers
                       \\runningpagewiselinenumbers}

\\DeclareOption{switch*}{\\setpagewiselinenumbers
                        \\switchlinenumbers*%
                        \\runningpagewiselinenumbers}

\\DeclareOption{columnwise}{\\setpagewiselinenumbers
                           \\columnwiselinenumberstrue
                           \\realpagewiselinenumbers}

\\DeclareOption{pagewise}{\\setpagewiselinenumbers
                         \\realpagewiselinenumbers}

\\DeclareOption{running}{\\setrunninglinenumbers}

\\DeclareOption{modulo}{\\modulolinenumbers\\relax}

\\DeclareOption{modulo*}{\\modulolinenumbers*\\relax}

\\DeclareOption{mathlines}{\\linenumberdisplaymath}

\\DeclareOption{displaymath}{\\PackageWarningNoLine{lineno}{%
                Option [displaymath] is obsolete -- default now!}}

\\DeclareOption{hyperref}{\\PackageWarningNoLine{lineno}{%
                Option [hyperref] is obsolete. 
  \\MessageBreak The hyperref package is detected automatically.}}

\\AtBeginDocument{% 
  \\\@ifpackageloaded{nameref}{%
    \\gdef\\\@LN\@ExtraLabelItems{{}{}{}}% 
  }{%
    \\global\\let\\\@LN\@\@linelabel\\\@LN\@linelabel 
    \\gdef\\\@LN\@linelabel{% 
     \\expandafter 
      \\ifx\\csname ver\@nameref.sty\\endcsname\\relax \\else 
        \\gdef\\\@LN\@ExtraLabelItems{{}{}{}}% 
      \\fi 
      \\global\\let\\\@LN\@linelabel\\\@LN\@\@linelabel 
      \\global\\let\\\@LN\@\@linelabel\\relax 
      \\\@LN\@linelabel
    }% 
  }%
} 

\\ProcessOptions

\\if\@LN\@edtable \\RequirePackage{edtable}[2005/03/07] \\fi 
%%\\ifx\\do\@mlineno\\\@empty
 \\\@ifundefined{mathindent}{

%% \\AtBeginDocument{% 
  \\let\\LN\@displaymath\\[%
  \\let\\LN\@enddisplaymath\\]%
  \\renewcommand\\[{\\begin{linenomath}\\LN\@displaymath}%
  \\renewcommand\\]{\\LN\@enddisplaymath\\end{linenomath}}%
% 
  \\let\\LN\@equation\\equation
  \\let\\LN\@endequation\\endequation
  \\renewenvironment{equation}%
     {\\linenomath\\LN\@equation}%
     {\\LN\@endequation\\endlinenomath}%
%% }

 }{}% \\\@ifundefined{mathindent} -- 3rd arg v4.2, was \\par! 

%%\\AtBeginDocument{%
  \\let\\LN\@eqnarray\\eqnarray
  \\let\\LN\@endeqnarray\\endeqnarray
  \\renewenvironment{eqnarray}%
     {\\linenomath\\LN\@eqnarray}%
     {\\LN\@endeqnarray\\endlinenomath}%
\\let\\\@LN\@iglobal\\global                           % v4.22 

\\newcommand\\internallinenumbers{\\setrunninglinenumbers 
     \\let\\\@\@par\\internallinenumberpar
     \\ifx\\\@par\\\@\@\@par\\let\\\@par\\internallinenumberpar\\fi
     \\ifx\\par\\\@\@\@par\\let\\par\\internallinenumberpar\\fi
     \\ifx\\\@par\\linenumberpar\\let\\\@par\\internallinenumberpar\\fi
     \\ifx\\par\\linenumberpar\\let\\par\\internallinenumberpar\\fi
     \\\@ifnextchar[{\\resetlinenumber}%]
                 {\\\@ifstar{\\let\\c\@linenumber\\c\@internallinenumber
                           \\let\\\@LN\@iglobal\\relax % v4.22
                           \\c\@linenumber\\\@ne}{}}%
     }

\\let\\endinternallinenumbers\\endlinenumbers
\\\@namedef{internallinenumbers*}{\\internallinenumbers*}
\\expandafter\\let\\csname endinternallinenumbers*\\endcsname\\endlinenumbers

\\newcount\\c\@internallinenumber
\\newcount\\c\@internallinenumbers

\\newcommand\\internallinenumberpar{% 
     \\ifvmode\\\@\@\@par\\else\\ifinner\\\@\@\@par\\else\\\@\@\@par
     \\begingroup
        \\c\@internallinenumbers\\prevgraf
        \\setbox\\\@tempboxa\\hbox{\\vbox{\\makeinternalLinenumbers}}%
        \\dp\\\@tempboxa\\prevdepth
        \\ht\\\@tempboxa\\z\@
        \\nobreak\\vskip-\\prevdepth
        \\nointerlineskip\\box\\\@tempboxa
     \\endgroup 
     \\fi\\fi
     }

\\newcommand\\makeinternalLinenumbers{% 
   \\ifnum\\c\@internallinenumbers>\\z\@               % v4.2
   \\hb\@xt\@\\z\@{\\makeLineNumber}% 
   \\\@LN\@iglobal                                   % v4.22 
     \\advance\\c\@linenumber\\\@ne
   \\advance\\c\@internallinenumbers\\m\@ne
   \\expandafter\\makeinternalLinenumbers\\fi
   }
\\newcommand\\lineref{%
  \\ifx\\c\@linenumber\\c\@runninglinenumber
     \\expandafter\\linerefr
  \\else
     \\expandafter\\linerefp
  \\fi
}

\\newcommand*\\linerefp[2][\\z\@]{{%
   \\let\\\@thelinenumber\\thelinenumber
   \\edef\\thelinenumber{\\advance\\c\@linenumber#1\\relax
                       \\noexpand\\\@thelinenumber}%
   \\ref{#2}%
}}

% This goes deep into \\LaTeX's internals.

\\newcommand*\\linerefr[2][\\z\@]{{%
   \\def\\\@\@linerefadd{\\advance\\c\@linenumber#1}%
   \\expandafter\\\@setref\\csname r\@#2\\endcsname
   \\\@linerefadd{#2}%
}}

\\newcommand*\\\@linerefadd[2]{\\c\@linenumber=#1\\\@\@linerefadd\\relax
                            \\thelinenumber}

\\newcommand\\quotelinenumbers
   {\\\@ifstar\\linenumbers{\\\@ifnextchar[\\linenumbers{\\linenumbers*}}}

\\newdimen\\quotelinenumbersep
\\quotelinenumbersep=\\linenumbersep
\\let\\quotelinenumberfont\\linenumberfont

\\newcommand\\numquotelist
   {\\leftlinenumbers
    \\linenumbersep\\quotelinenumbersep
    \\let\\linenumberfont\\quotelinenumberfont
    \\addtolength{\\linenumbersep}{-\\\@totalleftmargin}%
    \\quotelinenumbers
   }

\\newenvironment{numquote}     {\\quote\\numquotelist}{\\endquote}
\\newenvironment{numquotation} {\\quotation\\numquotelist}{\\endquotation}
\\newenvironment{numquote*}    {\\quote\\numquotelist*}{\\endquote}
\\newenvironment{numquotation*}{\\quotation\\numquotelist*}{\\endquotation}

\\newenvironment{bframe}
  {\\par
   \\\@tempdima\\textwidth
   \\advance\\\@tempdima 2\\bframesep
   \\setbox\\bframebox\\hb\@xt\@\\textwidth{%
      \\hskip-\\bframesep
      \\vrule\\\@width\\bframerule\\\@height\\baselineskip\\\@depth\\bframesep
      \\advance\\\@tempdima-2\\bframerule
      \\hskip\\\@tempdima
      \\vrule\\\@width\\bframerule\\\@height\\baselineskip\\\@depth\\bframesep
      \\hskip-\\bframesep
   }%
   \\hbox{\\hskip-\\bframesep
         \\vrule\\\@width\\\@tempdima\\\@height\\bframerule\\\@depth\\z\@}%
   \\nointerlineskip
   \\copy\\bframebox
   \\nobreak
   \\kern-\\baselineskip
   \\runninglinenumbers
   \\def\\makeLineNumber{\\copy\\bframebox\\hss}%
  }
  {\\par
   \\kern-\\prevdepth
   \\kern\\bframesep
   \\nointerlineskip
   \\\@tempdima\\textwidth
   \\advance\\\@tempdima 2\\bframesep
   \\hbox{\\hskip-\\bframesep
         \\vrule\\\@width\\\@tempdima\\\@height\\bframerule\\\@depth\\z\@}%
  }

\\newdimen\\bframerule
\\bframerule=\\fboxrule

\\newdimen\\bframesep
\\bframesep=\\fboxsep

\\newbox\\bframebox
 

\\def\\PostponeVadjust#1{% 
  \\global\\let\\vadjust\\\@LN\@\@vadjust 

  \\vadjust{\\penalty-\\\@Mppvacodepen}% 
  \\g\@addto\@macro\\\@LN\@vadjustlist{#1\\\@lt}% 
}
\\let\\\@LN\@\@vadjust\\vadjust 
\\global\\let\\\@LN\@vadjustlist\\\@empty 
\\global\\let\\\@LN\@do\@vadjusts\\relax 

\\def\\PassVadjustList{% 
  \\unvbox\\\@cclv 
  \\expandafter \\\@LN\@xnext \\\@LN\@vadjustlist \\\@\@ 
                          \\\@tempa \\\@LN\@vadjustlist 
  \\ifx\\\@LN\@do\@vadjusts\\relax 
    \\gdef\\\@LN\@do\@vadjusts{\\global\\let\\\@LN\@do\@vadjusts\\relax}% 
  \\fi 
  \\expandafter \\g\@addto\@macro \\expandafter \\\@LN\@do\@vadjusts 
    \\expandafter {\\\@tempa}% 
} 

\\DeclareRobustCommand\\\@LN\@changevadjust{% 
  \\ifvmode\\else\\ifinner\\else 
    \\global\\let\\vadjust\\PostponeVadjust 
  \\fi\\fi 
} 
 
\\CheckCommand*\\\@parboxrestore{\\\@arrayparboxrestore\\let\\\\\\\@normalcr}

\\def\\\@tempa#1#2{% 
  \\expandafter \\def \\expandafter#2\\expandafter{\\expandafter
    \\ifLineNumbers\\expandafter#1\\expandafter\\fi#2}% 
} 

\\\@tempa\\nolinenumbers\\\@arrayparboxrestore 

\\\@tempa\\\@LN\@changevadjust\\vspace 
\\\@tempa\\\@LN\@changevadjust\\pagebreak 
\\\@tempa\\\@LN\@changevadjust\\nopagebreak 

\\DeclareRobustCommand\\\\{% 
  \\ifLineNumbers 
    \\expandafter \\\@LN\@cr 
  \\else 
    \\expandafter \\\@normalcr 
  \\fi 
} 
\\def\\\@LN\@cr{% 
  \\\@ifstar{\\\@LN\@changevadjust\\\@normalcr*}% 
          {\\\@ifnextchar[{\\\@LN\@changevadjust\\\@normalcr}\\\@normalcr}% 
} 

\\AtBeginDocument{% 
  \\let\\if\@LN\@obsolete\\iffalse 
  \\\@ifpackageloaded{linenox0}{\\let\\if\@LN\@obsolete\\iftrue}\\relax 
  \\\@ifpackageloaded{linenox1}{\\let\\if\@LN\@obsolete\\iftrue}\\relax 
  \\\@ifpackageloaded{lnopatch}{\\let\\if\@LN\@obsolete\\iftrue}\\relax
  \\if\@LN\@obsolete 
    \\PackageError{lineno}{Obsolete extension package(s)}{% 
    With lineno.sty version 4.00 or later,\\MessageBreak 
    linenox0/linenox1/lnopatch.sty must no longer be loaded.}% 
  \\fi 
} 

\\advance\\maxdeadcycles 100

\\endinput
END_LINENO_REVTEX
}

sub createLineno{
my $lineno_babar_file = "lineno_babar.sty";
open(LINENOFILE, "> $lineno_babar_file");
#print LINENOFILE $lineno_babar_code ;
#close(LINENOFILE);
#my $lineno_babar_code = << "END_LINENO4";
print LINENOFILE <<END_LINENO;

%              \\iffalse; awk '/S[H]ELL1/' lineno.sty|sh;exit; 
%             ...s see bottom for .tex documentation ... 
%
% Macro file lineno.sty for LaTeX: attach line numbers, refer to them. 
%                                                                           \\fi 
\\def\\fileversion{v4.41} \\def\\filedate{2005/11/02}                     %VERSION
%%% Copyright 1995--2003 Stephan I. B"ottcher <boettcher\@physik.uni-kiel.de>; 
%%% Copyright 2002--2005 Uwe L"uck, http://www.contact-ednotes.sty.de.vu 
%%%                      for version 4 and code from former Ednotes bundle 
%%%                      --author-maintained. 
%%% 
%%% This file can be redistributed and/or modified under 
%%% the terms of the LaTeX Project Public License; either 
%%% version 1.3a of the License, or any later version.
%%% The latest version of this license is in
%%%     http://www.latex-project.org/lppl.txt
%%% We did our best to help you, but there is NO WARRANTY. 
\\NeedsTeXFormat{LaTeX2e}[1994/12/01] 
%%                                                                [1994/11/04] 
\\ProvidesPackage{lineno_babar} 
  [\\filedate\\space line numbers on paragraphs \\fileversion] 

\\newcount\\linenopenalty\\linenopenalty=-100000

\\mathchardef\\linenopenaltypar=32000

\\mathchardef\\\@Mllbcodepen=11111 
\\mathchardef\\\@Mppvacodepen=11112

\\let\\\@tempa\\output
\\newtoks\\output
\\let\\\@LN\@output\\output
\\output=\\expandafter{\\the\\\@tempa}

\\\@tempa={%
            \\LineNoTest
            \\if\@tempswa

             \\ifnum\\outputpenalty=-\\\@Mllbcodepen 
                \\WriteLineNo 

              \\else 
                \\ifnum\\outputpenalty=-\\\@Mppvacodepen 
                  \\PassVadjustList 
                \\else 
   \\LineNoLaTeXOutput 
                \\fi 
              \\fi 
            \\else  
              \\MakeLineNo
            \\fi
            }

\\def\\LineNoTest{%
  \\let\\\@\@par\\\@\@\@par
  \\ifnum\\interlinepenalty<-\\linenopenaltypar
     \\advance\\interlinepenalty-\\linenopenalty
     \\\@LN\@nobreaktrue
     \\fi
  \\\@tempswatrue
  \\ifnum\\outputpenalty>-\\linenopenaltypar\\else
     \\ifnum\\outputpenalty>-188000\\relax
       \\\@tempswafalse
       \\fi
     \\fi
  }

\\def\\\@LN\@nobreaktrue{\\let\\if\@nobreak\\iftrue} % renamed v4.33

\\def\\LineNoLaTeXOutput{% 
  \\ifnum \\holdinginserts=\\thr\@\@   % v4.33 without \\\@tempswafalse
    \\global\\holdinginserts-\\thr\@\@ 
    \\unvbox\\\@cclv 
    \\ifnum \\outputpenalty=\\\@M \\else \\penalty\\outputpenalty \\fi 
  \\else
    \\if\@twocolumn \\let\\\@makecol\\\@LN\@makecol \\fi
 %\\\@ifnum{\\pagegrid\@col>\\\@ne}{
%\\let\\\@makecol\\\@LN\@makecol}{
%\\immediate\\message{the test on column number fails}
%}
%{\\ifnum(\\the\\c\@LN\@truepage=6){\\let\\\@makecol\\\@LN\@makecol}{}}
%\\let\\\@makecol\\\@LN\@makecol
    \\the\\\@LN\@output % finally following David Kastrup's advice. 
    \\ifnum \\holdinginserts=-\\thr\@\@ 
      \\global\\holdinginserts\\thr\@\@ \\fi 
  \\fi
}

\\def\\MakeLineNo{%
   \\\@LN\@maybe\@normalLineNumber                        % v4.31 
   \\boxmaxdepth\\maxdimen\\setbox\\z\@\\vbox{\\unvbox\\\@cclv}%
   \\\@tempdima\\dp\\z\@ \\unvbox\\z\@
   \\sbox\\\@tempboxa{\\hb\@xt\@\\z\@{\\makeLineNumber}}%
   \\stepLineNumber
   \\ht\\\@tempboxa\\z\@ \\\@LN\@depthbox 
   \\\@LN\@do\@vadjusts 
   \\count\@\\lastpenalty
   \\ifnum\\outputpenalty=-\\linenopenaltypar 
     \\ifnum\\count\@=\\z\@ \\else  
       \\xdef\\\@LN\@parpgbrk{% 
         \\penalty\\the\\count\@
         \\global\\let\\noexpand\\\@LN\@parpgbrk
                      \\noexpand\\\@LN\@screenoff\@pen}% v4.4 
     \\fi
   \\else
     \\\@tempcnta\\outputpenalty
     \\advance\\\@tempcnta -\\linenopenalty
     \\penalty \\ifnum\\count\@<\\\@tempcnta \\\@tempcnta \\else \\count\@ \\fi 
   \\fi
   }
\\newcommand\\stepLineNumber{\\stepcounter{linenumber}} 
\\def\\\@LN\@depthbox{% 
  \\dp\\\@tempboxa=\\\@tempdima
  \\nointerlineskip \\kern-\\\@tempdima \\box\\\@tempboxa} 

\\let\\\@\@\@par\\\@\@par
\\newcount\\linenoprevgraf

\\def\\linenumberpar{% 
  \\ifvmode \\\@\@\@par \\else 
    \\ifinner \\\@\@\@par \\else
      \\xdef\\\@LN\@outer\@holdins{\\the\\holdinginserts}% v4.2 
      \\advance \\interlinepenalty \\linenopenalty
      \\linenoprevgraf \\prevgraf
      \\global \\holdinginserts \\thr\@\@ 
      \\\@\@\@par
      \\ifnum\\prevgraf>\\linenoprevgraf
        \\penalty-\\linenopenaltypar
      \\fi
      \\\@LN\@parpgbrk 
      \\global\\holdinginserts\\\@LN\@outer\@holdins % v4.2
      \\advance\\interlinepenalty -\\linenopenalty
    \\fi     % from \\ifinner ... \\else 
  \\fi}      % from \\ifvmode ... \\else 

\\def\\\@LN\@screenoff\@pen{% 
  \\ifdim\\lastskip=\\z\@ 
    \\\@tempdima\\prevdepth \\setbox\\\@tempboxa\\null 
    \\\@LN\@depthbox                           \\fi}

\\global\\let\\\@LN\@parpgbrk\\\@LN\@screenoff\@pen 

\\newif\\ifLineNumbers \\LineNumbersfalse 

\\def\\linenumbers{% 
     \\LineNumberstrue                            % v4.00 
     \\xdef\\\@LN\@outer\@holdins{\\the\\holdinginserts}% v4.3 
     \\let\\\@\@par\\linenumberpar
 %      \\let\\linelabel\\\@LN\@linelabel % v4.11, removed v4.3 
     \\ifx\\\@par\\\@\@\@par\\let\\\@par\\linenumberpar\\fi
     \\ifx\\par\\\@\@\@par\\let\\par\\linenumberpar\\fi
     \\\@LN\@maybe\@moduloresume         % v4.31 
     \\\@ifnextchar[{\\resetlinenumber}%]
                 {\\\@ifstar{\\resetlinenumber}{}}%
     }


\\def\\nolinenumbers{% 
  \\LineNumbersfalse                              % v4.00
  \\let\\\@\@par\\\@\@\@par
 %   \\let\\linelabel\\\@LN\@LLerror      % v4.11, removed v4.3 
  \\ifx\\\@par\\linenumberpar\\let\\\@par\\\@\@\@par\\fi
  \\ifx\\par\\linenumberpar\\let\\par\\\@\@\@par\\fi
  }

\\def\\pagewiselinenumbers{\\linenumbers\\setpagewiselinenumbers}
\\def\\runninglinenumbers{\\setrunninglinenumbers\\linenumbers}

\\\@namedef{linenumbers*}{\\par\\linenumbers*}
\\\@namedef{runninglinenumbers*}{\\par\\runninglinenumbers*}

\\def\\endlinenumbers{\\par\\\@endpetrue}
\\let\\endrunninglinenumbers\\endlinenumbers
\\let\\endpagewiselinenumbers\\endlinenumbers
\\expandafter\\let\\csname endlinenumbers*\\endcsname\\endlinenumbers
\\expandafter\\let\\csname endrunninglinenumbers*\\endcsname\\endlinenumbers
\\let\\endnolinenumbers\\endlinenumbers
\\newcommand\\linenomathNonumbers{%
  \\ifLineNumbers 
%%  \\ifx\\\@\@par\\\@\@\@par\\else 
    \\ifnum\\interlinepenalty>-\\linenopenaltypar
      \\global\\holdinginserts\\thr\@\@ 
      \\advance\\interlinepenalty \\linenopenalty
     \\ifhmode                                   % v4.3 
      \\advance\\predisplaypenalty \\linenopenalty
     \\fi 
    \\fi
  \\fi
  \\ignorespaces
  }

\\newcommand\\linenomathWithnumbers{%
  \\ifLineNumbers 
%%  \\ifx\\\@\@par\\\@\@\@par\\else
    \\ifnum\\interlinepenalty>-\\linenopenaltypar
      \\global\\holdinginserts\\thr\@\@ 
      \\advance\\interlinepenalty \\linenopenalty
     \\ifhmode                                   % v4.3 
      \\advance\\predisplaypenalty \\linenopenalty
     \\fi 
      \\advance\\postdisplaypenalty \\linenopenalty
      \\advance\\interdisplaylinepenalty \\linenopenalty
    \\fi
  \\fi
  \\ignorespaces
  }


\\newcommand\\linenumberdisplaymath{%
  \\def\\linenomath{\\linenomathWithnumbers}%
  \\\@namedef{linenomath*}{\\linenomathNonumbers}%
  }

\\newcommand\\nolinenumberdisplaymath{%
  \\def\\linenomath{\\linenomathNonumbers}%
  \\\@namedef{linenomath*}{\\linenomathWithnumbers}%
  }

\\def\\endlinenomath{% 
  \\ifLineNumbers                            % v4.3 
   \\global\\holdinginserts\\\@LN\@outer\@holdins % v4.21 
  \\fi 
   \\global % v4.21 support for LaTeX2e earlier than 1996/07/26. 
   \\\@ignoretrue
}
\\expandafter\\let\\csname endlinenomath*\\endcsname\\endlinenomath

\\nolinenumberdisplaymath

\\let\\\@LN\@ExtraLabelItems\\\@empty

\\def\\\@LN\@xnext#1\\\@lt#2\\\@\@#3#4{\\def#3{#1}\\gdef#4{#2}}

\\global\\let\\\@LN\@labellist\\\@empty 

\\def\\WriteLineNo{% 
  \\unvbox\\\@cclv 
  \\expandafter \\\@LN\@xnext \\\@LN\@labellist \\\@\@ 
                          \\\@LN\@label \\\@LN\@labellist 
  \\protected\@write\\\@auxout{}{\\string\\newlabel{\\\@LN\@label}% 
         {{\\theLineNumber}{\\thepage}\\\@LN\@ExtraLabelItems}}% 
}

\\def\\\@LN\@LLerror{\\PackageError{lineno}{% 
  \\string\\linelabel\\space without \\string\\linenumbers}{% 
  Just see documentation. (New feature v4.11)}\\\@gobble}


\\newcommand\\linelabel{% 
  \\ifLineNumbers \\expandafter \\\@LN\@linelabel 
  \\else          \\expandafter \\\@LN\@LLerror   \\fi}

\\gdef\\\@LN\@linelabel#1{% 
  \\ifx\\protect\\\@typeset\@protect 
   \\ifvmode
       \\ifinner \\else 
          \\leavevmode \\\@bsphack \\\@savsk\\p\@
       \\fi
   \\else
       \\\@bsphack
   \\fi
   \\ifhmode
     \\ifinner
       \\\@parmoderr
     \\else
       \\\@LN\@postlabel{#1}% 
       \\\@esphack 
     \\fi
   \\else
     \\\@LN\@mathhook{#1}%
   \\fi
  \\fi 
   }

\\def\\\@LN\@postlabel#1{\\g\@addto\@macro\\\@LN\@labellist{#1\\\@lt}%
       \\vadjust{\\penalty-\\\@Mllbcodepen}} 
\\def\\\@LN\@mathhook#1{\\\@parmoderr}

\\def\\makeLineNumberLeft{% 
  \\hss\\linenumberfont\\LineNumber\\hskip\\linenumbersep}

\\def\\makeLineNumberRight{% 
  \\linenumberfont\\hskip\\linenumbersep\\hskip\\columnwidth
  \\hb\@xt\@\\linenumberwidth{\\hss\\LineNumber}\\hss}

\\def\\linenumberfont{\\normalfont\\tiny\\sffamily}

\\newdimen\\linenumbersep
\\newdimen\\linenumberwidth

\\linenumberwidth=10pt
\\linenumbersep=10pt

\\def\\switchlinenumbers{\\\@ifstar
    {\\let\\makeLineNumberOdd\\makeLineNumberRight
     \\let\\makeLineNumberEven\\makeLineNumberLeft}%
    {\\let\\makeLineNumberOdd\\makeLineNumberLeft
     \\let\\makeLineNumberEven\\makeLineNumberRight}%
    }

\\def\\setmakelinenumbers#1{\\\@ifstar
  {\\let\\makeLineNumberRunning#1%
   \\let\\makeLineNumberOdd#1%
   \\let\\makeLineNumberEven#1}%
  {\\ifx\\c\@linenumber\\c\@runninglinenumber
      \\let\\makeLineNumberRunning#1%
   \\else
      \\let\\makeLineNumberOdd#1%
      \\let\\makeLineNumberEven#1%
   \\fi}%
  }

\\def\\leftlinenumbers{\\setmakelinenumbers\\makeLineNumberLeft}
\\def\\rightlinenumbers{\\setmakelinenumbers\\makeLineNumberRight}

\\leftlinenumbers*

\\newcounter{linenumber}
\\newcount\\c\@pagewiselinenumber
\\let\\c\@runninglinenumber\\c\@linenumber

\\newcommand*\\resetlinenumber[1][\\\@ne]{% 
  \\global                             % v4.22
  \\c\@runninglinenumber#1\\relax}

\\def\\makeRunningLineNumber{\\makeLineNumberRunning}

\\def\\setrunninglinenumbers{%
   \\def\\theLineNumber{\\thelinenumber}%
   \\let\\c\@linenumber\\c\@runninglinenumber
   \\let\\makeLineNumber\\makeRunningLineNumber
   }

\\setrunninglinenumbers\\resetlinenumber

\\def\\setpagewiselinenumbers{%
   \\let\\theLineNumber\\thePagewiseLineNumber
   \\let\\c\@linenumber\\c\@pagewiselinenumber
   \\let\\makeLineNumber\\makePagewiseLineNumber
   }

\\def\\makePagewiseLineNumber{\\logtheLineNumber\\getLineNumber
  \\ifoddNumberedPage
     \\makeLineNumberOdd
  \\else
     \\makeLineNumberEven
  \\fi
  }

\\def\\logtheLineNumber{\\protected\@write\\\@auxout{}{%
   \\string\\\@LN{\\the\\c\@linenumber}{% 
     \\noexpand\\the\\c\@LN\@truepage}}
%\\immediate\\message{\\string\\\@LN{\\the\\c\@linenumber}{\\the\\c\@LN\@truepage}}
} 
\\newcount\\c\@LN\@truepage 
\\g\@addto\@macro\\cl\@page{\\global\\advance\\c\@LN\@truepage\\\@ne}
\\\@addtoreset{LN\@truepage}{\@ckpt}

\\def\\LastNumberedPage{first} 
\\def\\LN\@Pfirst{\\nextLN\\relax}

\\let\\lastLN\\relax  % compare to last line on this page
\\let\\firstLN\\relax % compare to first line on this page
\\let\\pageLN\\relax  % get the page number, compute the linenumber
\\let\\nextLN\\relax  % move to the next page


\\AtEndDocument{
\\let\\\@LN\\\@gobbletwo
%\\onecolumngrid
}

\\def\\\@LN#1#2{{\\expandafter\\\@\@LN
                 \\csname LN\@P#2C\\\@LN\@column\\expandafter\\endcsname
                 \\csname LN\@PO#2\\endcsname
                 {#1}{#2}}}

\\def\\\@\@LN#1#2#3#4{\\ifx#1\\relax
    \\ifx#2\\relax\\gdef#2{#3}\\fi
    \\expandafter\\\@\@\@LN\\csname LN\@P\\LastNumberedPage\\endcsname#1% 
    \\xdef#1{\\lastLN{#3}\\firstLN{#3}% 
            \\pageLN{#4}{\\\@LN\@column}{#2}\\nextLN\\relax}%
  \\else
    \\def\\lastLN##1{\\noexpand\\lastLN{#3}}%
    \\xdef#1{#1}%
  \\fi
  \\xdef\\LastNumberedPage{#4C\\\@LN\@column}}

\\def\\\@\@\@LN#1#2{{\\def\\nextLN##1{\\noexpand\\nextLN\\noexpand#2}%
                \\xdef#1{#1}}}


\\def\\NumberedPageCache{\\LN\@Pfirst}

\\def\\testLastNumberedPage#1{\\ifnum#1<\\c\@linenumber
      \\let\\firstLN\\\@gobble
  \\fi}

\\def\\testFirstNumberedPage#1{\\ifnum#1>\\c\@linenumber
     \\def\\nextLN##1{\\testNextNumberedPage\\LN\@Pfirst}%
  \\else
      \\let\\nextLN\\\@gobble
      \\def\\pageLN{\\gotNumberedPage{#1}}%
  \\fi}

\\long\\def \\\@gobblethree #1#2#3{}

\\def\\testNumberedPage{%
  \\let\\lastLN\\testLastNumberedPage
  \\let\\firstLN\\testFirstNumberedPage
  \\let\\pageLN\\\@gobblethree
  \\let\\nextLN\\testNextNumberedPage
  \\NumberedPageCache
  }

\\def\\testNextNumberedPage#1{\\ifx#1\\relax
     \\global\\def\\NumberedPageCache{\\gotNumberedPage0000}%
     \\PackageWarningNoLine{lineno}%
                    {Linenumber reference failed,
      \\MessageBreak  rerun to get it right}%
   \\else
     \\global\\let\\NumberedPageCache#1%
   \\fi
   \\testNumberedPage
   }

\\let\\getLineNumber\\testNumberedPage


\\newif\\ifoddNumberedPage
\\newif\\ifcolumnwiselinenumbers
\\columnwiselinenumbersfalse

\\def\\gotNumberedPage#1#2#3#4{\\oddNumberedPagefalse
  \\ifodd \\if\@twocolumn #3\\else #2\\fi\\relax\\oddNumberedPagetrue\\fi
%\\ifodd \\\@ifnum{\\pagegrid\@col>\\\@ne}{#3
%\\immediate\\message{we are not failing the twocolumn test}
%}{#2
%\\ifnum(\\the\\c\@LN\@truepage=6){#3}{#2}
%\\immediate\\message{we are failing the twocolumn test}
%}
%\\relax\\oddNumberedPagetrue\\fi
  \\advance\\c\@linenumber\\\@ne 
  \\ifcolumnwiselinenumbers
     \\subtractlinenumberoffset{#1}%
  \\else
     \\subtractlinenumberoffset{#4}%
  \\fi
  }


\\def\\runningpagewiselinenumbers{%
  \\let\\subtractlinenumberoffset\\\@gobble
  }

\\def\\realpagewiselinenumbers{%
  \\def\\subtractlinenumberoffset##1{\\advance\\c\@linenumber-##1\\relax}%
  }

\\realpagewiselinenumbers


\\def\\thePagewiseLineNumber{\\protect 
       \\getpagewiselinenumber{\\the\\c\@linenumber}}%

\\def\\getpagewiselinenumber#1{{%
  \\c\@linenumber #1\\relax\\testNumberedPage
  \\thelinenumber
  }}

\\AtBeginDocument{% v4.2, revtex4.cls (e.g.). 
 % <- TODO v4.4+: Or better in \\LineNoLaTeXOutput!? 
  \\let\\\@LN\@orig\@makecol\\\@makecol} 
\\def\\\@LN\@makecol{%
   \\\@LN\@orig\@makecol
\\setbox\\\@outputbox 
\\vbox{%
      \\boxmaxdepth \\\@maxdepth
      \\protected\@write\\\@auxout{}{% 
          \\string\\\@LN\@col{\\if\@firstcolumn1\\else2\\fi}%
      }%
      \\box\\\@outputbox 
} %% TODO cf. revtexln.sty. 
}
\\def\\\@LN\@col{\\def\\\@LN\@column} % v4.22, removed #1. 
\\\@LN\@col{1}

\\def\\themodulolinenumber{\\relax
  \\ifnum\\c\@linenumber<\\c\@firstlinenumber \\else 
    \\begingroup 
      \\\@tempcnta\\c\@linenumber
      \\advance\\\@tempcnta-\\c\@firstlinenumber 
      \\divide\\\@tempcnta\\c\@linenumbermodulo
      \\multiply\\\@tempcnta\\c\@linenumbermodulo
      \\advance\\\@tempcnta\\c\@firstlinenumber 
      \\ifnum\\\@tempcnta=\\c\@linenumber \\thelinenumber \\fi
    \\endgroup 
  \\fi 
}

\\newcommand\\modulolinenumbers{% 
  \\\@ifstar
    {\\def\\\@LN\@maybe\@moduloresume{% 
       \\global\\let\\\@LN\@maybe\@normalLineNumber
                            \\\@LN\@normalLineNumber}% 
                                       \\\@LN\@modulolinenos}% 
    {\\let\\\@LN\@maybe\@moduloresume\\relax \\\@LN\@modulolinenos}%
}

\\global\\let\\\@LN\@maybe\@normalLineNumber\\relax 
\\let\\\@LN\@maybe\@moduloresume\\relax 
\\gdef\\\@LN\@normalLineNumber{% 
  \\ifnum\\c\@linenumber=\\c\@firstlinenumber \\else 
    \\ifnum\\c\@linenumber>\\\@ne
      \\def\\LineNumber{\\thelinenumber}% 
    \\fi 
  \\fi 

  \\global\\let\\\@LN\@maybe\@normalLineNumber\\relax}

\\newcommand*\\\@LN\@modulolinenos[1][\\z\@]{%
  \\let\\LineNumber\\themodulolinenumber
  \\ifnum#1>\\\@ne 
    \\chardef                      % v4.22, note below 
      \\c\@linenumbermodulo#1\\relax
  \\else\\ifnum#1=\\\@ne 
    \\def\\LineNumber{\\\@LN\@ifgreat\\thelinenumber}% 
  \\fi\\fi
  }

\\let\\\@LN\@ifgreat\\relax

\\newcommand*\\firstlinenumber[1]{% 
  \\chardef\\c\@firstlinenumber#1\\relax 

  \\let\\\@LN\@ifgreat\\\@LN\@ifgreat\@critical} 

\\def\\\@LN\@ifgreat\@critical{%
  \\ifnum\\c\@linenumber<\\c\@firstlinenumber 
    \\expandafter \\\@gobble 
  \\fi}% 

\\let\\c\@firstlinenumber=\\z\@

\\chardef\\c\@linenumbermodulo=5      % v4.2; ugly? 
\\modulolinenumbers[1]

\\DeclareOption{addpageno}{% 
  \\AtEndOfPackage{\\RequirePackage{vplref}[2005/04/25]}} 

\\DeclareOption{mathrefs}{\\AtBeginDocument 
  {\\RequirePackage{ednmath0}[2004/08/20]}} 

\\let\\if\@LN\@edtable\\iffalse 

\\DeclareOption{edtable}{\\let\\if\@LN\@edtable\\iftrue}

\\DeclareOption{longtable}{\\let\\if\@LN\@edtable\\iftrue 
  \\PassOptionsToPackage{longtable}{edtable}}

\\DeclareOption{nolongtablepatch}{% 
  \\PassOptionsToPackage{nolongtablepatch}{edtable}}

\\DeclareOption{left}{\\leftlinenumbers*}

\\DeclareOption{right}{\\rightlinenumbers*}

\\DeclareOption{switch}{\\setpagewiselinenumbers
                       \\switchlinenumbers
                       \\runningpagewiselinenumbers}

\\DeclareOption{switch*}{\\setpagewiselinenumbers
                        \\switchlinenumbers*%
                        \\runningpagewiselinenumbers}

\\DeclareOption{columnwise}{\\setpagewiselinenumbers
                           \\columnwiselinenumberstrue
                           \\realpagewiselinenumbers}

\\DeclareOption{pagewise}{\\setpagewiselinenumbers
                         \\realpagewiselinenumbers}

\\DeclareOption{running}{\\setrunninglinenumbers}

\\DeclareOption{modulo}{\\modulolinenumbers\\relax}

\\DeclareOption{modulo*}{\\modulolinenumbers*\\relax}

\\DeclareOption{mathlines}{\\linenumberdisplaymath}

\\DeclareOption{displaymath}{\\PackageWarningNoLine{lineno}{%
                Option [displaymath] is obsolete -- default now!}}

\\DeclareOption{hyperref}{\\PackageWarningNoLine{lineno}{%
                Option [hyperref] is obsolete. 
  \\MessageBreak The hyperref package is detected automatically.}}

\\AtBeginDocument{% 
  \\\@ifpackageloaded{nameref}{%
    \\gdef\\\@LN\@ExtraLabelItems{{}{}{}}% 
  }{%
    \\global\\let\\\@LN\@\@linelabel\\\@LN\@linelabel 
    \\gdef\\\@LN\@linelabel{% 
     \\expandafter 
      \\ifx\\csname ver\@nameref.sty\\endcsname\\relax \\else 
        \\gdef\\\@LN\@ExtraLabelItems{{}{}{}}% 
      \\fi 
      \\global\\let\\\@LN\@linelabel\\\@LN\@\@linelabel 
      \\global\\let\\\@LN\@\@linelabel\\relax 
      \\\@LN\@linelabel
    }% 
  }%
} 

\\ProcessOptions

\\if\@LN\@edtable \\RequirePackage{edtable}[2005/03/07] \\fi 
%%\\ifx\\do\@mlineno\\\@empty
 \\\@ifundefined{mathindent}{

%% \\AtBeginDocument{% 
  \\let\\LN\@displaymath\\[%
  \\let\\LN\@enddisplaymath\\]%
  \\renewcommand\\[{\\begin{linenomath}\\LN\@displaymath}%
  \\renewcommand\\]{\\LN\@enddisplaymath\\end{linenomath}}%
% 
  \\let\\LN\@equation\\equation
  \\let\\LN\@endequation\\endequation
  \\renewenvironment{equation}%
     {\\linenomath\\LN\@equation}%
     {\\LN\@endequation\\endlinenomath}%
%% }

 }{}% \\\@ifundefined{mathindent} -- 3rd arg v4.2, was \\par! 

%%\\AtBeginDocument{%
  \\let\\LN\@eqnarray\\eqnarray
  \\let\\LN\@endeqnarray\\endeqnarray
  \\renewenvironment{eqnarray}%
     {\\linenomath\\LN\@eqnarray}%
     {\\LN\@endeqnarray\\endlinenomath}%
\\let\\\@LN\@iglobal\\global                           % v4.22 

\\newcommand\\internallinenumbers{\\setrunninglinenumbers 
     \\let\\\@\@par\\internallinenumberpar
     \\ifx\\\@par\\\@\@\@par\\let\\\@par\\internallinenumberpar\\fi
     \\ifx\\par\\\@\@\@par\\let\\par\\internallinenumberpar\\fi
     \\ifx\\\@par\\linenumberpar\\let\\\@par\\internallinenumberpar\\fi
     \\ifx\\par\\linenumberpar\\let\\par\\internallinenumberpar\\fi
     \\\@ifnextchar[{\\resetlinenumber}%]
                 {\\\@ifstar{\\let\\c\@linenumber\\c\@internallinenumber
                           \\let\\\@LN\@iglobal\\relax % v4.22
                           \\c\@linenumber\\\@ne}{}}%
     }

\\let\\endinternallinenumbers\\endlinenumbers
\\\@namedef{internallinenumbers*}{\\internallinenumbers*}
\\expandafter\\let\\csname endinternallinenumbers*\\endcsname\\endlinenumbers

\\newcount\\c\@internallinenumber
\\newcount\\c\@internallinenumbers

\\newcommand\\internallinenumberpar{% 
     \\ifvmode\\\@\@\@par\\else\\ifinner\\\@\@\@par\\else\\\@\@\@par
     \\begingroup
        \\c\@internallinenumbers\\prevgraf
        \\setbox\\\@tempboxa\\hbox{\\vbox{\\makeinternalLinenumbers}}%
        \\dp\\\@tempboxa\\prevdepth
        \\ht\\\@tempboxa\\z\@
        \\nobreak\\vskip-\\prevdepth
        \\nointerlineskip\\box\\\@tempboxa
     \\endgroup 
     \\fi\\fi
     }

\\newcommand\\makeinternalLinenumbers{% 
   \\ifnum\\c\@internallinenumbers>\\z\@               % v4.2
   \\hb\@xt\@\\z\@{\\makeLineNumber}% 
   \\\@LN\@iglobal                                   % v4.22 
     \\advance\\c\@linenumber\\\@ne
   \\advance\\c\@internallinenumbers\\m\@ne
   \\expandafter\\makeinternalLinenumbers\\fi
   }
\\newcommand\\lineref{%
  \\ifx\\c\@linenumber\\c\@runninglinenumber
     \\expandafter\\linerefr
  \\else
     \\expandafter\\linerefp
  \\fi
}

\\newcommand*\\linerefp[2][\\z\@]{{%
   \\let\\\@thelinenumber\\thelinenumber
   \\edef\\thelinenumber{\\advance\\c\@linenumber#1\\relax
                       \\noexpand\\\@thelinenumber}%
   \\ref{#2}%
}}

% This goes deep into \\LaTeX's internals.

\\newcommand*\\linerefr[2][\\z\@]{{%
   \\def\\\@\@linerefadd{\\advance\\c\@linenumber#1}%
   \\expandafter\\\@setref\\csname r\@#2\\endcsname
   \\\@linerefadd{#2}%
}}

\\newcommand*\\\@linerefadd[2]{\\c\@linenumber=#1\\\@\@linerefadd\\relax
                            \\thelinenumber}

\\newcommand\\quotelinenumbers
   {\\\@ifstar\\linenumbers{\\\@ifnextchar[\\linenumbers{\\linenumbers*}}}

\\newdimen\\quotelinenumbersep
\\quotelinenumbersep=\\linenumbersep
\\let\\quotelinenumberfont\\linenumberfont

\\newcommand\\numquotelist
   {\\leftlinenumbers
    \\linenumbersep\\quotelinenumbersep
    \\let\\linenumberfont\\quotelinenumberfont
    \\addtolength{\\linenumbersep}{-\\\@totalleftmargin}%
    \\quotelinenumbers
   }

\\newenvironment{numquote}     {\\quote\\numquotelist}{\\endquote}
\\newenvironment{numquotation} {\\quotation\\numquotelist}{\\endquotation}
\\newenvironment{numquote*}    {\\quote\\numquotelist*}{\\endquote}
\\newenvironment{numquotation*}{\\quotation\\numquotelist*}{\\endquotation}

\\newenvironment{bframe}
  {\\par
   \\\@tempdima\\textwidth
   \\advance\\\@tempdima 2\\bframesep
   \\setbox\\bframebox\\hb\@xt\@\\textwidth{%
      \\hskip-\\bframesep
      \\vrule\\\@width\\bframerule\\\@height\\baselineskip\\\@depth\\bframesep
      \\advance\\\@tempdima-2\\bframerule
      \\hskip\\\@tempdima
      \\vrule\\\@width\\bframerule\\\@height\\baselineskip\\\@depth\\bframesep
      \\hskip-\\bframesep
   }%
   \\hbox{\\hskip-\\bframesep
         \\vrule\\\@width\\\@tempdima\\\@height\\bframerule\\\@depth\\z\@}%
   \\nointerlineskip
   \\copy\\bframebox
   \\nobreak
   \\kern-\\baselineskip
   \\runninglinenumbers
   \\def\\makeLineNumber{\\copy\\bframebox\\hss}%
  }
  {\\par
   \\kern-\\prevdepth
   \\kern\\bframesep
   \\nointerlineskip
   \\\@tempdima\\textwidth
   \\advance\\\@tempdima 2\\bframesep
   \\hbox{\\hskip-\\bframesep
         \\vrule\\\@width\\\@tempdima\\\@height\\bframerule\\\@depth\\z\@}%
  }

\\newdimen\\bframerule
\\bframerule=\\fboxrule

\\newdimen\\bframesep
\\bframesep=\\fboxsep

\\newbox\\bframebox
 

\\def\\PostponeVadjust#1{% 
  \\global\\let\\vadjust\\\@LN\@\@vadjust 

  \\vadjust{\\penalty-\\\@Mppvacodepen}% 
  \\g\@addto\@macro\\\@LN\@vadjustlist{#1\\\@lt}% 
}
\\let\\\@LN\@\@vadjust\\vadjust 
\\global\\let\\\@LN\@vadjustlist\\\@empty 
\\global\\let\\\@LN\@do\@vadjusts\\relax 

\\def\\PassVadjustList{% 
  \\unvbox\\\@cclv 
  \\expandafter \\\@LN\@xnext \\\@LN\@vadjustlist \\\@\@ 
                          \\\@tempa \\\@LN\@vadjustlist 
  \\ifx\\\@LN\@do\@vadjusts\\relax 
    \\gdef\\\@LN\@do\@vadjusts{\\global\\let\\\@LN\@do\@vadjusts\\relax}% 
  \\fi 
  \\expandafter \\g\@addto\@macro \\expandafter \\\@LN\@do\@vadjusts 
    \\expandafter {\\\@tempa}% 
} 

\\DeclareRobustCommand\\\@LN\@changevadjust{% 
  \\ifvmode\\else\\ifinner\\else 
    \\global\\let\\vadjust\\PostponeVadjust 
  \\fi\\fi 
} 
 
\\CheckCommand*\\\@parboxrestore{\\\@arrayparboxrestore\\let\\\\\\\@normalcr}

\\def\\\@tempa#1#2{% 
  \\expandafter \\def \\expandafter#2\\expandafter{\\expandafter
    \\ifLineNumbers\\expandafter#1\\expandafter\\fi#2}% 
} 

\\\@tempa\\nolinenumbers\\\@arrayparboxrestore 

\\\@tempa\\\@LN\@changevadjust\\vspace 
\\\@tempa\\\@LN\@changevadjust\\pagebreak 
\\\@tempa\\\@LN\@changevadjust\\nopagebreak 

\\DeclareRobustCommand\\\\{% 
  \\ifLineNumbers 
    \\expandafter \\\@LN\@cr 
  \\else 
    \\expandafter \\\@normalcr 
  \\fi 
} 
\\def\\\@LN\@cr{% 
  \\\@ifstar{\\\@LN\@changevadjust\\\@normalcr*}% 
          {\\\@ifnextchar[{\\\@LN\@changevadjust\\\@normalcr}\\\@normalcr}% 
} 

\\AtBeginDocument{% 
  \\let\\if\@LN\@obsolete\\iffalse 
  \\\@ifpackageloaded{linenox0}{\\let\\if\@LN\@obsolete\\iftrue}\\relax 
  \\\@ifpackageloaded{linenox1}{\\let\\if\@LN\@obsolete\\iftrue}\\relax 
  \\\@ifpackageloaded{lnopatch}{\\let\\if\@LN\@obsolete\\iftrue}\\relax
  \\if\@LN\@obsolete 
    \\PackageError{lineno}{Obsolete extension package(s)}{% 
    With lineno.sty version 4.00 or later,\\MessageBreak 
    linenox0/linenox1/lnopatch.sty must no longer be loaded.}% 
  \\fi 
} 

\\advance\\maxdeadcycles 100

\\endinput
END_LINENO
}

#close(LINENOFILE);


sub doCmd {
    
    print "Running: $_[0]\n";
    print `$_[0]`;
}



sub main {

    if(@ARGV < 1){
	die("Not enough arguments.\n "
           ."Please enter the name of the main tex file as argument");
    }


    open(INPUTFILE, "$ARGV[0]") 
	or die ("Cannot open file '$ARGV[0]' for reading\n");

    
    my $newTexFileName = $ARGV[0];

    if($newTexFileName =~ m/_linenum/){
	die("File has already been processed.\n "
	    ."Please enter the name of the main tex file as argument");
    }

    $newTexFileName =~ s/.tex//;
    $newTexFileName = $newTexFileName."_linenum.tex";

    open(OUTPUTFILE, "> $newTexFileName"); 	



    print "Creating new Tex file $newTexFileName \n";

    my $mainData;
       
#    my @mainData    = <INPUTFILE>;

    while(<INPUTFILE>) {

	$mainData .= $_;

    }

# check if other .tex files are input
# add the content to filename.tex 

#    my $inputData;
    my ($input,$input_name);

    while(($mainData =~ m/\n\s*\\input\s*{\s*([\w\-]+[\/\w\-]*)\.tex\s*}/)
       ||($mainData =~ m/\n\s*\\input\s*{\s*([\w\-]+[\/\w\-]*)\s*}/)
       ||($mainData =~ m/\n\s*\\input\s+([\w\-]+[\/\w\-]*)\.tex/)
	  ||($mainData =~ m/\n\s*\\input\s+([\w\-]+[\/\w\-]*)/)
	  ||($mainData =~ m/\n\s*\\include\s*{\s*([\w\-]+[\/\w\-]*)\.tex\s*}/)
	  ||($mainData =~ m/\n\s*\\include\s*{\s*([\w\-]+[\/\w\-]*)\s*}/)
	  ||($mainData =~ m/\n\s*\\include\s+([\w\-]+[\/\w\-]*)\.tex/)
	  ||($mainData =~ m/\n\s*\\include\s+([\w\-]+[\/\w\-]*)/)

)
#while(($mainData =~ m/\n\\input\s+(\w+)/g))
{

        $input_name = $1;
	print "opening '$input_name.tex' \n";
	open(NEWINPUTFILE, "$input_name.tex");
	 #   or die ("Cannot open file '$input_name.tex' for reading\n");
	while(<NEWINPUTFILE>) {
	    $input .= $_;
	}
	#@inputData = <NEWINPUTFILE>;

#	$mainData =~ s/\n\\input{$1\.tex}/\n$input/g; 
#	$mainData =~ s/\n\\input{$1}/\n$input/g; 
#	$mainData =~ s/\n\\input\s+$1\.tex/\n$input/g; 
#	$mainData =~ s/\n\\input\s+$1/\n$input/g; 
	$mainData =~ s/\n(\s*)\\input{\s*$input_name\.tex\s*}/\n$1$input/g; 
	$mainData =~ s/\n(\s*)\\input{\s*$input_name\s*}/\n$1$input/g; 
	$mainData =~ s/\n(\s*)\\input\s+$input_name\.tex/\n$1$input/g; 
        $mainData =~ s/\n(\s*)\\input\s+$input_name/\n$1$input/g; 

	$mainData =~ s/\n(\s*)\\include{\s*$input_name\.tex\s*}/\n$1$input/g; 
	$mainData =~ s/\n(\s*)\\include{\s*$input_name\s*}/\n$1$input/g; 
	$mainData =~ s/\n(\s*)\\include\s+$input_name\.tex/\n$1$input/g; 
        $mainData =~ s/\n(\s*)\\include\s+$input_name/\n$1$input/g; 

	close NEWINPUTFILE;
	$input = "";
	$input_name = "";

}

#my $lineno_babar_file = "lineno_babar.sty";

if($mainData =~ m/\n\s*\\documentclass.*{revtex4}/){
    createLinenoRevtex;
#$mainData =~ s/\n\\documentclass/\n\\RequirePackage[switch]{\/afs\/slac.stanford.edu\/g\/babar\/bin\/lineno4}\n\\documentclass/;

#    $mainData =~ s/\n\\documentclass/\n\\RequirePackage[switch]{$lineno_babar_code}\n\\documentclass/;
# $mainData =~ s/\n\\documentclass/\n$lineno_babar_code\n\\documentclass/;
    $mainData =~ s/\n\s*\\documentclass/\n\\RequirePackage[switch]{lineno_babar_revtex}\n\\documentclass/;

}elsif($mainData =~ m/\n\s*\\documentclass/){

    createLineno;
#$mainData =~ s/\n\\documentclass/\n\\RequirePackage[switch]{lineno}\n\\documentclass/;
$mainData =~ s/\n\s*\\documentclass/\n\\RequirePackage[switch]{lineno_babar}\n\\documentclass/;

}elsif($mainData =~ m/\s*\\documentclass.*{revtex4}/){
    createLinenoRevtex;
#    open(LINENOFILE, $lineno_babar_file);
#    print LINENOFILE $lineno_babar_code;
#    close(LINENOFILE);

    $mainData =~ s/\s*\\documentclass/\n\\RequirePackage[switch]{lineno_babar_revtex}\n\\documentclass/;
#  $mainData =~ s/\n\\documentclass/\n$lineno_babar_code\n\\documentclass/;
#$mainData =~ s/\\documentclass/\n$lineno_babar\n\\documentclass/;

}else{

    createLineno;
#$mainData =~ s/\\documentclass/\n\\RequirePackage[switch]{\/afs\/slac.stanford.edu\/g\/babar\/bin\/lineno4}\n\\documentclass/;
#$mainData =~ s/\\documentclass/\n\\RequirePackage[switch]{$lineno_babar}\n\\documentclass/;
$mainData =~ s/\s*\\documentclass/\n\\RequirePackage[switch]{lineno_babar}\n\\documentclass/;

}


  if($mainData =~ m/\n\s*\\maketitle/) {
	
	$mainData =~ s/\n\s*\\maketitle/\n\\maketitle\n\\begin{linenumbers}/;
	
    }elsif($mainData =~ m/\n\s*\\begin{abstract}/) {
	
	$mainData =~ s/\n\s*\\end{abstract}/\n\\end{abstract}\n\\begin{linenumbers}/;
    
	}else{
	
	    $mainData =~ s/\n\s*\\begin{document}/\n\\begin{document}\n\\begin{linenumbers}/;
    
}


if($mainData =~ m/\n\s*\\begin{thebibliography}/) {

    $mainData =~ s/\n\s*\\begin{thebibliography}/\n\\end{linenumbers}\n\\begin{thebibliography}/;    

}elsif($mainData =~ m/\n\s*\\bibliography/) {

    $mainData =~ s/\n\s*\\bibliography/\n\\end{linenumbers}\n\\bibliography/;

}else{

    $mainData =~ s/\n\s*\\end{document}/\n\\end{linenumbers}\n\\end{document}/;

}


#if($mainData =~ m/\\begin{thebibliography}/) {
#
#    if($mainData =~ m/\\begin{abstract}/) {
#	
#	$mainData =~ s/\n\s*\\end{abstract}/\n\\end{abstract}\n\\begin{linenumbers}/;
#	
#    }elsif($mainData =~ m/maketitle/) {
#	
#	$mainData =~ s/\n\s*\\maketitle/\n\\maketitle\n\\begin{linenumbers}/;
#    
#	}else{
#	
#	    $mainData =~ s/\n\s*\\begin{document}/\n\\begin{document}\n\\begin{linenumbers}/;
#    
#}
#
#
#    $mainData =~ s/\n\s*\\begin{thebibliography}/\n\\end{linenumbers}\n\\begin{thebibliography}/;
#    
#
#}elsif($mainData =~ m/\\bibliography/) {
#
#    if($mainData =~ m/\\begin{abstract}/) {
#	
#	$mainData =~ s/\n\s*\\end{abstract}/\n\\end{abstract}\n\\begin{linenumbers}/;
#	
#    }elsif($mainData =~ m/maketitle/) {
#	
#	$mainData =~ s/\n\s*\\maketitle/\n\\maketitle\n\\begin{linenumbers}/;
#    
#	}else{
#	
#	    $mainData =~ s/\n\s*\\begin{document}/\n\\begin{document}\n\\begin{linenumbers}/;
#    
#}
#
#
#    $mainData =~ s/\n\s*\\bibliography/\n\\end{linenumbers}\n\\bibliography/;
#
#
#
#}else{
#
#    if($mainData =~ m/\\begin{abstract}/) {
#	
#	$mainData =~ s/\n\s*\\end{abstract}/\n\\end{abstract}\n\\linenumbers/;
#	
#    }elsif($mainData =~ m/maketitle/) {
#    
#	$mainData =~ s/\n\s*\\maketitle/\n\\maketitle\n\\linenumbers/;
#
#    }else{
#	
#	$mainData =~ s/\n\s*\\begin{document}/\n\\begin{document}\n\\linenumbers/;
#    
#    }
#
#}



#$mainData =~ s/revtex4/\/afs\/slac.stanford.edu\/g\/babar\/bin\/revtex4/g;


#include the new definitions needed to use lineno with revtex4
$mainData =~ s/\n\s*\\documentclass(.*)\{revtex4\}/\n\\documentclass$1\{revtex4\}\n$lineno4_redefinitions\n/;


$mainData =~ s/\n([^\n^%]*)\\begin{equation([\*]*)}/\n$1\\begin{linenomath}\n\\begin{equation$2}/g;
$mainData =~ s/\n([^\n^%]*)\\end{equation([\*]*)}/\n$1\\end{equation$2}\n\\end{linenomath}/g;

$mainData =~ s/\n([^\n^%]*)\\begin{eqnarray([\*]*)}/\n$1\\begin{linenomath}\n\\begin{eqnarray$2}/g;
$mainData =~ s/\n([^\n^%]*)\\end{eqnarray([\*]*)}/\n$1\\end{eqnarray$2}\n\\end{linenomath}/g;

$mainData =~ s/\n([^\n^%]*)\\begin{align([\*]*)}/\n$1\\begin{linenomath}\n\\begin{align$2}/g;
$mainData =~ s/\n([^\n^%]*)\\end{align([\*]*)}/\n$1\\end{align$2}\n\\end{linenomath}/g;

$mainData =~ s/\n([^\n^%]*)\\begin{alignat([\*]*)}/\n$1\\begin{linenomath}\n\\begin{alignat$2}/g;
$mainData =~ s/\n([^\n^%]*)\\end{alignat([\*]*)}/\n$1\\end{alignat$2}\n\\end{linenomath}/g;

$mainData =~ s/\n([^\n^%]*)\\begin{gather([\*]*)}/\n$1\\begin{linenomath}\n\\begin{gather$2}/g;
$mainData =~ s/\n([^\n^%]*)\\end{gather([\*]*)}/\n$1\\end{gather$2}\n\\end{linenomath}/g;

$mainData =~ s/\n([^\n^%]*)\\begin{split([\*]*)}/\n$1\\begin{linenomath}\n\\begin{split$2}/g;
$mainData =~ s/\n([^\n^%]*)\\end{split([\*]*)}/\n$1\\end{split$2}\n\\end{linenomath}/g;

$mainData =~ s/\n([^\n^%]*)\\begin{multline([\*]*)}/\n$1\\begin{linenomath}\n\\begin{multline$2}/g;
$mainData =~ s/\n([^\n^%]*)\\end{multline([\*]*)}/\n$1\\end{multline$2}\n\\end{linenomath}/g;

$mainData =~ s/\n([^\n^%]*)\\begin{xxalignat([\*]*)}/\n$1\\begin{linenomath}\n\\begin{xxalignat$2}/g;
$mainData =~ s/\n([^\n^%]*)\\end{xxalignat([\*]*)}/\n$1\\end{xxalignat$2}\n\\end{linenomath}/g;


$mainData =~ s/\n([^\n^%]*)\$\$([^\$\$]*)\$\$/\n$1\\begin{linenomath}\n\$\$ $2 \$\$\n\\end{linenomath}/g;

$mainData =~ s/\n([^\n^%]*)\\begin{displaymath([\*]*)}/\n$1\\begin{linenomath}\n\\begin{displaymath$2}/g;
$mainData =~ s/\n([^\n^%]*)\\end{displaymath([\*]*)}/\n$1\\end{displaymath$2}\n\\end{linenomath}/g;

if($mainData =~ m/\\\[(.*)\\\]/) {
$mainData =~ s/\n([^\n^%]*)\\\[/\n$1\\begin{linenomath}\\\[\n/;
$mainData =~ s/\n([^\n^%]*)\\\]/\n$1\\\]\n\\end{linenomath}/;
}

$mainData =~ s/\n([^\n^%]*)\\begin{figure}/\n\n$1\\begin{figure}/g;

#$mainData =~ s/\n([^\n^%]*)\\begin{table}/\n\n$1\\begin{table}/g;

$mainData =~ s/\n([^\n^%]*)\\begin{table([\*]*)}/\n$1\\begin{linenomath}\n\\begin{table$2}/g;
$mainData =~ s/\n([^\n^%]*)\\end{table([\*]*)}/\n$1\\end{table$2}\n\\end{linenomath}/g;


print OUTPUTFILE $mainData;

#close SOURCEFILE;
close OUTPUTFILE;

print "$newTexFileName has been created.\n"
      . "You can now run latex"
      . " and create the ps/pdf to see the line numbered document.\n";

#my $cmd1 = "cp ~ecmartin/linenums/lineno4.sty .;" ;
#my $cmd2 = "cp ~ecmartin/linenums/revtex_linenum.cls .;" ;
#my $cmd3 = "latex filename.tex;" ;
#my $cmd4 = "bibtex filename;" ;
#my $cmd5 = "latex filename.tex;" ;
#my $cmd6 = "dvips filename.dvi;" ;
#my $cmd7 = "rm revtex_linenum.cls;" ;
#my $cmd8 = "rm lineno4.sty;" ;

#&doCmd($cmd1);
#&doCmd($cmd2);
#&doCmd($cmd3);
#&doCmd($cmd4);
#&doCmd($cmd5);
#&doCmd($cmd5);
#&doCmd($cmd6);
#&doCmd($cmd7);
#&doCmd($cmd8);

}

&main
