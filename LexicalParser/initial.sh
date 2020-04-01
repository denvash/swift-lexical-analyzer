#!/bin/bash

lex hw1.lex
gcc -ll lex.yy.c
./a.out < ../Tests/in/errorPrintSeq1.in > ../Tests/res/errorPrintSeq1.res