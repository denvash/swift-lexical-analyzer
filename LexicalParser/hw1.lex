%{
#include <stdio.h>
void showComment(int commentType);
printf("%d %s %s\n", yylineno, token, yytext);
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
newLine             ([\r\n ]| (\r\n))
whitespace          ([\t\n\r ])
types               (Int|UInt|Double|Float|Bool|String|Character)
relop               (==|!=|>=|<=|<|>)
logop               (\|\||&&)
binop               (\+|-|\*|\/|%)
binInt              (0b([01]+))
octInt              (0o([07]+))
hexInt              (0x([0-9a-fA-F]+))
decReal             ([0-9]*\.((e-[0-9]+)|(E\+[0-9]+)|[0-9]*))
hexFp               (0x[a-zA-Z0-9]+(\+|\-)[0-9]+)
printable           ([\x09\x0A\x0D\x20-\x7E])
printableWoNewLine  ([\x09\x20-\x7E])
printableWoSlash    ([\x09\x0A\x0D\x20-\x2E\x30-\x7E])
printableWoAsterisk ([\x09\x0A\x0D\x20-\x29\x2B-\x7E])
commentTypeA        ("/*"({printableWoSlash} | [\x2F]+{printableWoAsterisk})*"*/")
commentTypeB        ("//"{printableWoNewLine}* {newLine})
comment             ( {commentTypeA} | {commentTypeB})
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
{commentTypeA}                     showComment(0);
{commentTypeB}                     showComment(1);
{string}                     showToken("STRING");
{whitespace}                  ;
.                             showToken("Dont Know");
%%


void showComment(int commentType){
int numberOfNewLines=0;
char* curr=yytext[0];

while (*curr != '\0'){
    if(*curr=='\r'){
        if(*(curr+1)=='\n'){
           numberOfNewLines++;
           curr+=2;
        }else{
        numberOfnewLines++;
        curr++;
        }
    }

   else if(*curr=='\n'){
            numberOfnewLines++;
            curr++;
    }else{
    curr++;
    }

}

printf("%d %s %d\n", yylineno, "COMMENT", numberOfNewLines+1-commentType);
}

void showToken(char * token) {
    printf("%d %s %s\n", yylineno, token, yytext);
}


