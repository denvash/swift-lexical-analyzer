#!/bin/bash

lex hw1.lex
gcc -ll lex.yy.c
./a.out < ../Tests/in/t0.in > ../Tests/res/t0.res