#include "lrtree.h"
#include "linked_list.h"
#include "stack.h"
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

void print(node *n);

list *body_kids, *tt_kids, *center_kids, *font_kids, *figure_kids, *figcaption_kids, *table_kids, *caption_kids, *tr_kids, *th_kids,\
     *td_kids, *underline_kids, *bold_kids, *italic_kids, *emphasis_kids, *strong_kids, *small_kids, *sub_kids, *sup_kids, *div_kids,\
     *desclist_kids, *descterm_kids, *descdesc_kids, *ordlist_kids, *unordlist_kids, *listitem_kids, *anchor_kids, *h1_kids, *h2_kids,\
     *h3_kids, *h4_kids, *paragraph_kids;

void add_a_kid(node *n, tag parent_type) {
  switch(parent_type) {
    case BODY_T:
      list_append(body_kids, n);
      break;
    case TELETYPE_T:
      list_append(tt_kids, n);
      break;
    case CENTER_T:
      list_append(center_kids, n);
      break;
    case FONT_T:
      list_append(font_kids, n);
      break;
    case FIGURE_T:
      list_append(figure_kids, n);
      break;
    case FIGCAPTION_T:
      list_append(figcaption_kids, n);
      break;
    case TABLE_T:
      list_append(table_kids, n);
      break;
    case CAPTION_T:
      list_append(caption_kids, n);
      break;
    case TR_T:
      list_append(tr_kids, n);
      break;
    case TH_T:
      list_append(th_kids, n);
      break;
    case TD_T:
      list_append(td_kids, n);
      break;
    case UNDERLINE_T:
      list_append(underline_kids, n);
      break;
    case BOLD_T:
      list_append(bold_kids, n);
      break;
    case ITALIC_T:
      list_append(italic_kids, n);
      break;
    case EMPHASIS_T:
      list_append(emphasis_kids, n);
      break;
    case STRONG_T:
      list_append(strong_kids, n);
      break;
    case SMALL_T:
      list_append(small_kids, n);
      break;
    case SUB_T:
      list_append(sub_kids, n);
      break;
    case SUP_T:
      list_append(sup_kids, n);
      break;
    case DIV_T:
      list_append(div_kids, n);
      break;
    case DESCLIST_T:
      list_append(desclist_kids, n);
      break;
    case DESCTERM_T:
      list_append(descterm_kids, n);
      break;
    case DESCDESC_T:
      list_append(descdesc_kids, n);
      break;
    case ORDLIST_T:
      list_append(ordlist_kids, n);
      break;
    case UNORDLIST_T:
      list_append(unordlist_kids, n);
      break;
    case LISTITEM_T:
      list_append(listitem_kids, n);
      break;
    case ANCHOR_T:
      list_append(anchor_kids, n);
      break;
    case H1_T:
      list_append(h1_kids, n);
      break;
    case H2_T:
      list_append(h2_kids, n);
      break;
    case H3_T:
      list_append(h3_kids, n);
      break;
    case H4_T:
      list_append(h4_kids, n);
      break;
    case PARAGRAPH_T:
      list_append(paragraph_kids, n);
      break;
    default:
      break;
  }
}

void init_kids(tag type) {
  switch(type) {
    case BODY_T:
      body_kids = init_list();
      break;
    case TELETYPE_T:
      tt_kids = init_list();
      break;
    case CENTER_T:
      center_kids = init_list();
      break;
    case FONT_T:
      font_kids = init_list();
      break;
    case FIGURE_T:
      figure_kids = init_list();
      break;
    case FIGCAPTION_T:
      figcaption_kids = init_list();
      break;
    case TABLE_T:
      table_kids = init_list();
      break;
    case CAPTION_T:
      caption_kids = init_list();
      break;
    case TR_T:
      tr_kids = init_list();
      break;
    case TH_T:
      th_kids = init_list();
      break;
    case TD_T:
      td_kids = init_list();
      break;
    case UNDERLINE_T:
      underline_kids = init_list();
      break;
    case BOLD_T:
      bold_kids = init_list();
      break;
    case ITALIC_T:
      italic_kids = init_list();
      break;
    case EMPHASIS_T:
      emphasis_kids = init_list();
      break;
    case STRONG_T:
      strong_kids = init_list();
      break;
    case SMALL_T:
      small_kids = init_list();
      break;
    case SUB_T:
      sub_kids = init_list();
      break;
    case SUP_T:
      sup_kids = init_list();
      break;
    case DIV_T:
      div_kids = init_list();
      break;
    case DESCLIST_T:
      desclist_kids = init_list();
      break;
    case DESCTERM_T:
      descterm_kids = init_list();
      break;
    case DESCDESC_T:
      descdesc_kids = init_list();
      break;
    case ORDLIST_T:
      ordlist_kids = init_list();
      break;
    case UNORDLIST_T:
      unordlist_kids = init_list();
      break;
    case LISTITEM_T:
      listitem_kids = init_list();
      break;
    case ANCHOR_T:
      anchor_kids = init_list();
      break;
    case H1_T:
      h1_kids = init_list();
      break;
    case H2_T:
      h2_kids = init_list();
      break;
    case H3_T:
      h3_kids = init_list();
      break;
    case H4_T:
      h4_kids = init_list();
      break;
    case PARAGRAPH_T:
      paragraph_kids = init_list();
      break;
    default:
      body_kids = init_list();
      tt_kids = init_list();
      center_kids = init_list();
      font_kids = init_list();
      figure_kids = init_list();
      figcaption_kids = init_list();
      table_kids = init_list();
      caption_kids = init_list();
      tr_kids = init_list();
      th_kids = init_list();
      td_kids = init_list();
      underline_kids = init_list();
      bold_kids = init_list();
      italic_kids = init_list();
      emphasis_kids = init_list();
      strong_kids = init_list();
      small_kids = init_list();
      sub_kids = init_list();
      sup_kids = init_list();
      div_kids = init_list();
      desclist_kids = init_list();
      descterm_kids = init_list();
      descdesc_kids = init_list();
      ordlist_kids = init_list();
      unordlist_kids = init_list();
      listitem_kids = init_list();
      anchor_kids = init_list();
      h1_kids = init_list();
      h2_kids = init_list();
      h3_kids = init_list();
      h4_kids = init_list();
      paragraph_kids = init_list();
      break;
  }
}

void take_kids(tag type, node *n) {
  switch(type) {
    case BODY_T:
      n->lchild = body_kids->head;
      break;
    case TELETYPE_T:
      n->lchild = tt_kids->head;
      init_kids(TELETYPE_T);
      break;
    case CENTER_T:
      n->lchild = center_kids->head;
      init_kids(CENTER_T);
      break;
    case FONT_T:
      n->lchild = font_kids->head;
      init_kids(FONT_T);
      break;
    case FIGURE_T:
      n->lchild = figure_kids->head;
      init_kids(FIGURE_T);
      break;
    case FIGCAPTION_T:
      n->lchild = figcaption_kids->head;
      init_kids(FIGCAPTION_T);
      break;
    case TABLE_T:
      n->lchild = table_kids->head;
      init_kids(TABLE_T);
      break;
    case CAPTION_T:
      n->lchild = caption_kids->head;
      init_kids(CAPTION_T);
      break;
    case TR_T:
      n->lchild = tr_kids->head;
      init_kids(TR_T);
      break;
    case TH_T:
      n->lchild = th_kids->head;
      init_kids(TH_T);
      break;
    case TD_T:
      n->lchild = td_kids->head;
      init_kids(TD_T);
      break;
    case UNDERLINE_T:
      n->lchild = underline_kids->head;
      init_kids(UNDERLINE_T);
      break;
    case BOLD_T:
      n->lchild = bold_kids->head;
      init_kids(BOLD_T);
      break;
    case ITALIC_T:
      n->lchild = italic_kids->head;
      init_kids(ITALIC_T);
      break;
    case EMPHASIS_T:
      n->lchild = emphasis_kids->head;
      init_kids(EMPHASIS_T);
      break;
    case STRONG_T:
      n->lchild = strong_kids->head;
      init_kids(STRONG_T);
      break;
    case SMALL_T:
      n->lchild = small_kids->head;
      init_kids(SMALL_T);
      break;
    case SUB_T:
      n->lchild = sub_kids->head;
      init_kids(SUB_T);
      break;
    case SUP_T:
      n->lchild = sup_kids->head;
      init_kids(SUP_T);
      break;
    case DIV_T:
      n->lchild = div_kids->head;
      init_kids(DIV_T);
      break;
    case DESCLIST_T:
      n->lchild = desclist_kids->head;
      init_kids(DESCLIST_T);
      break;
    case DESCTERM_T:
      n->lchild = descterm_kids->head;
      init_kids(DESCTERM_T);
      break;
    case DESCDESC_T:
      n->lchild = descdesc_kids->head;
      init_kids(DESCDESC_T);
      break;
    case ORDLIST_T:
      n->lchild = ordlist_kids->head;
      init_kids(ORDLIST_T);
      break;
    case UNORDLIST_T:
      n->lchild = unordlist_kids->head;
      init_kids(UNORDLIST_T);
      break;
    case LISTITEM_T:
      n->lchild = listitem_kids->head;
      init_kids(LISTITEM_T);
      break;
    case ANCHOR_T:
      n->lchild = anchor_kids->head;
      init_kids(ANCHOR_T);
      break;
    case H1_T:
      n->lchild = h1_kids->head;
      init_kids(H1_T);
      break;
    case H2_T:
      n->lchild = h2_kids->head;
      init_kids(H2_T);
      break;
    case H3_T:
      n->lchild = h3_kids->head;
      init_kids(H3_T);
      break;
    case H4_T:
      n->lchild = h4_kids->head;
      init_kids(H4_T);
      break;
    case PARAGRAPH_T:
      n->lchild = paragraph_kids->head;
      init_kids(PARAGRAPH_T);
      break;
    default:
      break;
  }
}

node *new_node(char *data, tag type) {
  node *new = (node *)malloc(sizeof(node));
  if(new == NULL) {
    perror("Unable to allocate memory!\n");
  }
  new->type = type;
  if ((new->data = data)) {
    new->data = strdup(data); /* check if we really need strdup() */
  }
  new->parent = new->lchild = new->rsibling = NULL;
  return new;
}

tree *init_tree() {
  tree *t = (tree *)malloc(sizeof(tree));
  t->root = NULL;
  return t;
}

tree *add_node(tree *t, node *n, node *parent) { /* no need of tree t */
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

char *get_tag_type(tag type) {
  switch(type) {
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
