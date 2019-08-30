#include "linked_list.h"
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

extern node *create_node(tag type);

list *init_list() {
  list *l = (list *)malloc(sizeof(list));
  if (l == NULL) {
    perror("Unable to allocate memory!\n");
    exit(1);
  }
  l->head = l->tail = NULL;
  return l;
}

node *list_search(list *l, tag type) {
  if (l == NULL) {
    printf("Null List!\n");
    return NULL;
  }
  node *n = l->head;
  while(n) {
    if (n->type == type) {
      return n;
    }
    n = n->rsibling;
  }
  return NULL;
}

list *list_append(list *l, node *n) {
  if (l == NULL) {
    printf("Null List!\n");
    return NULL;
  }
  if (l->head == NULL || l->tail == NULL) {
    l->head = l->tail = n;
  }
  else {
    l->tail->rsibling = n;
    l->tail = n;
  }
  return l;
}

node *list_delete(list *l) { /* delete from end */
  node *n;
  if (l == NULL) {
    printf("Null List!\n");
    return NULL;
  }
  if (l->head == NULL || l->tail == NULL) {
    printf("Cannot delete! Already empty list!\n");
    return NULL;
  }
  n = l->head;
  if (l->head == l->tail) {
    l->head = l->tail = NULL;
    return n;
  }
  while(n->rsibling != l->tail) {
    n = n->rsibling;
  }
  l->tail = n;
  n = n->rsibling;
  l->tail->rsibling = NULL;
  return n;
}

void print_list(list *l) {
  node *n;
  if (l == NULL) {
    printf("NULL\n");
    return;
  }
  if (l->head == NULL || l->tail == NULL) {
    printf("[]\n");
    return;
  }
  n = l->head;
  while(n) {
    printf("[%d] ", n->type);
    n = n->rsibling;
  }
  printf("\n");
}

/*
int main() {
  list *l = init_list();
  node *n = create_node(HTML_T);
  list_append(l, n);
  print_list(l);
  list_delete(l);
  n = create_node(HEAD_T);
  list_append(l, n);
  print_list(l);
  n = list_search(l, HEAD_T);
  printf("HEAD_T found: %d\n", n->type);
  n = create_node(BODY_T);
  list_append(l, n);
  n = create_node(TITLE_T);
  list_append(l, n);
  n = create_node(ANCHOR_T);
  list_append(l, n);
  print_list(l);
  n = list_search(l, BODY_T);
  printf("BODY_T found: %d\n", n->type);
  list_delete(l);
  print_list(l);
  n = list_search(l, TITLE_T);
  printf("TITLE_T found: %d\n", n->type);
  return 0;
}
*/
