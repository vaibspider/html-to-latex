%{
#include <stdio.h>
%}

%%

"<html>"		printf("HTML OPEN: %s \n", yytext);
"</html>"		printf("HTML CLOSE: %s \n", yytext);
"<head>"		printf("HEAD OPEN: %s \n", yytext);
"</head>"		printf("HEAD CLOSE: %s \n", yytext);
"<body>"		printf("BODY OPEN: %s \n", yytext);
"</body>"		printf("BODY CLOSE: %s \n", yytext);
"<title>"		printf("TITLE OPEN: %s \n", yytext);
"</title>"		printf("TITLE CLOSE: %s \n", yytext);
"<p>"			printf("PARAGRAPH OPEN: %s \n", yytext);
"</p>"			printf("PARAGRAPH CLOSE: %s \n", yytext);
[a-zA-Z0-9 .]+		printf("TEXT : %s \n", yytext);
[ \t\n]+		;

%%

int main() {
	yylex();
	return 0;
}
