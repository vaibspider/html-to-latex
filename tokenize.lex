
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
optional_whitespaces {whitespace}*
alpha [a-zA-Z]
alphas {alpha}+
digit [0-9]
digits {digit}+
special [-{}!@#$%\^&*()+=_';:,./?~`\\|]
hyperlink ({alpha}|{digit}|[/_:.])+
alphanumdot ({alpha}|{digit}|[.])
alphanumspecial ({alpha}|{digit}|{special})

%%

"<!"{d}{o}{c}{t}{y}{p}{e}{whitespaces}{h}{t}{m}{l} {
  if (debug == 1) ECHO;
  yylval.str = strdup(yytext);
  return ODOCTYPE;
}

"<"{h}{t}{m}{l}{optional_whitespaces}">" {
  if (debug == 1) ECHO;
  return OHTML;
}

"</"{h}{t}{m}{l}{optional_whitespaces}">"  {
  if (debug == 1) ECHO;
  return CHTML;
}

"<"{h}{e}{a}{d}{optional_whitespaces}">"		    {
  if (debug == 1) ECHO;
  return OHEAD;
}

"</"{h}{e}{a}{d}{optional_whitespaces}">"		  {
  if (debug == 1) ECHO;
  return CHEAD;
}

"<"{b}{o}{d}{y}{optional_whitespaces}">"		    {
  if (debug == 1) ECHO;
  return OBODY;
}

"</"{b}{o}{d}{y}{optional_whitespaces}">"		  {
  if (debug == 1) ECHO;
  return CBODY;
}

"<"{t}{i}{t}{l}{e}{optional_whitespaces}">"		{
  if (debug == 1) ECHO;
  return OTITLE;
}

"</"{t}{i}{t}{l}{e}{optional_whitespaces}">"		{
  if (debug == 1) ECHO;
  return CTITLE;
}

"<"{a}{optional_whitespaces}">" {
  if (debug == 1) ECHO;
  return JUSTOANCHOR;
}

"<"{a}{optional_whitespaces}{h}{r}{e}{f}{optional_whitespaces}={optional_whitespaces}\" {
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

<hyperlink>\"{optional_whitespaces}">" {
  if (debug == 1) ECHO;
  BEGIN INITIAL;
  return OANCHOR;
}

"</"{a}{optional_whitespaces}">" {
  if (debug == 1) ECHO;
  return CANCHOR;
}

"<"{b}{r}{optional_whitespaces}">"    {
  if (debug == 1) ECHO;
  return LINEBR;
}

"<"{p}{optional_whitespaces}">"			 {
  if (debug == 1) ECHO;
  return OPARA;
}

"</"{p}{optional_whitespaces}">"			 {
  if (debug == 1) ECHO;
  return CPARA;
}

"<"{h}1{optional_whitespaces}">"       {
  if (debug == 1) ECHO;
  return OHEADONE;
}

"</"{h}1{optional_whitespaces}">"       {
  if (debug == 1) ECHO;
  return CHEADONE;
}

"<"{h}2{optional_whitespaces}">"       {
  if (debug == 1) ECHO;
  return OHEADTWO;
}

"</"{h}2{optional_whitespaces}">"       {
  if (debug == 1) ECHO;
  return CHEADTWO;
}

"<"{h}3{optional_whitespaces}">"       {
  if (debug == 1) ECHO;
  return OHEADTHREE;
}

"</"{h}3{optional_whitespaces}">"       {
  if (debug == 1) ECHO;
  return CHEADTHREE;
}

"<"{h}4{optional_whitespaces}">"       {
  if (debug == 1) ECHO;
  return OHEADFOUR;
}

"</"{h}4{optional_whitespaces}">"       {
  if (debug == 1) ECHO;
  return CHEADFOUR;
}

"<"{o}{l}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return OORDERLIST;
}

"</"{o}{l}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return CORDERLIST;
}

"<"{u}{l}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return OUNORDERLIST;
}

"</"{u}{l}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return CUNORDERLIST;
}

"<"{l}{i}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return OLISTITEM;
}

"</"{l}{i}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return CLISTITEM;
}

"<"{d}{l}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return ODESCLIST;
}

"</"{d}{l}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return CDESCLIST;
}

"<"{d}{t}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return ODESCTERM;
}

"</"{d}{t}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return CDESCTERM;
}

"<"{d}{d}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return ODESCDESC;
}

"</"{d}{d}{optional_whitespaces}">"     {
  if (debug == 1) ECHO;
  return CDESCDESC;
}

"<"{d}{i}{v}{optional_whitespaces}">"    {
  if (debug == 1) ECHO;
  return ODIV;
}

"</"{d}{i}{v}{optional_whitespaces}">"    {
  if (debug == 1) ECHO;
  return CDIV;
}

"<"{u}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return OUNDERLINE;
}

"</"{u}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return CUNDERLINE;
}

"<"{b}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return OBOLD;
}

"</"{b}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return CBOLD;
}

"<"{i}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return OITALIC;
}

"</"{i}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return CITALIC;
}

"<"{e}{m}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return OEMPHASIS;
}

"</"{e}{m}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return CEMPHASIS;
}

"<"{s}{t}{r}{o}{n}{g}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return OSTRONG;
}

"</"{s}{t}{r}{o}{n}{g}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return CSTRONG;
}

"<"{s}{m}{a}{l}{l}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return OSMALL;
}

"</"{s}{m}{a}{l}{l}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return CSMALL;
}

"<"{s}{u}{b}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return OSUB;
}

"</"{s}{u}{b}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return CSUB;
}

"<"{s}{u}{p}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return OSUP;
}

"</"{s}{u}{p}{optional_whitespaces}">"      {
  if (debug == 1) ECHO;
  return CSUP;
}

"<"{i}{m}{g}  {
  if (debug == 1) ECHO;
  BEGIN img;
  return OIMG;
}

<img>{s}{r}{c}{optional_whitespaces}={optional_whitespaces}\"  {
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

<imghyperlink>\" {
  if (debug == 1) ECHO;
  BEGIN img;
  return CIMGSRC;
}

<img>{w}{i}{d}{t}{h}{optional_whitespaces}={optional_whitespaces}\" {
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

<widthdigit>\" {
  if (debug == 1) ECHO;
  BEGIN img;
  return CIMGWIDTH;
}

<img>{h}{e}{i}{g}{h}{t}{optional_whitespaces}={optional_whitespaces}\" {
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

<heightdigit>\" {
  if (debug == 1) ECHO;
  BEGIN img;
  return CIMGHEIGHT;
}

<img>">" {
  if (debug == 1) ECHO;
  BEGIN INITIAL;
  return CIMG;
}

"<"{f}{i}{g}{u}{r}{e}{optional_whitespaces}">"   {
  if (debug == 1) ECHO;
  return OFIGURE;
}

"</"{f}{i}{g}{u}{r}{e}{optional_whitespaces}">"   {
  if (debug == 1) ECHO;
  return CFIGURE;
}

"<"{f}{i}{g}{c}{a}{p}{t}{i}{o}{n}{optional_whitespaces}">"   {
  if (debug == 1) ECHO;
  return OFIGCAPTION;
}

"</"{f}{i}{g}{c}{a}{p}{t}{i}{o}{n}{optional_whitespaces}">"   {
  if (debug == 1) ECHO;
  return CFIGCAPTION;
}

"<"{t}{a}{b}{l}{e}{optional_whitespaces}">"    {
  if (debug == 1) ECHO;
  return OTABLE;
}

"</"{t}{a}{b}{l}{e}{optional_whitespaces}">"    {
  if (debug == 1) ECHO;
  return CTABLE;
}

"<"{c}{a}{p}{t}{i}{o}{n}{optional_whitespaces}">"    {
  if (debug == 1) ECHO;
  return OCAPTION;
}

"</"{c}{a}{p}{t}{i}{o}{n}{optional_whitespaces}">"    {
  if (debug == 1) ECHO;
  return CCAPTION;
}

"<"{t}{r}{optional_whitespaces}">"   {
  if (debug == 1) ECHO;
  return OTROW;
}

"</"{t}{r}{optional_whitespaces}">"   {
  if (debug == 1) ECHO;
  return CTROW;
}

"<"{t}{h}{optional_whitespaces}">"   {
  if (debug == 1) ECHO;
  return OTHEAD;
}

"</"{t}{h}{optional_whitespaces}">"   {
  if (debug == 1) ECHO;
  return CTHEAD;
}

"<"{t}{d}{optional_whitespaces}">"   {
  if (debug == 1) ECHO;
  return OTCOL;
}

"</"{t}{d}{optional_whitespaces}">"   {
  if (debug == 1) ECHO;
  return CTCOL;
}

{alphanumspecial}({whitespace}*{alphanumspecial})* {
  if (debug == 1) ECHO;
  yylval.str = strdup(yytext);
  return TEXT;
}

">"	{
  if (debug == 1) ECHO;
  return CANGBRKT;
}

"<!--"(.|\n)*"-->"    {
  if (debug == 1) ECHO;
}

{whitespaces}		{
  if (debug == 1) ECHO;
}

%%

void yyerror(char *s) {
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
