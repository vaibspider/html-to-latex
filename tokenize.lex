
%{
  #include "parse.tab.h"
  #include <string.h>
  #include <stdio.h>
%}

%start doctypeseen

%%

"<!"(doctype|DOCTYPE)" "(html|HTML)	{
    BEGIN doctypeseen;
    return ODOCTYPE;
}

<doctypeseen>">"	{
  BEGIN INITIAL;
  return CDOCTYPE;
}

"<html>"		return OHTML;
"</html>"		return CHTML;
"<head>"		return OHEAD;
"</head>"		return CHEAD;
"<body>"		return OBODY;
"</body>"		return CBODY;
"<title>"		return OTITLE;
"</title>"	return CTITLE;
"<p>"			  return OPARA;
"</p>"			return CPARA;
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
