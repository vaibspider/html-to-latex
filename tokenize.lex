
%{
#include "parse.tab.h"
#include <string.h>
#include <stdio.h>
%}

%%

"<html>"		return OHTML;
"</html>"		return CHTML;
"<head>"		return OHEAD;
"</head>"		return CHEAD;
"<body>"		return OBODY;
"</body>"		return CBODY;
"<title>"		return OTITLE;
"</title>"		return CTITLE;
"<p>"			return OPARA;
"</p>"			return CPARA;
[a-zA-Z0-9 .]+		{
			    yylval.str = strdup(yytext);
			    return CONTENT;
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
