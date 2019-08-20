
%{
  #include "parse.tab.h"
  #include <string.h>
  #include <stdio.h>
%}

%start doctypeseen
%start anchor
%start beforehyperlink
%start hyperlink 

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
    BEGIN doctypeseen;
    yylval.str = strdup(yytext);
    return ODOCTYPE;
}

<doctypeseen>">"	{
  BEGIN INITIAL;
  yylval.str = strdup(yytext);
  return CDOCTYPE;
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
  BEGIN anchor;
  return OANCHOR;
}

<anchor>{whitespaces}"</"{a}{whitespaces}">" {
  BEGIN INITIAL;
  return CANCHOR;
}

"<"{p}{whitespaces}">"			          return OPARA;

"</"{p}{whitespaces}">"			          return CPARA;

[a-zA-Z0-9 .]+	{
  yylval.str = strdup(yytext);
  return CONTENT;
}
"<h1>"      return OHEADONE;
"<h2>"      return OHEADTWO;
"<h3>"      return OHEADTHREE;
"<h4>"      return OHEADFOUR;
"</h1>"     return CHEADONE;
"</h2>"     return CHEADTWO;
"</h3>"     return CHEADTHREE;
"</h4>"     return CHEADFOUR;
"<br>"      return LINEBR;
[ \t\n]+		;

%%

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
}

/*int main() {
	yylex();
	return 0;
}*/
