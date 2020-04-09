%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
void showString();
void showToken(char *);
void showCommentToken();
void showIntToken(char *,int);
void printSeqError();
%}

%option yylineno
%option noyywrap
digit               ([0-9])
letter              ([a-zA-Z])
word                ([0-9a-zA-Z])
newLine             ([\r\n ]| (\r\n))
binInt              (0b([01]+))
exp                 ([eE][-+]{digit}+)
fp                  ([pP][-+]{digit}+)
decReal             ([0-9]*\.((e-[0-9]+)|(E\+[0-9]+)|[0-9]*))
printable           ([\x09\x0A\x0D\x20-\x7E])
printableWoNewLine  ([\x09\x20-\x7E])
printableWoSlash    ([\x09\x0A\x0D\x20-\x2E\x30-\x7E])
printableWoBSlash   ([\x09\x0A\x0D\x20-\x5B\x5D-\x7E])
printableWoAsterisk ([\x09\x0A\x0D\x20-\x29\x2B-\x7E])
printableWou ([\x20-\x74\x76-\x7E])
printableComment    ({printableWoSlash}|[\x2F]+{printableWoAsterisk})
badNestedComment    ((\/\*)([\x09\x0A\x0D\x20-\x2E\x30-\x7E]|[\x2F]+[\x09\x0A\x0D\x20-\x29\x2B-\x7E])*(\/\*))
escapeSeq           ((\\\")|(\\\\)|(\\n)|(\\r)|(\\t))
string              (\"(([\x09]|[\x20-\x21]|[\x23-\x5B]|[\x5D-\x7E])|{escapeSeq}|\\u\{([0-9]|[a-fA-F])+\})*\")
CRLF                (\r\n)
CR                  (\r)
LF                  (\n)
newline             ([{CR}{LF}{CRLF}])
%%

import                                                                showToken("IMPORT");
var                                                                   showToken("VAR");
let                                                                   showToken("LET");
func                                                                  showToken("FUNC");
nil                                                                   showToken("NIL");
while                                                                 showToken("WHILE");
if                                                                    showToken("IF");
else                                                                  showToken("ELSE");
return                                                                showToken("RETURN");
true                                                                  showToken("TRUE");
false                                                                 showToken("FALSE");
\;                                                                    showToken("SC");
\:                                                                    showToken("COLON");
\,                                                                    showToken("COMMA");
\(                                                                    showToken("LPAREN");
\)                                                                    showToken("RPAREN");
\{                                                                    showToken("LBRACE");
\}                                                                    showToken("RBRACE");
\[                                                                    showToken("LBRACKET");
\]                                                                    showToken("RBRACKET");
\=                                                                    showToken("ASSIGN");
"->"                                                                  showToken("ARROW");
Int|UInt|Double|Float|Bool|String|Character                           showToken("TYPE");
==|!=|>=|<=|<|>                                                       showToken("RELOP");
\|\||&&                                                               showToken("LOGOP");
\+|-|\*|\/|%                                                          showToken("BINOP");
{letter}{word}*|\_({digit}|{letter})+                                 showToken("ID");
{binInt}                                                              showIntToken("BIN_INT",2);
0o([0-7]+)                                                            showIntToken("OCT_INT",8);
{digit}+                                                              showIntToken("DEC_INT",10);
0x([0-9a-fA-F]+)+                                                     showIntToken("HEX_INT",16);
{digit}*({digit}+\.|\.{digit}+){digit}*{exp}?                         showToken("DEC_REAL");
0x{word}+(\+|\-){digit}+                                              showToken("HEX_FP");
(\/\*([^*]|{newline}|(\*+([^*\/]|{newline})))*\*+\/)|(\/\/.*)         showCommentToken();
{string}                                                              showString();
\".*\\.+\"                                                            printSeqError();
[\t\n\r ]+                                                            ;
\"                                                                    printf("Error unclosed string\n");exit(0);
\/\*                                                                  printf("Error unclosed comment\n");exit(0);
<<EOF>>                                                               exit(0);
.                                                                     printf("Error %s\n", yytext);exit(0);
%%

bool isPrintable (char curr) {
  return ((0x20 <= curr && curr <= 0x7E) || curr == 0x09 || curr == 0x0A || curr == 0x0D);
}

void showToken(char * token) {
  printf("%d %s %s\n", yylineno, token, yytext);
}

void showIntToken(char * name,int base){
  char *buff=yytext;
  if (base!=10) buff+=2;
  int num = strtol(buff,NULL,base);
  printf("%d %s %d\n",yylineno,name,num);
}

void showCommentToken(){
  int count = 1;
  if (yytext[1] == '*') {
    for(int i=2; i < strlen(yytext)-2; i++) {
      char curr = yytext[i];
      char next = yytext[i+1];
      if (curr==0xA) count++;
      if (curr==0xD) {
        count++;
        if (curr==0xA) i++;
      }
      if (!isPrintable(curr)) {
        printf("Error %c\n", curr);
        exit(0);
      }
      if (yytext[i]=='/' && next=='*') {
        printf("Warning nested comment\n");
        exit(0);
      }
    }
  } else { // Single line comment
      for(int i=2; i < strlen(yytext)-2; i++) {
        if (!isPrintable(yytext[i])) {
          printf("Error %c\n", yytext[i]);
          exit(0);
        }
      }
  }
  printf("%d COMMENT %d\n",yylineno , count);
}

void showString(){
  int countDigits=0;
  char* copyString;
  char manipulatedString[1026]={'\0'};
  int manipulatedStringIndex=0;
  int digitsIterator=0;
  int escapeSeqNumber;
  char escapeBuffer[1024];

  for(int i=1;i<yyleng-1;i++){
    //if(yytext[i]=='\n' || yytext[i]=='\r'){ printf("Error unclosed string\n"); exit(0); }
    //if (!isPrintable(yytext[i])) { printf("Error %c\n", yytext[i]); exit(0); }
    if (yytext[i]=='\\') {
      i++;
      switch(yytext[i]) {
        case 'n': manipulatedString[manipulatedStringIndex]='\n'; break;
        case 'r': manipulatedString[manipulatedStringIndex]='\r'; break;
        case 't': manipulatedString[manipulatedStringIndex]='\t'; break;
        case '\\': manipulatedString[manipulatedStringIndex]='\\'; break;
        case '"': manipulatedString[manipulatedStringIndex]='\"'; break;
        case 'u':// handle /u{num}
          for (digitsIterator=i+2; yytext[digitsIterator] != '}'; digitsIterator++) {


            countDigits++;
            if (countDigits > 6){
                printf("Error undefined escape sequence u\n");
                exit(0);
            }
          }
            countDigits=0;
            char hexNum[1024]={'\0'};
            strncpy(hexNum,yytext+i+2,digitsIterator-i-2);
            escapeSeqNumber=strtol(hexNum, NULL, 16);
            if(escapeSeqNumber>0x7E || escapeSeqNumber<0x20){
              printf("Error undefined escape sequence u\n");
              exit(0);
            }
            manipulatedString[manipulatedStringIndex]=escapeSeqNumber;
            i=digitsIterator;
            break;
      } //end of switch
    } else {
      manipulatedString[manipulatedStringIndex]=yytext[i];
    }
  manipulatedStringIndex++;
}

printf("%d STRING %s\n", yylineno, manipulatedString);
}


void printSeqError(){
  int j=0;
  for(int i=0 ; i < yyleng-1; i++) {
    if(yytext[i]=='\\') {
      i++;
      switch(yytext[i]) {
        case 'n': break;
        case 'r': break;
        case 't': break;
        case '\\': break;
        case '"': break;
        case 'u':
          for(j=i+2;yytext[j]!='}';j++){
            if (yytext[j] < '0' ||
                (yytext[j]>'9'&& yytext[j]<'A') ||
                (yytext[j]>'F' && yytext[j] <'a')||
                (yytext[j] > 'f') ){
              printf("Error undefined escape sequence u\n");
              exit(0);
            }
          }
          char hex_num[1024]={'\0'};
          strncpy(hex_num,yytext+i+2,j-i-2);
          int num = strtol(hex_num,NULL,16);
          if(num > 0x7E || num < 0x20){
              printf("Error undefined escape sequence u\n");
              exit(0);
          }
          i=j;
          break;

        default: printf("Error undefined escape sequence %c\n",yytext[i]); exit(0);
      }
    }
  }
}