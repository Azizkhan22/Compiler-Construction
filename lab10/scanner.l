%{
#include <iostream>
#include "parser.tab.h"
using namespace std;
extern int yylineno;
%}

%option yylineno

%%

"if"       { return IF; }
"else"     { return ELSE; }
"for"      { return FOR; }
"bool"     { return BOOL; }
"void"     { return VOID; }
"int"      { return INT; }
"float"    { return FLOAT; }
"char"     { return CHAR; }
"double"   { return DOUBLE; }

"&&"       { return AND; }
"||"       { return OR; }
"!"        { return NOT; }

"++"       { return INCREMENT; }
"--"       { return DECREMENT; }

"+"        { return PLUS; }
"-"        { return MINUS; }
"*"        { return MULT; }
"/"        { return DIV; }
"%"        { return MOD; }

"=="       { return EQ; }
"!="       { return NE; }
"<"        { return LT; }
">"        { return GT; }
"<="       { return LE; }
">="       { return GE; }

"="        { return ASSIGN; }

";"        { return SEMICOLON; }
","        { return COMMA; }
"("        { return LPAREN; }
")"        { return RPAREN; }
"{"        { return LBRACE; }
"}"        { return RBRACE; }

[a-zA-Z_][a-zA-Z0-9_]*  { return ID; }
[0-9]+                   { return NUMBER; }
[0-9]+\.[0-9]+          { return NUMBER; }
\"[^\"]*\"              { return STRING; }

[ \t\n]+    ;  /* skip whitespace */

.           { cout << "Invalid character: " << yytext << endl; }

%%

int yywrap() {
    return 1;
}