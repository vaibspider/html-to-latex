
%{
  #include "parse.tab.h"
  #include <string.h>
  #include <stdio.h>
  int debug = 0;
%}

%start beforehyperlink
%start hyperlink 
%start img
%start imghyperlink
%start imgsrc
%start imgheight
%start imgwidth
%start widthdigit
%start heightdigit
%start in_comment
%start fontsize
%start beforesize

a [aA]
b [bB]
c [cC]
d [dD]
e [eE]
f [fF]
g [gG]
h [hH]
i [iI]
j [jJ]
k [kK]
l [lL]
m [mM]
n [nN]
o [oO]
p [pP]
q [qQ]
r [rR]
s [sS]
t [tT]
u [uU]
v [vV]
w [wW]
x [xX]
y [yY]
z [zZ]
space [ ]
spaces {space}+
tab   \t
tabs   {tab}+
newline \n
newlines {newline}+
whitespace [ \t\n]
whitespaces {whitespace}+
alpha [a-zA-Z]
alphas {alpha}+
digit [0-9]
digits {digit}+
special [-\[\]"{}!@#$%\^&*()+=_';:,./?~`\\|]
hyperlink ({alpha}|{digit}|[-%&+=@#/_:.])+

alphanumdot ({alpha}|{digit}|[.])
alphanumspecial ({alpha}|{digit}|{special})

%%

<INITIAL>{
  "<!--" {BEGIN in_comment;
  /*printf("comment started.......\n");*/}
}

<in_comment>{
  "-->" {BEGIN INITIAL; /*printf("comment ended........\n");*/ }
  [^-\n]+ {/*printf("comment::%s::comment\n", yytext);*/}
  [-]+ {/*printf("comment::%s::comment\n", yytext);*/}
  \n  ;
}

"<!"{d}{o}{c}{t}{y}{p}{e}{whitespaces}{h}{t}{m}{l} {
  if (debug == 1) ECHO;
  yylval.str = strdup(yytext);
  return ODOCTYPE;
}

"<"{h}{t}{m}{l}{whitespace}*">" {
  if (debug == 1) ECHO;
  return OHTML;
}

"</"{h}{t}{m}{l}{whitespace}*">"  {
  if (debug == 1) ECHO;
  return CHTML;
}

"<"{h}{e}{a}{d}{whitespace}*">"		    {
  if (debug == 1) ECHO;
  return OHEAD;
}

"</"{h}{e}{a}{d}{whitespace}*">"		  {
  if (debug == 1) ECHO;
  return CHEAD;
}

"<"{b}{o}{d}{y}{whitespace}*">"		    {
  if (debug == 1) ECHO;
  return OBODY;
}

"</"{b}{o}{d}{y}{whitespace}*">"		  {
  if (debug == 1) ECHO;
  return CBODY;
}

"<"{t}{i}{t}{l}{e}{whitespace}*">"		{
  if (debug == 1) ECHO;
  return OTITLE;
}

"</"{t}{i}{t}{l}{e}{whitespace}*">"		{
  if (debug == 1) ECHO;
  return CTITLE;
}

"<"{a}{whitespace}*">" {
  if (debug == 1) ECHO;
  return JUSTOANCHOR;
}

"<"{a}{whitespace}*{h}{r}{e}{f}{whitespace}*={whitespace}*["'] {
  if (debug == 1) ECHO;
  BEGIN beforehyperlink;
  return BEFOREHYPERLINK;
}

<beforehyperlink>{hyperlink} {
  if (debug == 1) ECHO;
  BEGIN hyperlink;
  yylval.str = strdup(yytext);
  return HYPERLINK;
}

<hyperlink>["']{whitespace}*">" {
  if (debug == 1) ECHO;
  BEGIN INITIAL;
  return OANCHOR;
}

"</"{a}{whitespace}*">" {
  if (debug == 1) ECHO;
  return CANCHOR;
}

"<"{b}{r}{whitespace}*\/?">"    {
  if (debug == 1) ECHO;
  return LINEBR;
}

"<"{p}{whitespace}*">"			 {
  if (debug == 1) ECHO;
  return OPARA;
}

"</"{p}{whitespace}*">"			 {
  if (debug == 1) ECHO;
  return CPARA;
}

"<"{h}1{whitespace}*">"       {
  if (debug == 1) ECHO;
  return OHEADONE;
}

"</"{h}1{whitespace}*">"       {
  if (debug == 1) ECHO;
  return CHEADONE;
}

"<"{h}2{whitespace}*">"       {
  if (debug == 1) ECHO;
  return OHEADTWO;
}

"</"{h}2{whitespace}*">"       {
  if (debug == 1) ECHO;
  return CHEADTWO;
}

"<"{h}3{whitespace}*">"       {
  if (debug == 1) ECHO;
  return OHEADTHREE;
}

"</"{h}3{whitespace}*">"       {
  if (debug == 1) ECHO;
  return CHEADTHREE;
}

"<"{h}4{whitespace}*">"       {
  if (debug == 1) ECHO;
  return OHEADFOUR;
}

"</"{h}4{whitespace}*">"       {
  if (debug == 1) ECHO;
  return CHEADFOUR;
}

"<"{o}{l}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return OORDERLIST;
}

"</"{o}{l}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return CORDERLIST;
}

"<"{u}{l}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return OUNORDERLIST;
}

"</"{u}{l}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return CUNORDERLIST;
}

"<"{l}{i}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return OLISTITEM;
}

"</"{l}{i}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return CLISTITEM;
}

"<"{d}{l}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return ODESCLIST;
}

"</"{d}{l}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return CDESCLIST;
}

"<"{d}{t}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return ODESCTERM;
}

"</"{d}{t}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return CDESCTERM;
}

"<"{d}{d}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return ODESCDESC;
}

"</"{d}{d}{whitespace}*">"     {
  if (debug == 1) ECHO;
  return CDESCDESC;
}

"<"{d}{i}{v}{whitespace}*">"    {
  if (debug == 1) ECHO;
  return ODIV;
}

"</"{d}{i}{v}{whitespace}*">"    {
  if (debug == 1) ECHO;
  return CDIV;
}

"<"{u}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return OUNDERLINE;
}

"</"{u}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return CUNDERLINE;
}

"<"{b}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return OBOLD;
}

"</"{b}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return CBOLD;
}

"<"{i}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return OITALIC;
}

"</"{i}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return CITALIC;
}

"<"{e}{m}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return OEMPHASIS;
}

"</"{e}{m}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return CEMPHASIS;
}

"<"{s}{t}{r}{o}{n}{g}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return OSTRONG;
}

"</"{s}{t}{r}{o}{n}{g}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return CSTRONG;
}

"<"{s}{m}{a}{l}{l}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return OSMALL;
}

"</"{s}{m}{a}{l}{l}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return CSMALL;
}

"<"{s}{u}{b}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return OSUB;
}

"</"{s}{u}{b}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return CSUB;
}

"<"{s}{u}{p}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return OSUP;
}

"</"{s}{u}{p}{whitespace}*">"      {
  if (debug == 1) ECHO;
  return CSUP;
}

"<"{i}{m}{g}  {
  if (debug == 1) ECHO;
  BEGIN img;
  return OIMG;
}

<img>{s}{r}{c}{whitespace}*={whitespace}*["']  {
  if (debug == 1) ECHO;
  BEGIN imgsrc;
  return OIMGSRC;
}

<imgsrc>{hyperlink} {
  if (debug == 1) ECHO;
  BEGIN imghyperlink;
  yylval.str = strdup(yytext);
  return HYPERLINK;
}

<imghyperlink>["'] {
  if (debug == 1) ECHO;
  BEGIN img;
  return CIMGSRC;
}

<img>{w}{i}{d}{t}{h}{whitespace}*={whitespace}*["'] {
  if (debug == 1) ECHO;
  BEGIN imgwidth;
  return OIMGWIDTH;
}

<imgwidth>{digits} {
  if (debug == 1) ECHO;
  BEGIN widthdigit;
  yylval.str = strdup(yytext);
  return WIDTH;
}

<widthdigit>["'] {
  if (debug == 1) ECHO;
  BEGIN img;
  return CIMGWIDTH;
}

<img>{h}{e}{i}{g}{h}{t}{whitespace}*={whitespace}*["'] {
  if (debug == 1) ECHO;
  BEGIN imgheight;
  return OIMGHEIGHT;
}

<imgheight>{digits} {
  if (debug == 1) ECHO;
  BEGIN heightdigit;
  yylval.str = strdup(yytext);
  return HEIGHT;
}

<heightdigit>["'] {
  if (debug == 1) ECHO;
  BEGIN img;
  return CIMGHEIGHT;
}

<img>\/?">" {
  if (debug == 1) ECHO;
  BEGIN INITIAL;
  return CIMG;
}

"<"{f}{i}{g}{u}{r}{e}{whitespace}*">"   {
  if (debug == 1) ECHO;
  return OFIGURE;
}

"</"{f}{i}{g}{u}{r}{e}{whitespace}*">"   {
  if (debug == 1) ECHO;
  return CFIGURE;
}

"<"{f}{i}{g}{c}{a}{p}{t}{i}{o}{n}{whitespace}*">"   {
  if (debug == 1) ECHO;
  return OFIGCAPTION;
}

"</"{f}{i}{g}{c}{a}{p}{t}{i}{o}{n}{whitespace}*">"   {
  if (debug == 1) ECHO;
  return CFIGCAPTION;
}

"<"{t}{a}{b}{l}{e}{whitespace}*">"    {
  if (debug == 1) ECHO;
  return OTABLE;
}

"</"{t}{a}{b}{l}{e}{whitespace}*">"    {
  if (debug == 1) ECHO;
  return CTABLE;
}

"<"{c}{a}{p}{t}{i}{o}{n}{whitespace}*">"    {
  if (debug == 1) ECHO;
  return OCAPTION;
}

"</"{c}{a}{p}{t}{i}{o}{n}{whitespace}*">"    {
  if (debug == 1) ECHO;
  return CCAPTION;
}

"<"{t}{r}{whitespace}*">"   {
  if (debug == 1) ECHO;
  return OTROW;
}

"</"{t}{r}{whitespace}*">"   {
  if (debug == 1) ECHO;
  return CTROW;
}

"<"{t}{h}{whitespace}*">"   {
  if (debug == 1) ECHO;
  return OTHEAD;
}

"</"{t}{h}{whitespace}*">"   {
  if (debug == 1) ECHO;
  return CTHEAD;
}

"<"{t}{d}{whitespace}*">"   {
  if (debug == 1) ECHO;
  return OTCOL;
}

"</"{t}{d}{whitespace}*">"   {
  if (debug == 1) ECHO;
  return CTCOL;
}

"<"{f}{o}{n}{t}{whitespace}+{s}{i}{z}{e}{whitespace}*={whitespace}*["'] {
  BEGIN beforesize;
  return BEFORESIZE;
}

<beforesize>{digits} {
  BEGIN fontsize;
  yylval.str = strdup(yytext);
  return FONTSIZE;
}

<fontsize>["']{whitespace}*">" {
  BEGIN INITIAL;
  return OFONT;
}

"</"{f}{o}{n}{t}{whitespace}*">" {
  return CFONT;
}

"<"{c}{e}{n}{t}{e}{r}{whitespace}*">" {
  return OCENTER;
}

"</"{c}{e}{n}{t}{e}{r}{whitespace}*">" {
  return CCENTER;
}

"<"{t}{t}{whitespace}*">" {
  return OTELETYPE;
}

"</"{t}{t}{whitespace}*">" {
  return CTELETYPE;
}

<INITIAL>{whitespace}*{alphanumspecial}({whitespace}*{alphanumspecial})*{whitespace}* {
  if (debug == 1) ECHO;
  yylval.str = strdup(yytext);
  /*printf("TEXT::%s::TEXT\n", yytext);*/
  return TEXT;
}

">"	{
  if (debug == 1) ECHO;
  return CANGBRKT;
}

{whitespaces}		{
  if (debug == 1) ECHO;
}

%%

void yyerror(const char *s) {
  fprintf(stderr, "%s\n", s);
}

int yywrap(void) {
  return 1;
}

/*int main() {
  while(1)
    yylex();
	return 0;
}*/
