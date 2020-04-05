%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void showComment(int commentType);
void showString();
void showToken(char *);
void errorPrint();
void errorPrintUndefinedSeq();
void warningPrintNestedComment();
%}

%option yylineno
%option noyywrap
commentStartMultiLine ("/*")
commentStartSingleLine ("//")
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
printableWoBSlash   ([\x09\x0A\x0D\x20-\x5B\x5D-\x7E])
printableWoAsterisk ([\x09\x0A\x0D\x20-\x29\x2B-\x7E])
printableComment    ({printableWoSlash}|[\x2F]+{printableWoAsterisk})
commentTypeA        ("/*"([\x09\x0A\x0D\x20-\x2E\x30-\x7E]|[\x2F]+[\x09\x0A\x0D\x20-\x29\x2B-\x7E])*"*/")
commentTypeB        ("//"[\x09\x20-\x7E]*[\r\n ])
badNestedComment    ((\/\*)([\x09\x0A\x0D\x20-\x2E\x30-\x7E]|[\x2F]+[\x09\x0A\x0D\x20-\x29\x2B-\x7E])*(\/\*))
comment             ( {commentTypeA} | {commentTypeB})
string              (\"([\x09\x20-\x21\x23-\x5B\x5D-\x7E]|\\[\x5C\x22nrt]|\\u\{[2-7][0-9a-fA-F]\})*\")
undefinedEscapeSeq  (\\.)

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
{string}                     showString();
{whitespace}                  ;
{undefinedEscapeSeq}          errorPrintUndefinedSeq();
.                             errorPrint();
%%

void warningPrintNestedComment() {
  // printf("debug: %s", yytext);
  printf("Warning nested comment\n");
  exit(0);
}

void errorPrint() {
  char* curr = yytext;
  printf("Error %s\n", curr);
  exit(0);
}

void errorPrintUndefinedSeq() {
  char* curr = yytext;

  printf("Error undefined escape sequence %c\n", curr[1]);
  exit(0);
}

void showComment(int commentType){
int numberOfNewLines=0;
char* curr=yytext;

while (*curr != '\0'){
    if(*curr=='\r'){
        if(*(curr+1)=='\n'){
           numberOfNewLines++;
           curr+=2;
        }else{
        numberOfNewLines++;
        curr++;
        }
    }

   else if(*curr=='\n'){
            numberOfNewLines++;
            curr++;
    }else{
    curr++;
    }

}

printf("%d %s %d\n", yylineno, "COMMENT", numberOfNewLines+1-commentType);
}

void showString(){
char* copyString;
char manipulatedString[1024];
char* manipulatedStringIndex=manipulatedString;
strcpy ( copyString, yytext);
copyString++;
char* currChar=copyString;
long escapeSeqNumber;
char escapeBuffer[1024];

while(*(currChar + 1)!='\0'){
    if(*currChar=='\\'){
    switch(*(currChar + 1)){
        case 'n':
            *manipulatedStringIndex='\n';
            manipulatedStringIndex++;
            currChar+=2;
            break;
        case 'r':
            *manipulatedStringIndex='\r';
            manipulatedStringIndex++;
            currChar+=2;
            break;
        case 't':
            *manipulatedStringIndex='\t';
            manipulatedStringIndex++;
            currChar+=2;
            break;
        case '\\':
            *manipulatedStringIndex='\\';
            manipulatedStringIndex++;
            currChar+=2;
            break;
        case '"':
            *manipulatedStringIndex='"';
            manipulatedStringIndex++;
            currChar+=2;
            break;
        default:
            currChar+=3;
            escapeSeqNumber=strtol(currChar, &currChar, 16);
            printf("strtol:%ld\n",escapeSeqNumber );
            sprintf(escapeBuffer, "%ld", escapeSeqNumber);
            strcat(manipulatedStringIndex,"\\u");
            strcat(manipulatedStringIndex,escapeBuffer);
            currChar++;
            manipulatedStringIndex+=2+strlen(escapeBuffer);

    }
    }else{
    *manipulatedStringIndex=*currChar;
    currChar++;
    manipulatedStringIndex++;
    }
}
*manipulatedStringIndex='\0';


printf("%d %s %s\n", yylineno, "STRING", manipulatedString);

}

void showToken(char * token) {
    printf("%d %s %s\n", yylineno, token, yytext);
}
