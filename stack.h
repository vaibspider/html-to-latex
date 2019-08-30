#ifndef _STACK_H
#define _STACK_H
#include "node.h"
#include "linked_list.h"

typedef struct stack {
  list *l;
} stack;

stack *init_stack();
void push(stack *, node *);
node *pop(stack *);
int is_empty(stack *);
int is_full(stack *);
node *top(stack *);
void print_stack(stack *s);

#endif
