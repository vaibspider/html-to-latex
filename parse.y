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

  extern list *body_kids, *tt_kids, *center_kids, *font_kids, *figure_kids, *figcaption_kids, *table_kids, *caption_kids, *tr_kids, *th_kids, *td_kids, *underline_kids, *bold_kids, *italic_kids, *emphasis_kids, *strong_kids, *small_kids, *sub_kids, *sup_kids, *div_kids, *desclist_kids, *descterm_kids, *descdesc_kids, *ordlist_kids, *unordlist_kids, *listitem_kids, *anchor_kids, *h1_kids, *h2_kids, *h3_kids, *h4_kids, *paragraph_kids;
  
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
}

%type <n> html_page
%type <str> TEXT LINEBR 
%type <n> text
%type <n> head body paragraph body_content title doctype h1 h2 h3 h4 header div
%type <n> anchor
%type <str> BEFOREHYPERLINK HYPERLINK OANCHOR
%type <n> ordlist unordlist list_item list_items_o list_items_u
%type <n> desclist termsdescs descterm descdesc terms descs
%type <n> underline bold italic emphasis strong small sub sup
%type <str> src_width_height src width height OIMG CIMG OIMGSRC CIMGSRC OIMGWIDTH CIMGWIDTH OIMGHEIGHT CIMGHEIGHT WIDTH HEIGHT
%type <n> image
%type <n> table caption trs tr thstds th td
%type <n> flow_content phrasing_content flow_wo_heading flow_wo_heading_table
%type <n> figure figcaption
%type <n> paragraph_content h4_content h3_content h2_content h1_content list_item_content div_content
%type <n> sup_content sub_content small_content strong_content emphasis_content italic_content bold_content underline_content
%type <n> td_content th_content caption_content figcaption_content figure_content
%type <n> font font_content center center_content teletype teletype_content
%type <str> FONTSIZE
%type <n> descterm_content descdesc_content flow_wo_anchor flow_wo_heading_table_anchor phrasing_content_wo_anchor anchor_content

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
    /* ignore doctype */
  } |
  doctype OHTML head CHTML {
    $$ = create_node(HTML_T);
    add_root(t, $$);
    $$->lchild = $3;
    /* ignore doctype */
  } |
  doctype OHTML body CHTML {
    $$ = create_node(HTML_T);
    add_root(t, $$);
    $$->lchild = $3;
    /* ignore doctype */
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
    $$->lchild = $3;
    $3->rsibling = $4;
    /* ignore doctype */
  }

doctype:
  ODOCTYPE CANGBRKT {
  } |
  ODOCTYPE text CANGBRKT {
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
  OBODY body_content CBODY {
    $$ = create_node(BODY_T);
    take_kids(BODY_T, $$);
  }

body_content:
  flow_content {
    add_a_kid($1, BODY_T);
  } |
  body_content flow_content {
    add_a_kid($2, BODY_T);
  }

flow_content:
  header | flow_wo_heading_table | table

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
  OTELETYPE teletype_content CTELETYPE {
    $$ = create_node(TELETYPE_T);
    take_kids(TELETYPE_T, $$);
  }

teletype_content:
  phrasing_content {
    add_a_kid($1, TELETYPE_T);
  } |
  teletype_content phrasing_content {
    add_a_kid($2, TELETYPE_T);
  }

center:
  OCENTER center_content CCENTER {
    $$ = create_node(CENTER_T);
    take_kids(CENTER_T, $$);
  }

center_content:
  flow_content {
    add_a_kid($1, CENTER_T);
  } |
  center_content flow_content {
    add_a_kid($2, CENTER_T);
  }

font:
  BEFORESIZE FONTSIZE OFONT font_content CFONT {
    $$ = create_node(FONT_T);
    $$->attributes=(char *)malloc(strlen($2) + strlen("size=") + 1);
    strcpy($$->attributes, "size=");
    strcat($$->attributes, $2);
    take_kids(FONT_T, $$);
  }

font_content:
  phrasing_content {
    add_a_kid($1, FONT_T);
  } |
  font_content phrasing_content {
    add_a_kid($2, FONT_T);
  }

figure:
  OFIGURE figcaption figure_content CFIGURE {
    $$ = create_node(FIGURE_T);
    take_kids(FIGURE_T, $$);
  } |
  OFIGURE figure_content figcaption CFIGURE {
    $$ = create_node(FIGURE_T);
    take_kids(FIGURE_T, $$);
  } |
  OFIGURE figure_content CFIGURE {
    $$ = create_node(FIGURE_T);
    take_kids(FIGURE_T, $$);
  }

figure_content:
  flow_content {
    add_a_kid($1, FIGURE_T);
  } |
  figure_content flow_content {
    add_a_kid($2, FIGURE_T);
  }

figcaption:
  OFIGCAPTION figcaption_content CFIGCAPTION {
    $$ = create_node(FIGCAPTION_T);
    take_kids(FIGCAPTION_T, $$);
    add_a_kid($2, FIGURE_T);
  }

figcaption_content:
  flow_content {
    add_a_kid($1, FIGCAPTION_T);
  } |
  figcaption_content flow_content {
    add_a_kid($2, FIGCAPTION_T);
  }

table:
  OTABLE trs CTABLE {
    $$ = create_node(TABLE_T);
    take_kids(TABLE_T, $$);
  } |
  OTABLE caption trs CTABLE {
    $$ = create_node(TABLE_T);
    take_kids(TABLE_T, $$);
  }

/* caption contents 1 and 2 are combined into one */
caption: 
  OCAPTION caption_content CCAPTION {
    $$ = create_node(CAPTION_T);
    take_kids(CAPTION_T, $$);
    add_a_kid($2, TABLE_T);
  }

caption_content:
  header {add_a_kid($1, CAPTION_T);} |
  flow_wo_heading_table {add_a_kid($1, CAPTION_T);} |
  caption_content header {
    add_a_kid($2, CAPTION_T);
  } |
  caption_content flow_wo_heading_table {
    add_a_kid($2, CAPTION_T);
  }

trs:
  tr {
    add_a_kid($1, TABLE_T);
  } |
  trs tr {
    add_a_kid($2, TABLE_T);
  }

tr:
  OTROW CTROW {
    $$ = create_node(TR_T);
  } |
  OTROW thstds CTROW {
    $$ = create_node(TR_T);
    take_kids(TR_T, $$);
  }

thstds:
  th {
    add_a_kid($1, TR_T);
  } | 
  td {
    add_a_kid($1, TR_T);
  } |
  thstds th {
    add_a_kid($2, TR_T);
  } |
  thstds td {
    add_a_kid($2, TR_T);
  }

th:
  OTHEAD th_content CTHEAD {
    $$ = create_node(TH_T);
    take_kids(TH_T, $$);
  }

th_content:
  flow_wo_heading {
    add_a_kid($1, TH_T);
  } |
  th_content flow_wo_heading {
    add_a_kid($2, TH_T);
  }

td:
  OTCOL td_content CTCOL {
    $$ = create_node(TD_T);
    take_kids(TD_T, $$);
  }

td_content:
  flow_content {
    add_a_kid($1, TD_T);
  } |
  td_content flow_content {
    add_a_kid($2, TD_T);
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
  OUNDERLINE underline_content CUNDERLINE {
    $$ = create_node(UNDERLINE_T);
    take_kids(UNDERLINE_T, $$);
  }

underline_content:
  phrasing_content {
    add_a_kid($1, UNDERLINE_T);
  } |
  underline_content phrasing_content {
    add_a_kid($2, UNDERLINE_T);
  }

bold:
  OBOLD bold_content CBOLD {
    $$ = create_node(BOLD_T);
    take_kids(BOLD_T, $$);
  }

bold_content:
  phrasing_content {
    add_a_kid($1, BOLD_T);
  } |
  bold_content phrasing_content {
    add_a_kid($2, BOLD_T);
  }

italic:
  OITALIC italic_content CITALIC {
    $$ = create_node(ITALIC_T);
    take_kids(ITALIC_T, $$);
  }

italic_content:
  phrasing_content {
    add_a_kid($1, ITALIC_T);
  } |
  italic_content phrasing_content {
    add_a_kid($2, ITALIC_T);
  }

emphasis:
  OEMPHASIS emphasis_content CEMPHASIS {
    $$ = create_node(EMPHASIS_T);
    take_kids(EMPHASIS_T, $$);
  }

emphasis_content:
  phrasing_content {
    add_a_kid($1, EMPHASIS_T);
  } |
  emphasis_content phrasing_content {
    add_a_kid($2, EMPHASIS_T);
  }

strong:
  OSTRONG strong_content CSTRONG {
    $$ = create_node(STRONG_T);
    take_kids(STRONG_T, $$);
  }

strong_content:
  phrasing_content {
    add_a_kid($1, STRONG_T);
  } |
  strong_content phrasing_content {
    add_a_kid($2, STRONG_T);
  }

small:
  OSMALL small_content CSMALL {
    $$ = create_node(SMALL_T);
    take_kids(SMALL_T, $$);
  }

small_content:
  phrasing_content {
    add_a_kid($1, SMALL_T);
  } |
  small_content phrasing_content {
    add_a_kid($2, SMALL_T);
  }

sub:
  OSUB sub_content CSUB {
    $$ = create_node(SUB_T);
    take_kids(SUB_T, $$);
  }

sub_content:
  phrasing_content {
    add_a_kid($1, SUB_T);
  } |
  sub_content phrasing_content {
    add_a_kid($2, SUB_T);
  }

sup:
  OSUP sup_content CSUP {
    $$ = create_node(SUP_T);
    take_kids(SUP_T, $$);
  }

sup_content:
  phrasing_content {
    add_a_kid($1, SUP_T);
  } |
  sup_content phrasing_content {
    add_a_kid($2, SUP_T);
  }

div:
  ODIV div_content CDIV {
    $$ = create_node(DIV_T);
    take_kids(DIV_T, $$);
  }

div_content:
  flow_content {
    add_a_kid($1, DIV_T);
  } |
  div_content flow_content {
    add_a_kid($2, DIV_T);
  }

desclist:
  ODESCLIST CDESCLIST {
    $$ = create_node(DESCLIST_T);
  } |
  ODESCLIST termsdescs CDESCLIST {
    $$ = create_node(DESCLIST_T);
    take_kids(DESCLIST_T, $$);
  }

termsdescs:
  terms descs {
  } |
  termsdescs terms descs {
  }

terms:
  descterm {
    add_a_kid($1, DESCLIST_T);
  } |
  terms descterm {
    add_a_kid($2, DESCLIST_T);
  }

descs:
  descdesc {
    add_a_kid($1, DESCLIST_T);
  } |
  descs descdesc {
    add_a_kid($2, DESCLIST_T);
  }

descterm:
  ODESCTERM descterm_content CDESCTERM {
    $$ = create_node(DESCTERM_T);
    take_kids(DESCTERM_T, $$);
  }

descterm_content:
  flow_wo_heading {
    add_a_kid($1, DESCTERM_T);
  } |
  descterm_content flow_wo_heading {
    add_a_kid($2, DESCTERM_T);
  }

descdesc:
  ODESCDESC descdesc_content CDESCDESC {
    $$ = create_node(DESCDESC_T);
    take_kids(DESCDESC_T, $$);
  }

descdesc_content:
  flow_content {
    add_a_kid($1, DESCDESC_T);
  } |
  descdesc_content flow_content {
    add_a_kid($2, DESCDESC_T);
  }

ordlist:
  OORDERLIST CORDERLIST {
    $$ = create_node(ORDLIST_T);
  } |
  OORDERLIST list_items_o CORDERLIST {
    $$ = create_node(ORDLIST_T);
    take_kids(ORDLIST_T, $$);
  }

unordlist:
  OUNORDERLIST CUNORDERLIST {
    $$ = create_node(UNORDLIST_T);
  } |
  OUNORDERLIST list_items_u CUNORDERLIST {
    $$ = create_node(UNORDLIST_T);
    take_kids(UNORDLIST_T, $$);
  }

list_items_o:
  list_item {
    add_a_kid($1, ORDLIST_T);
  } |
  list_items_o list_item {
    add_a_kid($2, ORDLIST_T);
  }

list_items_u:
  list_item {
    add_a_kid($1, UNORDLIST_T);
  } |
  list_items_u list_item {
    add_a_kid($2, UNORDLIST_T);
  }

list_item:
  OLISTITEM list_item_content CLISTITEM {
    $$ = create_node(LISTITEM_T);
    take_kids(LISTITEM_T, $$);
  }

list_item_content:
  flow_content {
    add_a_kid($1, LISTITEM_T);
  } |
  list_item_content flow_content {
    add_a_kid($2, LISTITEM_T);
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
  JUSTOANCHOR anchor_content CANCHOR {
    $$ = create_node(ANCHOR_T);
    take_kids(ANCHOR_T, $$);
  } |
  BEFOREHYPERLINK HYPERLINK OANCHOR anchor_content CANCHOR {
    $$ = create_node(ANCHOR_T);
    $$->attributes = (char *)malloc(strlen($2) + strlen("href=") + 1);
    strcpy($$->attributes, "href=");
    strcat($$->attributes, $2);
    take_kids(ANCHOR_T, $$);
  }

anchor_content:
  flow_wo_anchor {
    add_a_kid($1, ANCHOR_T);
  } |
  anchor_content flow_wo_anchor {
    add_a_kid($2, ANCHOR_T);
  }

header:
  h1 | h2 | h3 | h4;

h1:
  OHEADONE h1_content CHEADONE {
    $$ = create_node(H1_T);
    take_kids(H1_T, $$);
  }

h1_content:
  phrasing_content {
    add_a_kid($1, H1_T);
  } |
  h1_content phrasing_content {
    add_a_kid($2, H1_T);
  }

h2:
  OHEADTWO h2_content CHEADTWO {
    $$ = create_node(H2_T);
    take_kids(H2_T, $$);
  }

h2_content:
  phrasing_content {
    add_a_kid($1, H2_T);
  } |
  h2_content phrasing_content {
    add_a_kid($2, H2_T);
  }

h3:
  OHEADTHREE h3_content CHEADTHREE {
    $$ = create_node(H3_T);
    take_kids(H3_T, $$);
  }

h3_content:
  phrasing_content {
    add_a_kid($1, H3_T);
  } |
  h3_content phrasing_content {
    add_a_kid($2, H3_T);
  }

h4:
  OHEADFOUR h4_content CHEADFOUR {
    $$ = create_node(H4_T);
    take_kids(H4_T, $$);
  }

h4_content:
  phrasing_content {
    add_a_kid($1, H4_T);
  } |
  h4_content phrasing_content {
    add_a_kid($2, H4_T);
  }

paragraph:
  OPARA paragraph_content CPARA {
    $$ = create_node(PARAGRAPH_T);
    //print_list(paragraph_kids);
    take_kids(PARAGRAPH_T, $$);
    //print($$);
    //print_list(paragraph_kids);
  }

paragraph_content:
  phrasing_content {
    add_a_kid($1, PARAGRAPH_T);
  } |
  paragraph_content phrasing_content {
    add_a_kid($2, PARAGRAPH_T);
  }

%%

int main(int argc, char **argv) {
    t = init_tree();
    init_kids(-1);
    yyparse();
    print_tree(t);
    return 0;
}
