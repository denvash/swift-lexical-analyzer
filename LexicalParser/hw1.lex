%{
/* Declarations section */
#include <stdio.h>
void showToken(char *);
%}

%option yylineno
%option noyywrap
import              ("import")
digit               ([0-9])
letter              ([a-zA-Z])
whitespace          ([\t\n ])

%%

{import}                    showToken("import");
{digit}+                    showToken("number");
{letter}+                   showToken("letter");
{letter}+@{letter}+\.com    showToken("email");
{whitespace}                ;
.                           printf("Lex doesn't know what that is!\n");

%%

void showToken(char* name) {
	printf("token %s",name);
	printf("lexeme %s",yytext);
	printf("length %d\n",yyleng);
}