#!/bin/bash

workspace=$(pwd)
parserFolder=${workspace}/LexicalParser

lex ${parserFolder}/hw1.lex
gcc -ll ${workspace}/lex.yy.c

app=./a.out

# ./a.out < ../Tests/in/*.in > ../Tests/res/*.res


testFolder=${workspace}/Tests
inFolder=${testFolder}/in
outFolder=${testFolder}/out
resultFolder=${testFolder}/res

inExt=\.in
outExt=\.out

totalTests=`ls -1q ${inFolder} | wc -l`

# Test Run
for filePath in ${inFolder}/*.in; do
#    dos2unix ${filePath}

# get the file name without extension
    fileName=`basename ${filePath} | cut -d . -f 1`

# echo ${filePath}
    echo Runing Test ${fileName}
    ${app} < ${filePath} > ${outFolder}/${fileName}${outExt}
done

# Diff
for filePath in ${outFolder}/*.out; do
#    dos2unix ${filePath}

# get the file name without extension
    fileName=`basename ${filePath} | cut -d . -f 1`

    result=`diff ${filePath} ${resultFolder}/${fileName}${outExt}`
    if [[ "${result}" != "" ]]; then
        echo ${result}
        echo "~~ Test ${fileName} FAILED"
    fi
done