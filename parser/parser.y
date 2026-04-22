%{
#include <iostream> 
#include <string>

extern int yylex(); 
extern int yylineno;
void yyerror(const char *s);
%}

%token HEADER NAMESPACE TYPE RETURN WHILE IF BUILTIN IOSTREAM STREAM_OP ID NUM UPDATE_OP REL_OP TRUE FALSE AND OR NOT

/* Fix ambiguity with precedence */
%left '+' '-'
%left '*' '/' '%'

%%

program:
    headers opt_namespace declarations functions 
    { 
        std::cout << "\n[Success] Program is Syntactically Correct C++-Lite!" << std::endl;
    }
    ;

headers: 
    HEADER 
    | headers HEADER    /* Changed order - more standard */
    ;

opt_namespace: 
    NAMESPACE 
    | /* empty */ 
    ;

declarations: 
    /* empty */
    | declarations decl    /* Changed order */
    ;

decl: 
    TYPE ID '(' TYPE ')' ';' 
    ;

functions: 
    function 
    | functions function    /* Changed order */
    ;

function: 
    TYPE ID '(' params ')' '{' statements '}' 
    ;

params: 
    /* empty */
    | TYPE ID 
    | TYPE 
    ;

/* Renamed to avoid conflict */
statements: 
    /* empty */
    | statements statement 
    ;

statement:
    TYPE ID ';'
    | TYPE ID '=' expr ';'
    | ID '=' expr ';'
    | ID UPDATE_OP ';'
    | ID '/' '=' expr ';'
    | ID '+' '=' expr ';'
    | WHILE '(' condition ')' '{' statements '}'
    | BUILTIN '(' args ')' ';'
    | IOSTREAM STREAM_OP expr ';'
    | RETURN expr ';' 
    ;

expr: 
    ID 
    | NUM 
    | BUILTIN '(' args ')' 
    | ID '%' NUM 
    | expr '+' expr 
    | expr '*' expr 
    ;

args: 
    /* empty */
    | arg_list 
    ;

arg_list: 
    arg 
    | arg_list ',' arg    /* Changed order */
    ;

arg: 
    ID 
    | NUM 
    ;

condition: 
    ID REL_OP NUM 
    | ID REL_OP ID 
    | ID '!' '=' NUM 
    ;

%%

void yyerror(const char *s) {
    std::cerr << "[Error] Line " << yylineno << ": " << s << std::endl;
}

int main() {
    std::cout << "--- C++-Lite Syntax Validator Initialized ---" << std::endl;
    return yyparse();
}