%{
  #include <stdio.h>
  #include <string.h>
  int yylex(void);
  void yyerror(char *s);
%}

/*%define lr.type canonical-lr*/

/*%glr-parser*/

%token OHTML CHTML
%token OHEAD CHEAD
%token OTITLE CTITLE
%token OBODY CBODY
%token OPARA CPARA
%token TEXT
%token ODOCTYPE CDOCTYPE
%token OHEADONE CHEADONE OHEADTWO CHEADTWO OHEADTHREE CHEADTHREE OHEADFOUR CHEADFOUR
%token LINEBR
%token BEFOREHYPERLINK HYPERLINK OANCHOR CANCHOR
%token OORDERLIST CORDERLIST OUNORDERLIST CUNORDERLIST OLISTITEM CLISTITEM ODESCTERM CDESCTERM ODESCDESC CDESCDESC
%token ODIV CDIV OUNDERLINE CUNDERLINE OBOLD CBOLD OITALICIZE CITALICIZE OEMPHASIZE CEMPHASIZE OSTRONG CSTRONG OSMALL CSMALL OSUB CSUB OSUP CSUP
%token OIMG OIMGSRC CIMGSRC OIMGWIDTH WIDTH CIMGWIDTH OIMGHEIGHT HEIGHT CIMGHEIGHT CIMG
%token OFIGURE CFIGURE OFIGCAPTION CFIGCAPTION
%token OTABLE CTABLE OCAPTION CCAPTION OTROW CTROW OTHEAD CTHEAD OTCOL CTCOL
%token CANGBRKT


%union {
  long int4;
  float fp;
  char *str;
}

%type <str> TEXT
%type <str> LINEBR
%type <str> head
%type <str> body
%type <str> paragraph
%type <str> body_content
%type <str> title
%type <str> content
%type <str> doctype
%type <str> h1
%type <str> h2
%type <str> h3
%type <str> h4
%type <str> header

%%

html_page:
  OHTML CHTML {
    printf("<html></html>\n");
  } |
  OHTML body CHTML {
    printf("<html>%s</html>\n", $2);
  } |
  OHTML head CHTML {
    printf("<html>%s</html>\n", $2);
  } |
  doctype OHTML CHTML {
    printf("%s<html></html>\n", $1);
  } |
  doctype OHTML head CHTML {
    printf("%s<html>%s</html>\n", $1, $3);
  } |
  doctype OHTML body CHTML {
    printf("%s<html>%s</html>\n", $1, $3);
  } |
  OHTML head body CHTML {
    printf("<html>%s%s</html>\n", $2, $3);
  } |
  doctype OHTML head body CHTML	{ 
    printf("%s<html>%s%s</html>\n", $1, $3, $4);
  }

doctype:
  ODOCTYPE CANGBRKT {
    $$ = "<!DOCTYPE HTML>";
  } |
  ODOCTYPE TEXT CANGBRKT {
    char *doctype = (char *) malloc((strlen($2) + 16) * sizeof(char));
    strcpy(doctype, "<!DOCTYPE HTML");
    strcat(doctype, $2);
    strcat(doctype, ">");
    $$ = doctype;
  }

head:
  OHEAD CHEAD {
    $$ = "<head></head>";
  } |
  OHEAD title CHEAD	{
    char *head = (char *) malloc((strlen($2) + 14) * sizeof(char));
    strcpy(head, "<head>");
    strcat(head, $2);
    strcat(head, "</head>");
    $$ = head;
  }

title:
  OTITLE CTITLE {
    $$ = "<title></title>";
  } |
  OTITLE TEXT CTITLE		{
    char *title = (char *) malloc((strlen($2) + 16) * sizeof(char));
    strcpy(title, "<title>");
    strcat(title, $2);
    strcat(title, "</title>");
    $$ = title;
  }

body:
  OBODY CBODY {
    $$ = "<body></body>";
  } |
  OBODY body_content CBODY {
    if (strcmp($2, "") == 0) {
      char *body = (char *) malloc((strlen("<body></body>") + 1) * sizeof(char));
      strcpy(body, "<body></body>");
      $$ = body;
    }
    else {
      char *body = (char *) malloc((strlen($2) + 14) * sizeof(char));
      strcpy(body, "<body>");
      strcat(body, $2);
      strcat(body, "</body>");
      $$ = body;
    }
  }

body_content:
  TEXT | paragraph | LINEBR | header |
  body_content TEXT {
    char *body_content = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(body_content, $1);
    strcat(body_content, $2);
    $$ = body_content;
  } |
  body_content paragraph {
    char *body_content = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(body_content, $1);
    strcat(body_content, $2);
    $$ = body_content;
  } |
  body_content LINEBR {
    char *body_content = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(body_content, $1);
    strcat(body_content, $2);
    $$ = body_content;
  } |
  body_content header {
    char *body_content = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(body_content, $1);
    strcat(body_content, $2);
    $$ = body_content;
  }

header:
  h1 | h2 | h3 | h4;

h1:
  OHEADONE content CHEADONE {
    char *h1 = (char *) malloc(strlen($2) + 10);
    strcpy(h1, "<h1>");
    strcat(h1, $2);
    strcat(h1, "</h1>");
    $$ = h1;
  }

h2:
  OHEADTWO content CHEADTWO {
    char *h2 = (char *) malloc(strlen($2) + 10);
    strcpy(h2, "<h2>");
    strcat(h2, $2);
    strcat(h2, "</h2>");
    $$ = h2;
  }

h3:
  OHEADTHREE content CHEADTHREE {
    char *h3 = (char *) malloc(strlen($2) + 10);
    strcpy(h3, "<h3>");
    strcat(h3, $2);
    strcat(h3, "</h3>");
    $$ = h3;
  }

h4:
  OHEADFOUR content CHEADFOUR {
    char *h4 = (char *) malloc(strlen($2) + 10);
    strcpy(h4, "<h4>");
    strcat(h4, $2);
    strcat(h4, "</h4>");
    $$ = h4;
  }

paragraph:
  OPARA content CPARA {
    if (strcmp($2, "") == 0) {
      $$ = "<p></p>";
    }
    else {
      char *paragraph = (char *) malloc(strlen($2) + 8);
      strcpy(paragraph, "<p>");
      strcat(paragraph, $2);
      strcat(paragraph, "</p>");
      $$ = paragraph;
    }
  }

content:
  TEXT
/*  | body_content
*/
%%

int main() {
    yyparse();
    return 0;
}
