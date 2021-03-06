# Slim - Swift Lexical Analyzer

## Usage

```shell
lex swift-lexical-analyzer.lex

# Outputs lex.yy.c file
gcc -ll lex.yy.c

# Outputs a.out file
./a.out < input.in > output.out
```

## Example

Input any swift program to be analyzed:

```swift
import UIKit
/* Start of
Lottery Program */
func generateNumber(mod : Int) -> Int {
    return Int(arc4random()) % mod
}

var x = 0xFf
var counter = Int(+1.0e+2-0o144+0x64p+0-100)
while (counter < x) {
    print(generateNumber(mod: 0b1001101))
    counter = counter + 1
}
/* End of /* Lottery */ Program */
```

Output:

```console
1 IMPORT import
1 ID UIKit
3 COMMENT 2
4 FUNC func
4 ID generateNumber
4 LPAREN (
4 ID mod
4 COLON :
4 TYPE Int
4 RPAREN )
4 ARROW ->
4 TYPE Int
4 LBRACE {
5 RETURN return
5 TYPE Int
5 LPAREN (
5 ID arc4random
5 LPAREN (
5 RPAREN )
5 RPAREN )
5 BINOP %
5 ID mod
6 RBRACE }
8 VAR var
8 ID x
8 ASSIGN =
8 HEX_INT 255
9 VAR var
9 ID counter
9 ASSIGN =
9 TYPE Int
9 LPAREN (
9 BINOP +
9 DEC_REAL 1.0e+2
9 BINOP -
9 OCT_INT 100
9 BINOP +
9 HEX_FP 0x64p+0
9 BINOP -
9 DEC_INT 100
9 RPAREN )
10 WHILE while
10 LPAREN (
10 ID counter
10 RELOP <
10 ID x
10 RPAREN )
10 LBRACE {
11 ID print
11 LPAREN (
11 ID generateNumber
11 LPAREN (
11 ID mod
11 COLON :
11 BIN_INT 77
11 RPAREN )
11 RPAREN )
12 ID counter
12 ASSIGN =
12 ID counter
12 BINOP +
12 DEC_INT 1
13 RBRACE }
Warning nested comment
```
