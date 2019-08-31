%{
  #include <stdio.h>
  #include <string.h>
  #include "node.h"
  #include "linked_list.h"
  #include "stack.h"
  #include "lrtree.h"
  int yylex(void);
  void yyerror(const char *s);
  #define YYDEBUG 1

  tree *t;
%}

/*%define lr.type canonical-lr*/

/*%glr-parser*/

%token OHTML CHTML
%token OHEAD CHEAD
%token OTITLE CTITLE
%token OBODY CBODY
%token OPARA CPARA
%token TEXT
%token ODOCTYPE
%token OHEADONE CHEADONE OHEADTWO CHEADTWO OHEADTHREE CHEADTHREE OHEADFOUR CHEADFOUR
%token LINEBR
%token BEFOREHYPERLINK HYPERLINK OANCHOR CANCHOR
%token OORDERLIST CORDERLIST OUNORDERLIST CUNORDERLIST OLISTITEM CLISTITEM ODESCTERM CDESCTERM ODESCDESC CDESCDESC ODESCLIST CDESCLIST
%token ODIV CDIV OUNDERLINE CUNDERLINE OBOLD CBOLD OITALIC CITALIC OEMPHASIS CEMPHASIS OSTRONG CSTRONG OSMALL CSMALL OSUB CSUB OSUP CSUP
%token OIMG OIMGSRC CIMGSRC OIMGWIDTH WIDTH CIMGWIDTH OIMGHEIGHT HEIGHT CIMGHEIGHT CIMG
%token OFIGURE CFIGURE OFIGCAPTION CFIGCAPTION
%token OTABLE CTABLE OCAPTION CCAPTION OTROW CTROW OTHEAD CTHEAD OTCOL CTCOL
%token CANGBRKT
%token JUSTOANCHOR
%token BEFORESIZE FONTSIZE OFONT CFONT OCENTER CCENTER OTELETYPE CTELETYPE 

%define parse.error verbose
/*%define parse.lac full*/


%union {
  long int4;
  float fp;
  char *str;
  struct node *n;
  struct linked_list *l;
}

%type <l> flow_content_rec phrasing_content_rec
%type <l> flow_wo_table_rec flow_wo_heading_rec flow_wo_anchor_rec
%type <n> flow_wo_table 

%type <n> html_page
%type <str> TEXT LINEBR 
%type <n> text
%type <n> head body paragraph title doctype h1 h2 h3 h4 header div
%type <n> anchor
%type <str> BEFOREHYPERLINK HYPERLINK OANCHOR
%type <n> ordlist unordlist list_item 
%type <n> desclist descterm descdesc
%type <l> termsdescs terms descs list_items
%type <n> underline bold italic emphasis strong small sub sup
%type <str> src_width_height src width height OIMG CIMG OIMGSRC CIMGSRC OIMGWIDTH CIMGWIDTH OIMGHEIGHT CIMGHEIGHT WIDTH HEIGHT
%type <n> image
%type <n> table caption tr th td thortd
%type <l> thstds trs 
%type <n> flow_content phrasing_content flow_wo_heading flow_wo_heading_table
%type <n> figure figcaption
%type <n> font center teletype
%type <str> FONTSIZE
%type <n> flow_wo_anchor flow_wo_heading_table_anchor phrasing_content_wo_anchor

%%

html_page:
  OHTML CHTML {
    $$ = create_node(HTML_T);
    add_root(t, $$);
  } |
  OHTML body CHTML {
    $$ = create_node(HTML_T);
    add_root(t, $$);
    $$->lchild = $2;
  } |
  OHTML head CHTML {
    $$ = create_node(HTML_T);
    add_root(t, $$);
    $$->lchild = $2;
  } |
  doctype OHTML CHTML {
    $$ = create_node(HTML_T);
    add_root(t, $$);
    $$->lchild = $1;
  } |
  doctype OHTML head CHTML {
    $$ = create_node(HTML_T);
    add_root(t, $$);
    $$->lchild = $1;
    $1->rsibling = $3;
  } |
  doctype OHTML body CHTML {
    $$ = create_node(HTML_T);
    add_root(t, $$);
    $$->lchild = $1;
    $1->rsibling = $3;
  } |
  OHTML head body CHTML {
    $$ = create_node(HTML_T);
    add_root(t, $$);
    $$->lchild = $2;
    $2->rsibling = $3;
  } |
  doctype OHTML head body CHTML	{ 
    $$ = create_node(HTML_T);
    add_root(t, $$);
    $$->lchild = $1;
    $1->rsibling = $3;
    $3->rsibling = $4;
  }

doctype:
  ODOCTYPE CANGBRKT {
    $$ = create_node(DOCTYPE_T);
  } |
  ODOCTYPE text CANGBRKT {
    $$ = create_node(DOCTYPE_T);
    $$->lchild = $2;
  }

head:
  OHEAD CHEAD {
    $$ = create_node(HEAD_T);
  } |
  OHEAD title CHEAD	{
    $$ = create_node(HEAD_T);
    $$->lchild = $2;
  }

title:
  OTITLE CTITLE {
    $$ = create_node(TITLE_T);
  } |
  OTITLE text CTITLE {
    $$ = create_node(TITLE_T);
    $$->lchild = $2;
  }

body:
  OBODY CBODY {
    $$ = create_node(BODY_T);
  } |
  OBODY flow_content_rec CBODY {
    $$ = create_node(BODY_T);
    $$->lchild = $2->head;
  }

flow_content_rec:
  flow_content {
    $$ = init_list();
    list_append($$, $1);
  } |
  flow_content_rec flow_content {
    list_append($1, $2);
    $$ = $1;
  }

phrasing_content_rec:
  phrasing_content {
    $$ = init_list();
    list_append($$, $1);
  } |
  phrasing_content_rec phrasing_content {
    list_append($1, $2);
    $$ = $1;
  }

flow_wo_table_rec:
  flow_wo_table {
    $$ = init_list();
    list_append($$, $1);
  } |
  flow_wo_table_rec flow_wo_table {
    list_append($1, $2);
    $$ = $1;
  }

flow_wo_heading_rec:
  flow_wo_heading {
    $$ = init_list();
    list_append($$, $1);
  } |
  flow_wo_heading_rec flow_wo_heading {
    list_append($1, $2);
    $$ = $1;
  }

flow_wo_anchor_rec:
  flow_wo_anchor {
    $$ = init_list();
    list_append($$, $1);
  } |
  flow_wo_anchor_rec flow_wo_anchor {
    list_append($1, $2);
    $$ = $1;
  }

flow_content:
  header | flow_wo_heading_table | table

flow_wo_table:
  flow_wo_heading_table | header

flow_wo_heading:
  table | flow_wo_heading_table

flow_wo_heading_table:
  flow_wo_heading_table_anchor | anchor

flow_wo_anchor:
  flow_wo_heading_table_anchor | header | table

flow_wo_heading_table_anchor:
  phrasing_content_wo_anchor | div | desclist | ordlist | paragraph | unordlist | figure

phrasing_content:
  phrasing_content_wo_anchor | anchor

phrasing_content_wo_anchor:
  text | bold | emphasis | italic | image | small | strong | sub | sup | underline | center | font | teletype |
  LINEBR {
    $$ = create_node(LINEBR_T);
  }

text:
  TEXT {
    $$ = create_node(TEXT_T);
    $$->data = $1;
  }

teletype:
  OTELETYPE phrasing_content_rec CTELETYPE {
    $$ = create_node(TELETYPE_T);
    $$->lchild = $2->head;
  }

center:
  OCENTER flow_content_rec CCENTER {
    $$ = create_node(CENTER_T);
    $$->lchild = $2->head;
  }

font:
  BEFORESIZE FONTSIZE OFONT phrasing_content_rec CFONT {
    $$ = create_node(FONT_T);
    $$->attributes=(char *)malloc(strlen($2) + strlen("size=") + 1);
    strcpy($$->attributes, "size=");
    strcat($$->attributes, $2);
    $$->lchild = $4->head;
  }

figure:
  OFIGURE figcaption flow_content_rec CFIGURE {
    $$ = create_node(FIGURE_T);
    $2->rsibling = $3->head;
    $$->lchild = $2;
  } |
  OFIGURE flow_content_rec figcaption CFIGURE {
    $$ = create_node(FIGURE_T);
    list_append($2, $3);
    $$->lchild = $2->head;
  } |
  OFIGURE flow_content_rec CFIGURE {
    $$ = create_node(FIGURE_T);
    $$->lchild = $2->head;
  }

figcaption:
  OFIGCAPTION flow_content_rec CFIGCAPTION {
    $$ = create_node(FIGCAPTION_T);
    $$->lchild = $2->head;
  }

table:
  OTABLE trs CTABLE {
    $$ = create_node(TABLE_T);
    $$->lchild = $2->head;
  } |
  OTABLE caption trs CTABLE {
    $$ = create_node(TABLE_T);
    $2->rsibling = $3->head;
    $$->lchild = $2;
  }

/* caption contents 1 and 2 are combined into one */
caption: 
  OCAPTION flow_wo_table_rec CCAPTION {
    $$ = create_node(CAPTION_T);
    $$->lchild = $2->head;
  }

trs:
  tr {
    $$ = init_list();
    list_append($$, $1);
  } |
  trs tr {
    list_append($1, $2);
    $$ = $1;
  }

tr:
  OTROW CTROW {
    $$ = create_node(TR_T);
  } |
  OTROW thstds CTROW {
    $$ = create_node(TR_T);
    $$->lchild = $2->head;
  }

thstds:
  thortd {
    $$ = init_list();
    list_append($$, $1);
  } | 
  thstds thortd {
    list_append($1, $2);
    $$ = $1;
  }

thortd:
  th | td

th:
  OTHEAD flow_wo_heading_rec CTHEAD {
    $$ = create_node(TH_T);
    $$->lchild = $2->head;
  }

td:
  OTCOL flow_content_rec CTCOL {
    $$ = create_node(TD_T);
    $$->lchild = $2->head;
  }

image:
  OIMG src_width_height CIMG {
    $$ = create_node(IMAGE_T);
    $$->attributes=$2;
  }

src_width_height:
  src {
    $$ = $1;
  } |
  src width {
    $$ = (char *)malloc(strlen($1) + strlen($2) + 2);
    strcpy($$, $1);
    strcat($$, ";");
    strcat($$, $2);
  } |
  width src {
    $$ = (char *)malloc(strlen($1) + strlen($2) + 2);
    strcpy($$, $1);
    strcat($$, ";");
    strcat($$, $2);
  } |
  src height {
    $$ = (char *)malloc(strlen($1) + strlen($2) + 2);
    strcpy($$, $1);
    strcat($$, ";");
    strcat($$, $2);
  } |
  height src {
    $$ = (char *)malloc(strlen($1) + strlen($2) + 2);
    strcpy($$, $1);
    strcat($$, ";");
    strcat($$, $2);
  } |
  src width height {
    $$ = (char *)malloc(strlen($1) + strlen($2) + strlen($3) + 3);
    strcpy($$, $1);
    strcat($$, ";");
    strcat($$, $2);
    strcat($$, ";");
    strcat($$, $3);
  } |
  src height width {
    $$ = (char *)malloc(strlen($1) + strlen($2) + strlen($3) + 3);
    strcpy($$, $1);
    strcat($$, ";");
    strcat($$, $2);
    strcat($$, ";");
    strcat($$, $3);
  } |
  height width src {
    $$ = (char *)malloc(strlen($1) + strlen($2) + strlen($3) + 3);
    strcpy($$, $1);
    strcat($$, ";");
    strcat($$, $2);
    strcat($$, ";");
    strcat($$, $3);
  } |
  height src width {
    $$ = (char *)malloc(strlen($1) + strlen($2) + strlen($3) + 3);
    strcpy($$, $1);
    strcat($$, ";");
    strcat($$, $2);
    strcat($$, ";");
    strcat($$, $3);
  } |
  width height src {
    $$ = (char *)malloc(strlen($1) + strlen($2) + strlen($3) + 3);
    strcpy($$, $1);
    strcat($$, ";");
    strcat($$, $2);
    strcat($$, ";");
    strcat($$, $3);
  } |
  width src height {
    $$ = (char *)malloc(strlen($1) + strlen($2) + strlen($3) + 3);
    strcpy($$, $1);
    strcat($$, ";");
    strcat($$, $2);
    strcat($$, ";");
    strcat($$, $3);
  }

src:
  OIMGSRC HYPERLINK CIMGSRC {
    $$ = (char *)malloc(strlen($2) + strlen("src=") + 1);
    strcpy($$, "src=");
    strcat($$, $2);
  }

width:
  OIMGWIDTH WIDTH CIMGWIDTH {
    $$ = (char *)malloc(strlen($2) + strlen("width=") + 1);
    strcpy($$, "width=");
    strcat($$, $2);
  }

height:
  OIMGHEIGHT HEIGHT CIMGHEIGHT {
    $$ = (char *)malloc(strlen($2) + strlen("height=") + 1);
    strcpy($$, "height=");
    strcat($$, $2);
  }

underline:
  OUNDERLINE phrasing_content_rec CUNDERLINE {
    $$ = create_node(UNDERLINE_T);
    $$->lchild = $2->head;
  }

bold:
  OBOLD phrasing_content_rec CBOLD {
    $$ = create_node(BOLD_T);
    $$->lchild = $2->head;
  }

italic:
  OITALIC phrasing_content_rec CITALIC {
    $$ = create_node(ITALIC_T);
    $$->lchild = $2->head;
  }

emphasis:
  OEMPHASIS phrasing_content_rec CEMPHASIS {
    $$ = create_node(EMPHASIS_T);
    $$->lchild = $2->head;
  }

strong:
  OSTRONG phrasing_content_rec CSTRONG {
    $$ = create_node(STRONG_T);
    $$->lchild = $2->head;
  }

small:
  OSMALL phrasing_content_rec CSMALL {
    $$ = create_node(SMALL_T);
    $$->lchild = $2->head;
  }

sub:
  OSUB phrasing_content_rec CSUB {
    $$ = create_node(SUB_T);
    $$->lchild = $2->head;
  }

sup:
  OSUP phrasing_content_rec CSUP {
    $$ = create_node(SUP_T);
    $$->lchild = $2->head;
  }

div:
  ODIV flow_content_rec CDIV {
    $$ = create_node(DIV_T);
    $$->lchild = $2->head;
  }

desclist:
  ODESCLIST CDESCLIST {
    $$ = create_node(DESCLIST_T);
  } |
  ODESCLIST termsdescs CDESCLIST {
    $$ = create_node(DESCLIST_T);
    $$->lchild = $2->head;
  }

termsdescs:
  terms descs {
    $$ = init_list();
    list_append($$, $1->head);
    list_append($$, $2->head);
  } |
  termsdescs terms descs {
    list_append($1, $2->head);
    list_append($1, $3->head);
    $$ = $1;
  }

terms:
  descterm {
    $$ = init_list();
    list_append($$, $1);
  } |
  terms descterm {
    list_append($1, $2);
    $$ = $1;
  }

descs:
  descdesc {
    $$ = init_list();
    list_append($$, $1);
  } |
  descs descdesc {
    list_append($1, $2);
    $$ = $1;
  }

descterm:
  ODESCTERM flow_wo_heading_rec CDESCTERM {
    $$ = create_node(DESCTERM_T);
    $$->lchild = $2->head;
  }

descdesc:
  ODESCDESC flow_content_rec CDESCDESC {
    $$ = create_node(DESCDESC_T);
    $$->lchild = $2->head;
  }

ordlist:
  OORDERLIST CORDERLIST {
    $$ = create_node(ORDLIST_T);
  } |
  OORDERLIST list_items CORDERLIST {
    $$ = create_node(ORDLIST_T);
    $$->lchild = $2->head;
  }

unordlist:
  OUNORDERLIST CUNORDERLIST {
    $$ = create_node(UNORDLIST_T);
  } |
  OUNORDERLIST list_items CUNORDERLIST {
    $$ = create_node(UNORDLIST_T);
    $$->lchild = $2->head;
  }

list_items:
  list_item {
    $$ = init_list();
    list_append($$, $1);
  } |
  list_items list_item {
    list_append($1, $2);
    $$ = $1;
  }

list_item:
  OLISTITEM flow_content_rec CLISTITEM {
    $$ = create_node(LISTITEM_T);
    $$->lchild = $2->head;
  }

anchor:
  JUSTOANCHOR CANCHOR {
    $$ = create_node(ANCHOR_T);
  } |
  BEFOREHYPERLINK HYPERLINK OANCHOR CANCHOR {
    $$ = create_node(ANCHOR_T);
    $$->attributes = (char *)malloc(strlen($2) + strlen("href=") + 1);
    strcpy($$->attributes, "href=");
    strcat($$->attributes, $2);
  } |
  JUSTOANCHOR flow_wo_anchor_rec CANCHOR {
    $$ = create_node(ANCHOR_T);
    $$->lchild = $2->head;
  } |
  BEFOREHYPERLINK HYPERLINK OANCHOR flow_wo_anchor_rec CANCHOR {
    $$ = create_node(ANCHOR_T);
    $$->attributes = (char *)malloc(strlen($2) + strlen("href=") + 1);
    strcpy($$->attributes, "href=");
    strcat($$->attributes, $2);
    $$->lchild = $4->head;
  }

header:
  h1 | h2 | h3 | h4;

h1:
  OHEADONE phrasing_content_rec CHEADONE {
    $$ = create_node(H1_T);
    $$->lchild = $2->head;
  }

h2:
  OHEADTWO phrasing_content_rec CHEADTWO {
    $$ = create_node(H2_T);
    $$->lchild = $2->head;
  }

h3:
  OHEADTHREE phrasing_content_rec CHEADTHREE {
    $$ = create_node(H3_T);
    $$->lchild = $2->head;
  }

h4:
  OHEADFOUR phrasing_content_rec CHEADFOUR {
    $$ = create_node(H4_T);
    $$->lchild = $2->head;
  }

paragraph:
  OPARA phrasing_content_rec CPARA {
    $$ = create_node(PARAGRAPH_T);
    $$->lchild = $2->head;
  }

%%

int main(int argc, char **argv) {
    t = init_tree();
    yyparse();
    print_tree(t);
    return 0;
}
