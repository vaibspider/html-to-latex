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
%token OORDERLIST CORDERLIST OUNORDERLIST CUNORDERLIST OLISTITEM CLISTITEM ODESCTERM CDESCTERM ODESCDESC CDESCDESC ODESCLIST CDESCLIST
%token ODIV CDIV OUNDERLINE CUNDERLINE OBOLD CBOLD OITALIC CITALIC OEMPHASIS CEMPHASIS OSTRONG CSTRONG OSMALL CSMALL OSUB CSUB OSUP CSUP
%token OIMG OIMGSRC CIMGSRC OIMGWIDTH WIDTH CIMGWIDTH OIMGHEIGHT HEIGHT CIMGHEIGHT CIMG
%token OFIGURE CFIGURE OFIGCAPTION CFIGCAPTION
%token OTABLE CTABLE OCAPTION CCAPTION OTROW CTROW OTHEAD CTHEAD OTCOL CTCOL
%token CANGBRKT

%define parse.error verbose


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
%type <str> anchor BEFOREHYPERLINK HYPERLINK OANCHOR
%type <str> ordlist unordlist list_item list_items
%type <str> desclist termsdescs descterm descdesc
%type <str> div
%type <str> underline bold italic emphasis strong small sub sup
%type <str> image src_width_height src width height OIMG CIMG OIMGSRC CIMGSRC OIMGWIDTH CIMGWIDTH OIMGHEIGHT CIMGHEIGHT WIDTH HEIGHT
%type <str> table caption trs tr ths th tds td
%type <str> flow_content phrasing_content

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
  flow_content |
  body_content flow_content {
    char *body_content = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(body_content, $1);
    strcat(body_content, $2);
    $$ = body_content;
  }

flow_content:
  phrasing_content | div | desclist | header | ordlist | paragraph | table | unordlist

phrasing_content:
  TEXT | anchor | bold | LINEBR | emphasis | italic | image | small | strong | sub | sup | underline

table:
  OTABLE trs CTABLE {
    char *table = (char *)malloc((strlen($2) + 16) * sizeof(char));
    strcpy(table, "<table>");
    strcat(table, $2);
    strcat(table, "</table>");
    $$ = table;
  } |
  OTABLE caption trs CTABLE {
    char *table = (char *)malloc((strlen($2) + strlen($3) + 16) * sizeof(char));
    strcpy(table, "<table>");
    strcat(table, $2);
    strcat(table, $3);
    strcat(table, "</table>");
    $$ = table;
  }

caption:
  TEXT

trs:
  tr |
  trs tr {
    char *trow = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(trow, $1);
    strcat(trow, $2);
    $$ = trow;
  }

tr:
  OTROW ths CTROW {
    char *a = (char *)malloc((strlen($2) + 10) * sizeof(char));
    strcpy(a, "<tr>");
    strcat(a, $2);
    strcat(a, "</tr>");
    $$ = a;
  } |
  OTROW tds CTROW {
    char *a = (char *)malloc((strlen($2) + 10) * sizeof(char));
    strcpy(a, "<tr>");
    strcat(a, $2);
    strcat(a, "</tr>");
    $$ = a;
  }

ths:
  th |
  ths th {
    char *ths = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(ths, $1);
    strcat(ths, $2);
    $$ = ths;
  }

tds:
  td |
  tds td {
    char *tds = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(tds, $1);
    strcat(tds, $2);
    $$ = tds;
  }

th:
  OTHEAD TEXT CTHEAD {
    char *a = (char *)malloc((strlen($2) + 10) * sizeof(char));
    strcpy(a, "<th>");
    strcat(a, $2);
    strcat(a, "</th>");
    $$ = a;
  }

td:
  OTCOL TEXT CTCOL {
    char *a = (char *)malloc((strlen($2) + 10) * sizeof(char));
    strcpy(a, "<td>");
    strcat(a, $2);
    strcat(a, "</td>");
    $$ = a;
  }

image:
  OIMG src_width_height CIMG {
    char *image = (char *)malloc((strlen($2) + 7) * sizeof(char));
    strcpy(image, "<img ");
    strcat(image, $2);
    strcat(image, ">");
    $$ = image;
  }

src_width_height:
  src |
  src width {
    char *a = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(a, $1);
    strcat(a, " ");
    strcat(a, $2);
    $$ = a;
  } |
  width src {
    char *a = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(a, $1);
    strcat(a, " ");
    strcat(a, $2);
    $$ = a;
  } |
  src height {
    char *a = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(a, $1);
    strcat(a, " ");
    strcat(a, $2);
    $$ = a;
  } |
  height src {
    char *a = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(a, $1);
    strcat(a, " ");
    strcat(a, $2);
    $$ = a;
  } |
  src width height {
    char *a = (char *)malloc((strlen($1) + strlen($2) + strlen($3) + 1) * sizeof(char));
    strcpy(a, $1);
    strcat(a, " ");
    strcat(a, $2);
    strcat(a, " ");
    strcat(a, $3);
    $$ = a;
  } |
  src height width {
    char *a = (char *)malloc((strlen($1) + strlen($2) + strlen($3) + 1) * sizeof(char));
    strcpy(a, $1);
    strcat(a, " ");
    strcat(a, $2);
    strcat(a, " ");
    strcat(a, $3);
    $$ = a;
  } |
  height width src {
    char *a = (char *)malloc((strlen($1) + strlen($2) + strlen($3) + 1) * sizeof(char));
    strcpy(a, $1);
    strcat(a, " ");
    strcat(a, $2);
    strcat(a, " ");
    strcat(a, $3);
    $$ = a;
  } |
  height src width {
    char *a = (char *)malloc((strlen($1) + strlen($2) + strlen($3) + 1) * sizeof(char));
    strcpy(a, $1);
    strcat(a, " ");
    strcat(a, $2);
    strcat(a, " ");
    strcat(a, $3);
    $$ = a;
  } |
  width height src {
    char *a = (char *)malloc((strlen($1) + strlen($2) + strlen($3) + 1) * sizeof(char));
    strcpy(a, $1);
    strcat(a, " ");
    strcat(a, $2);
    strcat(a, " ");
    strcat(a, $3);
    $$ = a;
  } |
  width src height {
    char *a = (char *)malloc((strlen($1) + strlen($2) + strlen($3) + 1) * sizeof(char));
    strcpy(a, $1);
    strcat(a, " ");
    strcat(a, $2);
    strcat(a, " ");
    strcat(a, $3);
    $$ = a;
  }

src:
  OIMGSRC HYPERLINK CIMGSRC {
    char *src = (char *)malloc((strlen($2) + 7) * sizeof(char));
    strcpy(src, "src=\"");
    strcat(src, $2);
    strcat(src, "\"");
    $$ = src;
  }

width:
  OIMGWIDTH WIDTH CIMGWIDTH {
    char *width = (char *)malloc((strlen($2) + 9) * sizeof(char));
    strcpy(width, "width=\"");
    strcat(width, $2);
    strcat(width, "\"");
    $$ = width;
  }

height:
  OIMGHEIGHT HEIGHT CIMGHEIGHT {
    char *height = (char *)malloc((strlen($2) + 10) * sizeof(char));
    strcpy(height, "height=\"");
    strcat(height, $2);
    strcat(height, "\"");
    $$ = height;
  }

underline:
  OUNDERLINE TEXT CUNDERLINE {
    char *underline = (char *)malloc((strlen($2) + 8) * sizeof(char));
    strcpy(underline, "<u>");
    strcat(underline, $2);
    strcat(underline, "</u>");
    $$ = underline;
  }

bold:
  OBOLD TEXT CBOLD {
    char *bold = (char *)malloc((strlen($2) + 8) * sizeof(char));
    strcpy(bold, "<b>");
    strcat(bold, $2);
    strcat(bold, "</b>");
    $$ = bold;
  }

italic:
  OITALIC TEXT CITALIC {
    char *italic = (char *)malloc((strlen($2) + 8) * sizeof(char));
    strcpy(italic, "<i>");
    strcat(italic, $2);
    strcat(italic, "</i>");
    $$ = italic;
  }

emphasis:
  OEMPHASIS TEXT CEMPHASIS {
    char *emphasis = (char *)malloc((strlen($2) + 10) * sizeof(char));
    strcpy(emphasis, "<em>");
    strcat(emphasis, $2);
    strcat(emphasis, "</em>");
    $$ = emphasis;
  }

strong:
  OSTRONG TEXT CSTRONG {
    char *strong = (char *)malloc((strlen($2) + 18) * sizeof(char));
    strcpy(strong, "<strong>");
    strcat(strong, $2);
    strcat(strong, "</strong>");
    $$ = strong;
  }

small:
  OSMALL TEXT CSMALL {
    char *small = (char *)malloc((strlen($2) + 16) * sizeof(char));
    strcpy(small, "<small>");
    strcat(small, $2);
    strcat(small, "</small>");
    $$ = small;
  }

sub:
  OSUB TEXT CSUB {
    char *sub = (char *)malloc((strlen($2) + 11) * sizeof(char));
    strcpy(sub, "<sub>");
    strcat(sub, $2);
    strcat(sub, "</sub>");
    $$ = sub;
  }

sup:
  OSUP TEXT CSUP {
    char *sup = (char *)malloc((strlen($2) + 11) * sizeof(char));
    strcpy(sup, "<sup>");
    strcat(sup, $2);
    strcat(sup, "</sup>");
    $$ = sup;
  }

div:
  ODIV TEXT CDIV {
    char *div = (char *)malloc((strlen($2) + 12) * sizeof(char));
    strcpy(div, "<div>");
    strcat(div, $2);
    strcat(div, "</div>");
    $$ = div;
  }

desclist:
  ODESCLIST termsdescs CDESCLIST {
    char *desclist= (char *) malloc((strlen($2) + 10) * sizeof(char));
    strcpy(desclist, "<dl>");
    strcat(desclist, $2);
    strcat(desclist, "</dl>");
    $$ = desclist;
  }

termsdescs:
  descterm descdesc {
    char *termsdescs = (char *)malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(termsdescs, $1);
    strcat(termsdescs, $2);
    $$ = termsdescs;
  } |
  termsdescs descterm descdesc {
    char *termsdescs = (char *) malloc((strlen($1) + strlen($2) + strlen($3) + 1) * sizeof(char));
    strcpy(termsdescs, $1);
    strcat(termsdescs, $2);
    strcat(termsdescs, $3);
    $$ = termsdescs;
  }

descterm:
  ODESCTERM TEXT CDESCTERM {
    char *descterm= (char *) malloc((strlen($2) + 10) * sizeof(char));
    strcpy(descterm, "<dt>");
    strcat(descterm, $2);
    strcat(descterm, "</dt>");
    $$ = descterm;
  }

descdesc:
  ODESCDESC TEXT CDESCDESC {
    char *descdesc = (char *) malloc((strlen($2) + 10) * sizeof(char));
    strcpy(descdesc, "<dd>");
    strcat(descdesc, $2);
    strcat(descdesc, "</dd>");
    $$ = descdesc;
  }

ordlist:
  OORDERLIST list_items CORDERLIST {
    char *ordlist= (char *) malloc((strlen($2) + 10) * sizeof(char));
    strcpy(ordlist, "<ol>");
    strcat(ordlist, $2);
    strcat(ordlist, "</ol>");
    $$ = ordlist;
  }

unordlist:
  OUNORDERLIST list_items CUNORDERLIST {
    char *unordlist= (char *) malloc((strlen($2) + 10) * sizeof(char));
    strcpy(unordlist, "<ul>");
    strcat(unordlist, $2);
    strcat(unordlist, "</ul>");
    $$ = unordlist;
  }

list_items:
  list_item |
  list_items list_item {
    char *listitems= (char *) malloc((strlen($1) + strlen($2) + 1) * sizeof(char));
    strcpy(listitems, $1);
    strcat(listitems, $2);
    $$ = listitems;
  }

list_item:
  OLISTITEM TEXT CLISTITEM {
    char *listitem= (char *) malloc((strlen($2) + 10) * sizeof(char));
    strcpy(listitem, "<li>");
    strcat(listitem, $2);
    strcat(listitem, "</li>");
    $$ = listitem;
  }

anchor:
  BEFOREHYPERLINK HYPERLINK OANCHOR TEXT CANCHOR {
    char *anchor = (char *) malloc((strlen($2) + strlen($4) + 16) * sizeof(char));
    strcpy(anchor, "<a href=\"");
    strcat(anchor, $2);
    strcat(anchor, "\">");
    strcat(anchor, $4);
    strcat(anchor, "</a>");
    $$ = anchor;
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
