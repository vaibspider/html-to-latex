#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include "tree_converter.h"
#include "lrtree.h"
#define SIZE 2000
#define MAXSRC 100

/************************************************************************
 * Traverse the abstract syntax tree for html in preorder
 * While we visit a particular node, call the corresponding procedure to
   convert the html node into latex node.
 * (create a new latex abstract syntax tree)
 ************************************************************************/

tree *target;
FILE *fp;

int anchorseen = 0;
int imageseen = 0;
int titleseen = 0;
int tablecols = 0;

tag map_l_type(tag type) {
  //printf("getting type for %s\n", get_tag_type(type));
  switch(type) {
    case SYMBOL_T:
      return SYMBOL_T;
      break;
    case AMPERSAND_T:
      return AMPERSAND_T;
      break;
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

char *get_symbol_mapping(char *symbol) {
  if (strcmp(symbol, "&nbsp;") == 0) {
    return "\ ";
  }
  if (strcmp(symbol, "&alpha;") == 0) {
    return "$\\alpha$";
  }
  if (strcmp(symbol, "&beta;") == 0) {
    return "$\\beta$";
  }
  if (strcmp(symbol, "&gamma;") == 0) {
    return "$\\gamma$";
  }
  if (strcmp(symbol, "&delta;") == 0) {
    return "$\\delta$";
  }
  if (strcmp(symbol, "&epsilon;") == 0) {
    return "$\\epsilon$";
  }
  if (strcmp(symbol, "&zeta;") == 0) {
    return "$\\zeta$";
  }
  if (strcmp(symbol, "&eta;") == 0) {
    return "$\\eta$";
  }
  if (strcmp(symbol, "&theta;") == 0) {
    return "$\\theta$";
  }
  if (strcmp(symbol, "&iota;") == 0) {
    return "$\\iota$";
  }
  if (strcmp(symbol, "&kappa;") == 0) {
    return "$\\kappa$";
  }
  if (strcmp(symbol, "&lambda;") == 0) {
    return "$\\lambda$";
  }
  if (strcmp(symbol, "&mu;") == 0) {
    return "$\\mu$";
  }
  if (strcmp(symbol, "&nu;") == 0) {
    return "$\\nu$";
  }
  if (strcmp(symbol, "&xi;") == 0) {
    return "$\\xi$";
  }
  if (strcmp(symbol, "&omicron;") == 0) {
    return "$o$";
  }
  if (strcmp(symbol, "&pi;") == 0) {
    return "$\\pi$";
  }
  if (strcmp(symbol, "&rho;") == 0) {
    return "$\\rho$";
  }
  if (strcmp(symbol, "&sigma;") == 0) {
    return "$\\sigma$";
  }
  if (strcmp(symbol, "&tau;") == 0) {
    return "$\\tau$";
  }
  if (strcmp(symbol, "&upsilon;") == 0) {
    return "$\\upsilon$";
  }
  if (strcmp(symbol, "&phi;") == 0) {
    return "$\\phi$";
  }
  if (strcmp(symbol, "&chi;") == 0) {
    return "$\\chi$";
  }
  if (strcmp(symbol, "&psi;") == 0) {
    return "$\\psi$";
  }
  if (strcmp(symbol, "&omega;") == 0) {
    return "$\\omega$";
  }


  if (strcmp(symbol, "&Alpha;") == 0) {
    return "$A$";
  }
  if (strcmp(symbol, "&Beta;") == 0) {
    return "$B$";
  }
  if (strcmp(symbol, "&Gamma;") == 0) {
    return "$\\Gamma$";
  }
  if (strcmp(symbol, "&Delta;") == 0) {
    return "$\\Delta$";
  }
  if (strcmp(symbol, "&Epsilon;") == 0) {
    return "$E$";
  }
  if (strcmp(symbol, "&Zeta;") == 0) {
    return "$Z$";
  }
  if (strcmp(symbol, "&Eta;") == 0) {
    return "$H$";
  }
  if (strcmp(symbol, "&Theta;") == 0) {
    return "$\\Theta$";
  }
  if (strcmp(symbol, "&Iota;") == 0) {
    return "$I$";
  }
  if (strcmp(symbol, "&Kappa;") == 0) {
    return "$K$";
  }
  if (strcmp(symbol, "&Lambda;") == 0) {
    return "$\\Lambda$";
  }
  if (strcmp(symbol, "&Mu;") == 0) {
    return "$M$";
  }
  if (strcmp(symbol, "&Nu;") == 0) {
    return "$N$";
  }
  if (strcmp(symbol, "&Xi;") == 0) {
    return "$\\Xi$";
  }
  if (strcmp(symbol, "&Omicron;") == 0) {
    return "$O$";
  }
  if (strcmp(symbol, "&Pi;") == 0) {
    return "$\\Pi$";
  }
  if (strcmp(symbol, "&Rho;") == 0) {
    return "$P$";
  }
  if (strcmp(symbol, "&Sigma;") == 0) {
    return "$\\Sigma$";
  }
  if (strcmp(symbol, "&Tau;") == 0) {
    return "$T$";
  }
  if (strcmp(symbol, "&Upsilon;") == 0) {
    return "$\\Upsilon$";
  }
  if (strcmp(symbol, "&Phi;") == 0) {
    return "$\\Phi$";
  }
  if (strcmp(symbol, "&Chi;") == 0) {
    return "$X$";
  }
  if (strcmp(symbol, "&Psi;") == 0) {
    return "$\\Psi$";
  }
  if (strcmp(symbol, "&Omega;") == 0) {
    return "$\\Omega$";
  }
  return "$SYMBOL$";
}

char *convert_symbol(char *input) {
  char *start_wh = strdup(input);
  char *s = start_wh;
  char *end_wh = strdup(input);
  char *t = end_wh;
  int skip_start = 0;
  int skip_end = 0;
  while(*input == ' ' || *input == '\n' || *input == '\t') {
    *s = *input;
    s++;
    input++;
  }
  if (*s == *start_wh)
    skip_start = 1;
  *s = '\0';

  char *symbol = strdup(input);
  char *c = symbol;
  while(! (*input == ' ' || *input == '\n' || *input == '\t' || *input == '\0')) {
    *c = *input;
    c++;
    input++;
  }
  if (*c == '\0')
    skip_end = 1;
  *c = '\0';
  char *mapping = get_symbol_mapping(symbol);

  while(*input == ' ' || *input == '\n' || *input == '\t') {
    *t = *input;
    t++;
    input++;
  }
  if (*t == *end_wh)
    skip_end = 1;
  *t = '\0';
  char *res = (char *)malloc(strlen(start_wh) + strlen(end_wh) + strlen(mapping) + 1);
  strcpy(res, "");
  if (skip_start == 0)
    strcpy(res, start_wh);
  strcat(res, mapping);
  if (skip_end == 0)
    strcat(res, end_wh);
  //free(start_wh);
  //free(end_wh);
  //free(mapping);
  return res;
}

node *ltraverse(node *n) {
  node *temp;
  if (n == NULL) {
    return NULL;
  }
  //Assuming that n->type is present
  tag ltype = map_l_type(n->type);
  //printf("got ltype: %s\n", get_tag_type(ltype));
  if (ltype == SYMBOL_T) {
    strcpy(n->data, convert_symbol(n->data));
  }
  if (ltype == LIMAGE_T) {
    imageseen = 1;
  }
  if (ltype == HREF_T) {
    anchorseen = 1;
  }
  if (ltype == LTITLE_T) {
    titleseen = 1;
  }
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

void to_file(tree *latex, char *file) {
  //char *s = (char *)malloc(SIZE * sizeof(char));
  fp = fopen(file, "w");
  if (fp == NULL) {
    perror("Unable to open file \n");
    exit(1);
  }
  if (latex == NULL) {
    perror("Null Tree!\n");
    exit(1);
  }
  traverse_to_print(latex->root);
}

void process_before_lchild(node *n) {
  switch(n->type) {
    case SYMBOL_T:
      fprintf(fp, "%s", n->data);
      break;
    case AMPERSAND_T:
      fprintf(fp, "&");
      break;
    case NEWLINE_T:
      fprintf(fp, "\\\\");
      break;
    case CONTENT_T:
      fprintf(fp, "%s", n->data);
      break;
    case LATEX_T:
      fprintf(fp, "\\documentclass{article}\n");
      if (titleseen) {
        fprintf(fp, "\\date{}\n");
      }
      break;
    case PREAMBLE_T:
      if (imageseen) {
        fprintf(fp, "\\usepackage{graphicx}\n");
      }
      if (anchorseen) {
        fprintf(fp, "\\usepackage{hyperref}\n");
      }
      break;
    case DOCUMENT_T:
      fprintf(fp, "\n\\begin{document}");
      if (titleseen) {
        fprintf(fp, "\n\\maketitle");
      }
      break;
    case LTITLE_T:
      fprintf(fp, "\n\\title{");
      break;
    case HREF_T:
      if (n->attributes) {
        fprintf(fp, "\\href{%s}{", n->attributes + 5);
      }
      else {
        fprintf(fp, "\\href{}{");
      }
      break;
    case FONTVAR_T:
      if (n->attributes) {
        fprintf(fp, "{%s ", get_font_mapping(n->attributes + 5));
      }
      else {
        fprintf(fp, "{\\normalsize ");
      }
      break;
    case CENTERING_T:
      printf("==========printing \\begin{center}========\n");
      fprintf(fp, "\n\\begin{center}\n");
      break;
    case PARA_T:
      fprintf(fp, "\n\\par\n");
      break;
    case LH1_T:
      fprintf(fp, "\n\\section*{");
      break;
    case LH2_T:
      fprintf(fp, "\n\\subsection*{");
      break;
    case LH3_T:
      fprintf(fp, "\n\\subsubsection*{");
      break;
    case LH4_T:
      fprintf(fp, "\n\\subsubsection*{");
      break;
    case LUNORDLIST_T:
      fprintf(fp, "\n\\begin{itemize}\n");
      break;
    case LORDLIST_T:
      fprintf(fp, "\n\\begin{enumerate}\n");
      break;
    case LITEM_T:
      fprintf(fp, "\n\\item ");
      break;
    case DESCLIST_T:
      fprintf(fp, "\n\\begin{description}");
      break;
    case DESCTERM_T:
      fprintf(fp, "\n\\item[");
      break;
    case DESCDESC_T:
      break;
    case LDIV_T:
      break;
    case LUNDERLINE_T:
      fprintf(fp, "\\underline{");
      break;
    case LBOLD_T:
      fprintf(fp, "\\textbf{");
      break;
    case LITALIC_T:
      fprintf(fp, "\\textit{");
      break;
    case LEMPHASIS_T:
      fprintf(fp, "\\emph{");
      break;
    case LTELETYPE_T:
      fprintf(fp, "\\texttt{");
      break;
    case LSMALL_T:
      fprintf(fp, "{\\small ");
      break;
    case LSUB_T:
      fprintf(fp, "$_{");
      break;
    case LSUP_T:
      fprintf(fp, "$^{");
      break;
    case LIMAGE_T:
      if (n->attributes) {
        printf("=========================================image attributes: %s================================\n", n->attributes);
        char *s = n->attributes;
        char *next = get_next_attribute(s);
        printf("=============================================next attribute = %s=====================\n", next);
        char *src;
        int width = -1, height = -1;
        while(next != NULL) {
          switch(*next) {
            case 's':
              //next += 4;
              src = next + 4;
              printf("============================src = %s=====================\n", src);
              break;
            case 'w':
              //next += 6;
              width = atoi(next + 6);
              printf("========================width = %d=================\n", width);
              break;
            case 'h':
              //next += 7;
              height = atoi(next + 7);
              printf("========================height = %d=================\n", width);
              break;
            default:
              printf("====================================================default===================================\n");
              break;
          }
          s += strlen(next);
          printf("=====================================s +++ = %s============================\n", s);
          next = get_next_attribute(s);
          printf("=============================================next attribute = %s=====================\n", next);
        }
        if (width != -1 && height != -1) {
          printf("==================================width and height===============================\n");
          fprintf(fp, "\\includegraphics[width=%dmm, height=%dmm]{%s}", width, height, src);
        }
        else if(width != -1) {
          printf("==================================width===============================\n");
          fprintf(fp, "\\includegraphics[width=%dmm]{%s}", width, src);
        }
        else if(height != -1) {
          printf("==================================height===============================\n");
          fprintf(fp, "\\includegraphics[height=%dmm]{%s}", height, src);
        }
        else {
          printf("==================================Plain Image with just src ===============================\n");
          fprintf(fp, "\\includegraphics{%s}", src);
        }
      }
      else {
        printf("No attributes found in image!\n");
      }
      break;
    case LFIGURE_T:
      fprintf(fp, "\n\\begin{figure}");
      break;
    case LFIGCAPTION_T:
      fprintf(fp, "\n\\caption{");
      break;
    case LTABLE_T:
      tablecols = 0;
      fprintf(fp, "\n\\begin{tabular}");
      node *tr = n->lchild;
      if (tr == NULL) {
        perror("Table has no row!\n");
        exit(1);
      }
      node *thortd = tr->lchild;
      if (thortd == NULL) {
        ;
      }
      else {
        tablecols++;
        while(thortd->rsibling) {
          thortd = thortd->rsibling;
          tablecols++;
        }
        fprintf(fp, "{");
        for (int i = 1; i <= tablecols; i++) {
          fprintf(fp, "|c");
        }
        fprintf(fp, "|}\n");
      }
      break;
    case LCAPTION_T:
      fprintf(fp, "\n\\caption{");
      break;
    case LTR_T:
      fprintf(fp, "\n\\hline\n");
      break;
    case LTH_T:
    case LTD_T:
      break;
    default:
      break;
  }
}

void process_after_lchild(node *n) {
  switch(n->type) {
    case SYMBOL_T:
    case AMPERSAND_T:
      break;
    case NEWLINE_T:
    case CONTENT_T:
    case DOC_CLASS_T:
    case PREAMBLE_T:
      break;
    case DOCUMENT_T:
      fprintf(fp, "\n\\end{document}");
      break;
    case LTITLE_T:
    case HREF_T:
    case FONTVAR_T:
      fprintf(fp, "}");
      break;
    case CENTERING_T:
      fprintf(fp, "\n\\end{center}");
      break;
    case PARA_T:
      break;
    case LH1_T:
    case LH2_T:
    case LH3_T:
    case LH4_T:
      fprintf(fp, "}\n");
      break;
    case LUNORDLIST_T:
      fprintf(fp, "\n\\end{itemize}");
      break;
    case LORDLIST_T:
      fprintf(fp, "\n\\end{enumerate}");
      break;
    case LITEM_T:
      break;
    case DESCLIST_T:
      fprintf(fp, "\n\\end{description}");
      break;
    case DESCTERM_T:
      fprintf(fp, "]");
      break;
    case DESCDESC_T:
      break;
    case LDIV_T:
      break;
    case LUNDERLINE_T:
    case LBOLD_T:
    case LITALIC_T:
    case LEMPHASIS_T:
    case LTELETYPE_T:
    case LSMALL_T:
      fprintf(fp, "}");
      break;
    case LSUB_T:
    case LSUP_T:
      fprintf(fp, "}$");
      break;
    case LIMAGE_T:
     break;
    case LFIGURE_T:
      fprintf(fp, "\n\\end{figure}");
      break;
    case LFIGCAPTION_T:
      fprintf(fp, "}");
      break;
    case LTABLE_T:
      fprintf(fp, "\n\\end{tabular}");
      break;
    case LCAPTION_T:
      fprintf(fp, "}");
      break;
    case LTR_T:
      fprintf(fp, "\\\\\n");
      if (n->rsibling == NULL) {
        fprintf(fp, "\\hline");
      }
      break;
    case LTH_T:
    case LTD_T:
      if (n->rsibling) {
        fprintf(fp, "&");
      }
      break;
    default:
      break;
  }
}

void traverse_to_print(node *n) {
  if (n == NULL) {
    return;
  }

  process_before_lchild(n);

  if (n->lchild) {
    traverse_to_print(n->lchild);
  }

  process_after_lchild(n);

  if (n->rsibling) {
    traverse_to_print(n->rsibling);
  }
}

char *get_next_attribute(char *str) {
  char *s = str;
  char *tmp;
  if (*s == '\0') {
    return NULL;
  }
  if (*s == ';') {
    s++;
    str++;
  }
  while(*s != ';' && *s != '\0') {
    s++;
  }
  if (*s == ';') {
    *s = '\0';
    tmp = strdup(str);
    *s = ';';
  }
  else {
    tmp = strdup(str);
  }
  return tmp;
}

int get_semicolon_count(char *s) {
  int count = 0;
  char *semicolon = strchr(s, ';');
  if (semicolon == NULL) {
    count = 1;
  }
  else {
    semicolon++;
    semicolon = strchr(semicolon, ';');
    if (semicolon == NULL) {
      count = 2;
    }
    else {
      count = 3;
    }
  }
  return count;
}

char *get_font_mapping(char *str) {
  int size = atoi(str);
  switch(size) {
    case 1:
      return "\\tiny";
      break;
    case 2:
      return "\\scriptsize";
      break;
    case 3:
      return "\\small";
      break;
    case 4:
      return "\\normalsize";
      break;
    case 5:
      return "\\large";
      break;
    case 6:
      return "\\LARGE";
      break;
    case 7:
      return "\\Huge";
      break;
    default:
      return "\\normalsize";
      break;
  }
}
