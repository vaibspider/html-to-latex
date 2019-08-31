#include <stdio.h>
#include <errno.h>
#include <string.h>
#include "tree_converter.h"
#include "lrtree.h"

/************************************************************************
 * Traverse the abstract syntax tree for html in preorder
 * While we visit a particular node, call the corresponding procedure to
   convert the html node into latex node.
 * (create a new latex abstract syntax tree)
 ************************************************************************/

tree *target;

tag map_l_type(tag type) {
  //printf("getting type for %s\n", get_tag_type(type));
  switch(type) {
    case LINEBR_T:
      return NEWLINE_T;
      break;
    case TEXT_T:
      return CONTENT_T;
      break;
    case DOCTYPE_T:
      return DOC_CLASS_T;
      break;
    case HTML_T:
      return LATEX_T;
      break;
    case HEAD_T:
      return PREAMBLE_T;
      break;
    case TITLE_T:
      return LTITLE_T;
      break;
    case BODY_T:
      return DOCUMENT_T;
      break;
    case ANCHOR_T:
      return HREF_T;
      break;
    case FONT_T:
      return FONTVAR_T;
      break;
    case CENTER_T:
      return CENTERING_T;
      break;
    case PARAGRAPH_T:
      return PARA_T;
      break;
    case H1_T:
      return LH1_T;
      break;
    case H2_T:
      return LH2_T;
      break;
    case H3_T:
      return LH3_T;
      break;
    case H4_T:
      return LH4_T;
      break;
    case UNORDLIST_T:
      return LUNORDLIST_T;
      break;
    case ORDLIST_T:
      return LORDLIST_T;
      break;
    case LISTITEM_T:
      return LITEM_T;
      break;
    case DESCLIST_T:
      return LDESCLIST_T;
      break;
    case DESCTERM_T:
      return LDESCTERM_T;
      break;
    case DESCDESC_T:
      return LDESCDESC_T;
      break;
    case DIV_T:
      return LDIV_T;
      break;
    case UNDERLINE_T:
      return LUNDERLINE_T;
      break;
    case BOLD_T:
      return LBOLD_T;
      break;
    case ITALIC_T:
      return LITALIC_T;
      break;
    case EMPHASIS_T:
      return LEMPHASIS_T;
      break;
    case TELETYPE_T:
      return LTELETYPE_T;
      break;
    case STRONG_T:
      return LBOLD_T;
      break;
    case SMALL_T:
      return LSMALL_T;
      break;
    case SUB_T:
      return LSUB_T;
      break;
    case SUP_T:
      return LSUP_T;
      break;
    case IMAGE_T:
      return LIMAGE_T;
      break;
    case FIGURE_T:
      return LFIGURE_T;
      break;
    case FIGCAPTION_T:
      return LFIGCAPTION_T;
      break;
    case TABLE_T:
      return LTABLE_T;
      break;
    case CAPTION_T:
      return LCAPTION_T;
      break;
    case TH_T:
      return LTH_T;
      break;
    case TR_T:
      return LTR_T;
      break;
    case TD_T:
      return LTD_T;
      break;
    default:
      return INVALID_T;
      break;
  }
}

node *convert_node(node *htm_node, tag type) {
  node *ltx_node;
  ltx_node = create_node(type);
  /*if (type == HREF_T)
    printf("HREF_T in convert_node\n");*/
  if (htm_node->data) {
    /*if (type == HREF_T)
      printf("HREF_T in convert_node\n");*/
    ltx_node->data = strdup(htm_node->data);/* to be implemented ; processing and converting data */
  }
  if (htm_node->attributes) {
    /*if (type == HREF_T)
      printf("HREF_T in convert_node\n");*/
    ltx_node->attributes = strdup(htm_node->attributes);/* to be implemented; processing and converting attributes */
  }
  /*if (type == HREF_T)
    printf("HREF_T in convert_node\n");*/
  ltx_node->lchild = ltx_node->rsibling = NULL;
  return ltx_node;
}

node *ltraverse(node *n) {
  node *temp;
  if (n == NULL) {
    return NULL;
  }
  //Assuming that n->type is present
  tag ltype = map_l_type(n->type);
  //printf("got ltype: %s\n", get_tag_type(ltype));
  if (ltype == INVALID_T) {
    perror("Invalid: Mapping not available!\n");
    return NULL;
  }
  if (ltype == SKIP_T) {
    ;/* stub */
  }
  else {
    temp = convert_node(n, ltype);
    if (n->lchild && n->type != DOCTYPE_T) {
      //printf("going left::%s\n", get_tag_type(n->type));
      temp->lchild = ltraverse(n->lchild);
    }
    if (n->rsibling) {
      //printf("going right::%s\n", get_tag_type(n->type));
      temp->rsibling = ltraverse(n->rsibling);
    }
  }
  //printf("returning from::%s\n", get_tag_type(n->type));
  return temp;
}

tree *convert(tree *src) {
  node *sroot, *troot;
  target = init_tree();
  if (src == NULL) {
    perror("Null Tree!\n");
    return NULL;
  }
  sroot = src->root;
  if (sroot == NULL) {
    perror("Empty Tree!\n");
    return src;
  }
  troot = ltraverse(sroot);
  //printf("returned\n");
  target->root = troot;
  return target;
}
