#include "stack.h"
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

stack *init_stack() {
  stack *s = (stack *)malloc(sizeof(stack));
  if (s == NULL) {
    perror("Unable to allocate memory!\n");
    exit(1);
  }
  s->l = init_list();
  return s;
}

void push(stack *s, node *n) {
  if (s == NULL) {
    perror("Null stack!\n");
    exit(1);
  }
  list_append(s->l, n);
}

node *pop(stack *s) {
  if (s == NULL) {
    perror("Null stack!\n");
    exit(1);
  }
  return list_delete(s->l);
}

int is_empty(stack *s) {
  if (s == NULL || s->l == NULL) {
    perror("Null stack!\n");
    exit(1);
  }
  if (s->l->head == NULL || s->l->tail == NULL) {
    return 1;
  }
  return 0;
}

int is_full(stack *s) {
  return 0;
}

void print_stack(stack *s) {
  if (s == NULL) {
    perror("Null stack!\n");
    exit(1);
  }
  print_list(s->l);
}

/*
int main() {
  stack *s = init_stack();
  printf("stack init\n");
  node *n = create_node(HTML_T);
  printf("create node\n");
  printf("is_empty = %d\n", is_empty(s));
  printf("is_full = %d\n", is_full(s));
  push(s, n);
  printf("push\n");
  print_stack(s);
  printf("before pop\n");
  pop(s);
  printf("pop\n");
  n = create_node(HEAD_T);
  push(s, n);
  print_stack(s);
  n = create_node(BODY_T);
  push(s, n);
  n = create_node(TITLE_T);
  push(s, n);
  n = create_node(ANCHOR_T);
  push(s, n);
  print_stack(s);
  pop(s);
  print_stack(s);
  printf("is_empty = %d\n", is_empty(s));
  printf("is_full = %d\n", is_full(s));
  return 0;
}
*/
