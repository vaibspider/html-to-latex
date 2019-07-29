
all: tokenize

tokenize: lex.yy.c parse.tab.c
	gcc lex.yy.c parse.tab.c -lfl -Wall -o tokenize

lex.yy.c: tokenize.lex
	flex tokenize.lex

parse.tab.c: parse.y
	bison -d parse.y


