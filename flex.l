%{
#include <iostream>
using namespace std;

#define TOKEN_ID   1
#define TOKEN_INT  2
#define TOKEN_PLUS 3
#define TOKEN_MIN  4
#define TOKEN_MUL  5
#define TOKEN_DIV  6
%}

/* Definitions */
ID   [a-zA-Z_][a-zA-Z0-9_]*
INT  [0-9]+

%%

"+"      { return TOKEN_PLUS; }
"-"      { return TOKEN_MIN; }
"*"      { return TOKEN_MUL; }
"/"      { return TOKEN_DIV; }

{INT}    { return TOKEN_INT; }
{ID}     { return TOKEN_ID; }

[ \t\n]+  ;

.        { cout << "Invalid character: " << yytext << endl; }

%%

/* C++ main */
int main() {
    int token;
    while ((token = yylex()) != 0) {
        cout << "Token: " << token << ", Lexeme: " << yytext << endl;
    }
    return 0;
}
int yywrap() {
    return 1;
}