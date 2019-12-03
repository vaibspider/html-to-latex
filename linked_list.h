#ifndef _LIST_H
#define _LIST_H
#include "node.h"

typedef struct linked_list {
  node *head;
  node *tail;
} list;

list *init_list();
node *list_search(list *, tag);
list *list_append(list *, node *);
node *list_delete(list *); /* delete from right end */
void print_list(list *);

#endif
