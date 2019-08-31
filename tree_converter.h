#ifndef _CONVERT_H
#define _CONVERT_H
#include "lrtree.h"

tree *convert(tree *);
node *ltraverse(node *);
node *convert_node(node *, tag);
tag map_l_type(tag);

#endif
