%{
#include <stdio.h>
void showToken(char *);

/* TODO
Comments
String
Errors
Printing
*/
%}

%option yylineno
%option noyywrap
digit               ([0-9])
letter              ([a-zA-Z])
word                ([0-9a-zA-Z])
idStart             ([_a-zA-Z])
whitespace          ([\t\n ])
types               (Int|UInt|Double|Float|Bool|String|Character)
relop               (==|!=|>=|<=|<|>)
logop               (\|\||&&)
binop               (\+|-|\*|\/|%)
binInt              (0b([01]+))
octInt              (0o([07]+))
hexInt              (0x([0-9a-fA-F]+))
decReal             ([0-9]*\.((e-[0-9]+)|(E\+[0-9]+)|[0-9]*))
hexFp               (0x[a-zA-Z0-9]+(\+|\-)[0-9]+)
string               ((\/\*[ \n\r\t]*\*\/)|(\/\/[ a-zA-Z]*))
%%

"import"                      showToken("IMPORT");
"var"                         showToken("VAR");
"func"                        showToken("FUNC");
"nil"                        showToken("NIL");
"while"                        showToken("WHILE");
"if"                        showToken("IF");
"else"                        showToken("ELSE");
"return"                        showToken("RETURN");
true                        showToken("true");
false                        showToken("false");
";"                        showToken("SC");
":"                        showToken("COLON");
","                        showToken("COMMA");
"("                        showToken("LPAREN");
")"                        showToken("RPAREN");
"{"                        showToken("LBRACE");
"}"                        showToken("RBRACE");
"["                        showToken("LBRACKET");
"]"                        showToken("RBRACKET");
"="                        showToken("ASSIGN");
"->"                        showToken("ARROW");
{types}                        showToken("TYPE");
{relop}                        showToken("RELOP");
{logop}                        showToken("LOGOP");
{binop}                        showToken("BINOP");
{idStart}{word}*              showToken("ID");
{binInt}                    showToken("BIN_INT");
{octInt}                    showToken("OCT_INT");
{digit}+                    showToken("DEC_INT");
{hexInt}+                    showToken("HEX_INT");
{decReal}                     showToken("DEC_REAL");
{hexFp}                     showToken("HEX_FP");
{string}                     showToken("STRING");



{whitespace}                  ;
.                             showToken("Dont Know");

%%


void showToken(char * token) {
  printf("%d %s %s\n", yylineno, token, yytext);
}
