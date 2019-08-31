#include "lrtree.h"
#include "linked_list.h"
#include "stack.h"
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

void print(node *n);

tree *init_tree() {
  tree *t = (tree *)malloc(sizeof(tree));
  if (t == NULL) {
    perror("Unable to allocate memory!\n");
    exit(1);
  }
  t->root = NULL;
  return t;
}

tree *add_node(tree *t, node *n, node *parent) {
  node *p = parent->lchild;
  if (p == NULL) {
    parent->lchild = n;
    n->parent = parent;
    return t;
  }
  while(p->rsibling) {
    p = p->rsibling;
  }
  p->rsibling = n;
  n->parent = parent;
  return t;
}

tree *add_root(tree *t, node *n) {
  if (t) {
    t->root = n;
  }
  return t;
}

node *traverse(node *n, tag type) {
  node *temp = NULL;
  if (n == NULL) {
    return NULL;
  }
  if (n->type == type) {
    return n;
  }
  else {
    if (n->lchild) {
      temp = traverse(n->lchild, type);
      if (temp) return temp;
    }
    if (n->rsibling) {
      temp = traverse(n->rsibling, type);
      if (temp) return temp;
    }
    return NULL;
  }
}

/* a helper function used to print a tree */
char *get_tag_type(tag type) {
  switch(type) {
    case NEWLINE_T:
      return "NEWLINE_T";
    case CONTENT_T:
      return "CONTENT_T";
    case LATEX_T:
      return "LATEX_T";
    case DOC_CLASS_T:
      return "DOC_CLASS_T";
    case PREAMBLE_T:
      return "PREAMBLE_T";
    case DOCUMENT_T:
      return "DOCUMENT_T";
    case LTITLE_T:
      return "LTITLE_T";
    case HREF_T:
      return "HREF_T";
    case FONTVAR_T:
      return "FONTVAR_T";
    case CENTERING_T:
      return "CENTERING_T";
    case PARA_T:
      return "PARA_T";
    case LH1_T:
      return "LH1_T";
    case LH2_T:
      return "LH2_T";
    case LH3_T:
      return "LH3_T";
    case LH4_T:
      return "LH4_T";
    case LUNORDLIST_T:
      return "LUNORDLIST_T";
    case LORDLIST_T:
      return "LORDLIST_T";
    case LDESCLIST_T:
      return "LDESCLIST_T";
    case LDESCTERM_T:
      return "LDESCTERM_T";
    case LDESCDESC_T:
      return "LDESCDESC_T";
    case LDIV_T:
      return "LDIV_T";
    case LITEM_T:
      return "LITEM_T";
    case LUNDERLINE_T:
      return "LUNDERLINE_T";
    case LBOLD_T:
      return "LBOLD_T";
    case LITALIC_T:
      return "LITALIC_T";
    case LEMPHASIS_T:
      return "LEMPHASIS_T";
    case LTELETYPE_T:
      return "LTELETYPE_T";
    case LSMALL_T:
      return "LSMALL_T";
    case HSPACE_T:
      return "HSPACE_T";
    case LSUB_T:
      return "LSUB_T";
    case LSUP_T:
      return "LSUP_T";
    case LIMAGE_T:
      return "LIMAGE_T";
    case LFIGURE_T:
      return "LFIGURE_T";
    case LFIGCAPTION_T:
      return "LFIGCAPTION_T";
    case LTABLE_T:
      return "LTABLE_T";
    case LCAPTION_T:
      return "LCAPTION_T";
    case LTH_T:
      return "LTH_T";
    case LTR_T:
      return "LTR_T";
    case LTD_T:
      return "LTD_T";


    case LINEBR_T:
      return "LINEBR_T";
    case TEXT_T:
      return "TEXT_T";
    case HTML_T:
      return "HTML_T";
    case DOCTYPE_T:
      return "DOCTYPE_T";
    case HEAD_T:
      return "HEAD_T";
    case BODY_T:
      return "BODY_T";
    case TITLE_T:
      return "TITLE_T";
    case ANCHOR_T:
      return "ANCHOR_T";
    case FONT_T:
      return "FONT_T";
    case CENTER_T:
      return "CENTER_T";
    case PARAGRAPH_T:
      return "PARAGRAPH_T";
    case H1_T:
      return "H1_T";
    case H2_T:
      return "H2_T";
    case H3_T:
      return "H3_T";
    case H4_T:
      return "H4_T";
    case UNORDLIST_T:
      return "UNORDLIST_T";
    case ORDLIST_T:
      return "ORDLIST_T";
    case LISTITEM_T:
      return "LISTITEM_T";
    case DESCLIST_T:
      return "DESCLIST_T";
    case DESCTERM_T:
      return "DESCTERM_T";
    case DESCDESC_T:
      return "DESCDESC_T";
    case DIV_T:
      return "DIV_T";
    case UNDERLINE_T:
      return "UNDERLINE_T";
    case BOLD_T:
      return "BOLD_T";
    case ITALIC_T:
      return "ITALIC_T";
    case EMPHASIS_T:
      return "EMPHASIS_T";
    case TELETYPE_T:
      return "TELETYPE_T";
    case STRONG_T:
      return "STRONG_T";
    case SMALL_T:
      return "SMALL_T";
    case SUB_T:
      return "SUB_T";
    case SUP_T:
      return "SUP_T";
    case IMAGE_T:
      return "IMAGE_T";
    case FIGURE_T:
      return "FIGURE_T";
    case FIGCAPTION_T:
      return "FIGCAPTION_T";
    case TABLE_T:
      return "TABLE_T";
    case CAPTION_T:
      return "CAPTION_T";
    case TH_T:
      return "TH_T";
    case TR_T:
      return "TR_T";
    case TD_T:
      return "TD_T";
    default:
      return "EMPTY";
  }
}

void print(node *n) {
  if (n && n->type) {
    //printf(":::%d:::", n->type);
    printf(":::%s:::", get_tag_type(n->type));
    if (n->data) {
      printf(":::%s:::\n", n->data);
    }
  }
  if (n->lchild) {
    print(n->lchild);
  }
  if (n->rsibling) {
    print(n->rsibling);
  }
}

void print_tree(tree *t) {
  node *r;
  if (t == NULL) {
    printf("Null Tree!\n");
    return;
  }
  r = t->root;
  if (r == NULL) {
    printf("Empty Tree!\n");
    return;
  }
  print(r);
  printf("\n");
}

node *find_node(tree *t, tag type) {
  node *r = t->root;
  return traverse(r, type);
}

/*
int main(int argc, char **argv) {
  tree *t = init_tree();
  node *new = new_node("webpage", NON_TERMINAL);
  add_root(t, new);
  node *new = new_node("<html>", TERMINAL);
  add_node(t, new, 
  node *new = new_node("<html>", TERMINAL);
  return 0;
}
*/
