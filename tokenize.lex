
%{
  #include "parse.tab.h"
  #include <string.h>
  #include <stdio.h>
%}

%start beforehyperlink
%start hyperlink 
%start img
%start imghyperlink
%start imgsrc
%start imgheight
%start imgwidth
%start widthdigit
%start heightdigit

a [aA]
b [bB]
c [cC]
d [dD]
e [eE]
f [fF]
g [gG]
h [hH]
i [iI]
j [jJ]
k [kK]
l [lL]
m [mM]
n [nN]
o [oO]
p [pP]
q [qQ]
r [rR]
s [sS]
t [tT]
u [uU]
v [vV]
w [wW]
x [xX]
y [yY]
z [zZ]
space [ ]
spaces [ ]+
tab   \t
tabs   [\t]+
newline \n
newlines [\n]+
whitespace [ \t\n]
whitespaces [ \t\n]+
alpha [a-zA-Z]
alphas [a-zA-Z]+
digit [0-9]
digits [0-9]+
specials [-!@#$%\^&*()+=_"';:,./?~`\\|]+
hyperlink [a-zA-Z0-9/:.]+

%%

"<!"{d}{o}{c}{t}{y}{p}{e}{whitespaces}{h}{t}{m}{l} {
    yylval.str = strdup(yytext);
    return ODOCTYPE;
}

"<"{h}{t}{m}{l}{whitespaces}">"		    return OHTML;

"</"{h}{t}{m}{l}{whitespaces}">"		  return CHTML;

"<"{h}{e}{a}{d}{whitespaces}">"		    return OHEAD;

"</"{h}{e}{a}{d}{whitespaces}">"		  return CHEAD;

"<"{b}{o}{d}{y}{whitespaces}">"		    return OBODY;

"</"{b}{o}{d}{y}{whitespaces}">"		  return CBODY;

"<"{t}{i}{t}{l}{e}{whitespaces}">"		return OTITLE;

"</"{t}{i}{t}{l}{e}{whitespaces}">"		return CTITLE;

"<"{a}{whitespaces}{h}{r}{e}{f}{whitespaces}={whitespaces}\" {
  BEGIN beforehyperlink;
  return BEFOREHYPERLINK;
}

<beforehyperlink>{hyperlink} {
  BEGIN hyperlink;
  yylval.str = strdup(yytext);
  return HYPERLINK;
}

<hyperlink>\"{whitespaces}">" {
  BEGIN INITIAL;
  return OANCHOR;
}

"</"{a}{whitespaces}">" {
  return CANCHOR;
}

"<"{b}{r}{whitespaces}">"    return LINEBR;

"<"{p}{whitespaces}">"			 return OPARA;

"</"{p}{whitespaces}">"			 return CPARA;

"<"{h}1{whitespaces}">"       return OHEADONE;

"</"{h}1{whitespaces}">"       return CHEADONE;

"<"{h}2{whitespaces}">"       return OHEADTWO;

"</"{h}2{whitespaces}">"       return CHEADTWO;

"<"{h}3{whitespaces}">"       return OHEADTHREE;

"</"{h}3{whitespaces}">"       return CHEADTHREE;

"<"{h}4{whitespaces}">"       return OHEADFOUR;

"</"{h}4{whitespaces}">"       return CHEADFOUR;

"<"{o}{l}{whitespaces}">"     return OORDERLIST;

"</"{o}{l}{whitespaces}">"     return CORDERLIST;

"<"{u}{l}{whitespaces}">"     return OUNORDERLIST;

"</"{u}{l}{whitespaces}">"     return CUNORDERLIST;

"<"{l}{i}{whitespaces}">"     return OLISTITEM;

"</"{l}{i}{whitespaces}">"     return CLISTITEM;

"<"{d}{t}{whitespaces}">"     return ODESCTERM;

"</"{d}{t}{whitespaces}">"     return CDESCTERM;

"<"{d}{d}{whitespaces}">"     return ODESCDESC;

"</"{d}{d}{whitespaces}">"     return CDESCDESC;

"<"{d}{i}{v}{whitespaces}">"    return ODIV;

"</"{d}{i}{v}{whitespaces}">"    return CDIV;

"<"{u}{whitespaces}">"      return OUNDERLINE;

"</"{u}{whitespaces}">"      return CUNDERLINE;

"<"{b}{whitespaces}">"      return OBOLD;

"</"{b}{whitespaces}">"      return CBOLD;

"<"{i}{whitespaces}">"      return OITALICIZE;

"</"{i}{whitespaces}">"      return CITALICIZE;

"<"{e}{m}{whitespaces}">"      return OEMPHASIZE;

"</"{e}{m}{whitespaces}">"      return CEMPHASIZE;

"<"{s}{t}{r}{o}{n}{g}{whitespaces}">"      return OSTRONG;

"</"{s}{t}{r}{o}{n}{g}{whitespaces}">"      return CSTRONG;

"<"{s}{m}{a}{l}{l}{whitespaces}">"      return OSMALL;

"</"{s}{m}{a}{l}{l}{whitespaces}">"      return CSMALL;

"<"{s}{u}{b}{whitespaces}">"      return OSUB;

"</"{s}{u}{b}{whitespaces}">"      return CSUB;

"<"{s}{u}{p}{whitespaces}">"      return OSUP;

"</"{s}{u}{p}{whitespaces}">"      return CSUP;

"<"{i}{m}{g}  {
  BEGIN img;
  return OIMG;
}

<img>{s}{r}{c}{whitespaces}={whitespaces}\"  {
  BEGIN imgsrc;
  return OIMGSRC;
}

<imgsrc>{hyperlink} {
  BEGIN imghyperlink;
  return HYPERLINK;
}

<imghyperlink>\" {
  BEGIN img;
  return CIMGSRC;
}

<img>{w}{i}{d}{t}{h}{whitespaces}={whitespaces}\" {
  BEGIN imgwidth;
  return OIMGWIDTH;
}

<imgwidth>{digits} {
  BEGIN widthdigit;
  return WIDTH;
}

<widthdigit>\" {
  BEGIN img;
  return CIMGWIDTH;
}

<img>{h}{e}{i}{g}{h}{t}{whitespaces}={whitespaces}\" {
  BEGIN imgheight;
  return OIMGHEIGHT;
}

<imgheight>{digits} {
  BEGIN heightdigit;
  return HEIGHT;
}

<heightdigit>\" {
  BEGIN img;
  return CIMGHEIGHT;
}

<img>">" {
  BEGIN INITIAL;
  return CIMG;
}

"<"{f}{i}{g}{u}{r}{e}{whitespaces}">"   return OFIGURE;

"</"{f}{i}{g}{u}{r}{e}{whitespaces}">"   return CFIGURE;

"<"{f}{i}{g}{c}{a}{p}{t}{i}{o}{n}{whitespaces}">"   return OFIGCAPTION;

"</"{f}{i}{g}{c}{a}{p}{t}{i}{o}{n}{whitespaces}">"   return CFIGCAPTION;

[a-zA-Z0-9 .]+	{
  yylval.str = strdup(yytext);
  return CONTENT;
}

">"	{
  return CANGBRKT;
}

[ \t\n]+		;

%%

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
}

/*int main() {
	yylex();
	return 0;
}*/
