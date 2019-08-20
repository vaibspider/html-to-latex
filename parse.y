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
%token CONTENT
%token ODOCTYPE CDOCTYPE
%token OHEADONE CHEADONE OHEADTWO CHEADTWO OHEADTHREE CHEADTHREE OHEADFOUR CHEADFOUR
%token LINEBR
%token BEFOREHYPERLINK HYPERLINK OANCHOR CANCHOR
%token OORDERLIST CORDERLIST OUNORDERLIST CUNORDERLIST OLISTITEM CLISTITEM ODESCTERM CDESCTERM ODESCDESC CDESCDESC
%token ODIV CDIV OUNDERLINE CUNDERLINE OBOLD CBOLD OITALICIZE CITALICIZE OEMPHASIZE CEMPHASIZE OSTRONG CSTRONG OSMALL CSMALL OSUB CSUB OSUP CSUP
%token OIMG OIMGSRC CIMGSRC OIMGWIDTH WIDTH CIMGWIDTH OIMGHEIGHT HEIGHT CIMGHEIGHT CIMG
%token OFIGURE CFIGURE OFIGCAPTION CFIGCAPTION
%token OTABLE CTABLE OCAPTION CCAPTION OTROW CTROW OTHEAD CTHEAD OTCOL CTCOL


%union {
  long int4;
  float fp;
  char *str;
}

%type <str> CONTENT
%type <str> LINEBR
%type <str> head_body
%type <str> head
%type <str> body
%type <str> paragraph
%type <str> paragraphs
%type <str> body_content
%type <str> title
%type <str> content
%type <str> doctype
%type <str> optional_content
%type <str> linebreaks 
%type <str> h1
%type <str> h2
%type <str> h3
%type <str> h4
%type <str> header
%type <str> headers
%type <str> variable

%%

html_page:
  doctype OHTML head_body CHTML	{ 
    printf("%s<html>%s</html>\n", $1, $3);
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
  } |
  content {
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
  %empty {
    $$ = "";
  } | 
  body_content variable {
    if (strcmp($1, "") == 0) {
      $$ = $2;
    }
    else {
      char *body_content = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
      strcpy(body_content, $1);
      strcat(body_content, $2);
      $$ = body_content;
    }
  }

variable:
  content | paragraphs | linebreaks | headers

headers:
  header |
  headers header {
      char *headers = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
      strcpy(headers, $1);
      strcat(headers, $2);
      $$ = headers;
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

paragraphs:
  paragraph |
  paragraphs paragraph {
    char *paragraphs = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(paragraphs, $1);
    strcat(paragraphs, $2);
    $$ = paragraphs;
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

linebreaks:
  LINEBR |
  linebreaks LINEBR {
    char *linebreaks = (char *) malloc((strlen($1) + 5) * sizeof(char));
    strcpy(linebreaks, "<br>");
    strcat(linebreaks, $1);
    $$ = linebreaks;
  }

content:
  CONTENT
/*  | body_content
*/
%%

int main() {
    yyparse();
    return 0;
}
