
all: parser

parser: lex.yy.c parse.tab.c
	gcc lex.yy.c parse.tab.c -lfl -Wall -o parser

lex.yy.c: tokenize.lex
	flex tokenize.lex

parse.tab.c: parse.y
	bison --debug -d -v -t parse.y


