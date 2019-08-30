#ifndef _NODE_H
#define _NODE_H
typedef enum tag { /* _T for Tag */
  LINEBR_T = 1, TEXT_T, HTML_T, DOCTYPE_T, HEAD_T, BODY_T, TITLE_T, ANCHOR_T, FONT_T, CENTER_T, PARAGRAPH_T, 
  H1_T, H2_T, H3_T, H4_T, UNORDLIST_T, ORDLIST_T,
  LISTITEM_T, DESCLIST_T, DESCTERM_T, DESCDESC_T, DIV_T, UNDERLINE_T, BOLD_T, ITALIC_T, EMPHASIS_T, TELETYPE_T, STRONG_T, SMALL_T,
  SUB_T, SUP_T, IMAGE_T, FIGURE_T, FIGCAPTION_T, TABLE_T, CAPTION_T, TH_T, TR_T, TD_T
} tag;


typedef struct node {
  tag type;
  char *data; 
  char *attributes;
  struct node *parent; 
  struct node *lchild;
  struct node *rsibling;
} node;

node *create_node(tag);

#endif
