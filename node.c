#include "node.h"
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

node *create_node(tag type) {
  node *new = (node *)malloc(sizeof(node));
  if (new == NULL) {
    perror("Unable to allocate memory!\n");
    exit(1);
  }
  new->type = type;
  new->data = new->attributes = NULL;
  new->parent = new->lchild = new->rsibling = NULL;
  return new;
}
