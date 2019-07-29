
all: tokenize

tokenize: lex.yy.c
	gcc lex.yy.c -lfl -Wall -o tokenize

lex.yy.c: tokenize.lex
	flex tokenize.lex


