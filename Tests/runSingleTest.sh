#!/bin/bash

workspace=$(pwd)
parserFolder=${workspace}/LexicalParser

lex ${parserFolder}/hw1.lex
gcc -ll ${workspace}/lex.yy.c

app=./a.out


testFolder=${workspace}/Tests
inFolder=${testFolder}/in
outFolder=${testFolder}/out
resultFolder=${testFolder}/expected

inExt=\.in
outExt=\.out
resExt=\.res

${app}