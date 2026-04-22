%{
#include "bison.tab.h"  /* Should be .h not .c */
%}

%option noyywrap
%option yylineno

%%

("TRUE"|"true")     { return TRUE; }
("FALSE"|"false")   { return FALSE; }
("AND"|"and")       { return AND; }
("OR"|"or")         { return OR; }
("NOT"|"not")       { return NOT; }
[ \t\n\r]+          ; /* Skip whitespace and line breaks */
.                   { return yytext[0]; }

%%