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
resultFolder=${testFolder}/expected

inExt=\.in
outExt=\.out
resExt=\.res

totalTests=`ls -1q ${inFolder} | wc -l`

for filePath in ${inFolder}/*.in; do
#    dos2unix ${filePath}

# get the file name without extension
    fileName=`basename ${filePath} | cut -d . -f 1`

# Debug
    # echo ${filePath}
    echo Runing Test ${fileName}
    ${app} < ${filePath} > ${outFolder}/${fileName}${outExt}
done

# for filePath in ${expectedFolder}/*.out; do
# #    dos2unix ${filePath}

#     fileName=`echo ${filePath} | cut -d / -f 11 | cut -d . -f 1`

#     result=`diff ${filePath} ${outFolder}/${fileName}${outExt}`
#     if [[ "${result}" != "" ]]; then
#         echo ${result}
#         echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Test ${fileName} FAILED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#     fi
# done