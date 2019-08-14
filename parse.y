%{
  #include <stdio.h>
  #include <string.h>
  int yylex(void);
  void yyerror(char *s);
%}

%token OHTML CHTML
%token OHEAD CHEAD
%token OTITLE CTITLE
%token OBODY CBODY
%token OPARA CPARA
%token CONTENT
%token ODOCTYPE CDOCTYPE

%union {
  long int4;
  float fp;
  char *str;
}

%type <str> CONTENT
%type <str> head_body
%type <str> head
%type <str> body
%type <str> title
%type <str> content
%type <str> para
%type <str> doctype
%type <str> optional_content

%%

html_page:
  doctype OHTML head_body CHTML	{ 
    printf("<html>%s%s</html>\n", $1, $3);
  }

doctype:
   ODOCTYPE optional_content CDOCTYPE {
      if (strcmp($2, "") == 0) {
        $$ = "<!DOCTYPE HTML>";
      }
      else {
        char *doctype = (char *) malloc((strlen($2) + 16) * sizeof(char));
        strcpy(doctype, "<!DOCTYPE HTML");
        strcat(doctype, $2);
        strcat(doctype, ">");
        $$ = doctype;
      }
    }

optional_content:
  %empty {
    $$ = "";
  }
  | CONTENT	{
      char *optional_content = (char *) malloc((strlen($1)+1) * sizeof(char));
      strcpy(optional_content, $1);
      $$ = optional_content;
  }

head_body:
	head body	{
    char *head_body = (char *) malloc((strlen($1) + strlen($2)) * sizeof(char)); 
    strcpy(head_body, $1);
    strcat(head_body, $2);
    $$ = head_body;	
  }

head:
  OHEAD title CHEAD	{
    char *head = (char *) malloc((strlen($2) + 14) * sizeof(char));
    strcpy(head, "<head>");
    strcat(head, $2);
    strcat(head, "</head>");
    $$ = head;
  }

title:
  OTITLE content CTITLE		{
    char *title = (char *) malloc((strlen($2) + 16) * sizeof(char));
    strcpy(title, "<title>");
    strcat(title, $2);
    strcat(title, "</title>");
    $$ = title;
  }

body:
  OBODY para CBODY {
    char *body = (char *) malloc((strlen($2) + 14) * sizeof(char));
    strcpy(body, "<body>");
    strcat(body, $2);
    strcat(body, "</body>");
    $$ = body;
  }

para:
  OPARA content CPARA	{
    char *para = (char *) malloc((strlen($2) + 8) * sizeof(char));
    strcpy(para, "<p>");
    strcat(para, $2);
    strcat(para, "</p>");
    $$ = para;
	}

content:
  CONTENT	{
    $$ = $1;
  }

%%

int main() {
    yyparse();
    return 0;
}
