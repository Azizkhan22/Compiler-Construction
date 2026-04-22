{%
#include "parser.tab.hpp"
%}

%option noyywrap
%option yylineno

%%
"#include"[ ]*<[^>]+>	{ return HEADER; } 
"using namespace std;"		{ return NAMESPACE;}
"int"|"long"|"long long"	{ return TYPE; }
 
["TRUE""true"]  {return TRUE;}
["FALSE""false"]  {return FALSE;}
["AND""and"]  {return AND;}
["OR""or"]  {return OR;}
["NOT""not"]  {return NOT;}

"return"	{ return RETURN; }
"while"		{ return WHILE; } 
"if"	{ return IF; }
"printf"|"scanf"|"pow"	{ return BUILTIN; } 
"cout"|"cin"	{ return IOSTREAM; }
"<<"|">>"	{ return STREAM_OP; }
[a-zA-Z_][a-zA-Z0-9_]* { return ID; } 
[0-9]+	{ return NUM; }
"++"|"--"|"+="|"-="|"/="|"%=" { return UPDATE_OP; }
"=="|"!="|"<="|">="|"<"|">" { return REL_OP; }
[ \t\n\r]	; /* Skip whitespace and line breaks */
.	{ return yytext[0]; }
%%
