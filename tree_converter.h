#ifndef _CONVERT_H
#define _CONVERT_H
#include "lrtree.h"

tree *convert(tree *);
node *ltraverse(node *);
node *convert_node(node *, tag);
tag map_l_type(tag);
void to_file(tree *, char *);
char *get_font_mapping(char *);
char *get_next_attribute(char *);
void traverse_to_print(node *);
#endif
