#ifndef _TREE_H
#define _TREE_H
#include "node.h"

typedef struct tree {
  node *root;
} tree;

node *new_node(char *data, tag type);
tree *init_tree();
tree *add_node(tree *t, node *n, node *parent); /* Add node n as the rightmost child of parent p */
tree *add_root(tree *t, node *n);
node *find_node(tree *t, tag type);
void print_tree(tree *t);
void add_a_kid(node *, tag parent_type);
void init_kids(tag type);
void take_kids(tag type, node *);
void print(node *n);

#endif
