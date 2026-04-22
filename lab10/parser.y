%{
#include <iostream> 
using namespace std;

extern int yylex(); 
extern int yylineno;
extern FILE *yyin;
void yyerror(const char *s);
%}

%token IF ELSE FOR
%token AND OR NOT
%token BOOL VOID
%token ID NUMBER STRING
%token INT FLOAT CHAR DOUBLE  /* Additional type tokens */
%token PLUS MINUS MULT DIV MOD
%token EQ NE LT GT LE GE
%token ASSIGN
%token SEMICOLON COMMA
%token LPAREN RPAREN LBRACE RBRACE
%token INCREMENT DECREMENT

%%

program:
      /* empty */
    | program statement
    ;

statement:
      if_statement
    | for_statement
    | other_statements
    ;

if_statement:
      IF '(' condition ')' '{' body '}'
    | IF '(' condition ')' '{' body '}' ELSE '{' body '}'
    ;

for_statement:
    FOR '(' initialization ';' condition ';' update ')' '{' body '}'
    ;

initialization:
      TYPE ID '=' expression
    | ID '=' expression
    | /* empty */
    ;

update:
      ID INCREMENT
    | ID DECREMENT
    | ID '=' expression
    | /* empty */
    ;

condition:
      expression
    | condition AND condition
    | condition OR condition
    | NOT condition
    | /* empty */
    ;

expression:
      ID
    | NUMBER
    | STRING
    | expression PLUS expression
    | expression MINUS expression
    | expression MULT expression
    | expression DIV expression
    | expression MOD expression
    | expression EQ expression
    | expression NE expression
    | expression LT expression
    | expression GT expression
    | expression LE expression
    | expression GE expression
    | '(' expression ')'
    | MINUS expression  /* unary minus */
    ;

TYPE:
      INT
    | FLOAT
    | CHAR
    | DOUBLE
    | BOOL
    | VOID
    ;

body:
      /* empty */
    | body statement
    ;

other_statements:
      expression ';'
    | TYPE ID ';'
    | TYPE ID '=' expression ';'
    | ';'  /* empty statement */
    ;

%%

void yyerror(const char *s) {
    std::cerr << "[Error] Line " << yylineno << ": " << s << std::endl;
}

int main(int argc, char *argv[]) {
    
     if (argc > 1) {
        // Open the input file
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error opening file");
            return 1;
        }
    } else {
        // Default to stdin
        yyin = stdin;
    }
    
    // Parse the entire file (all lines)
    yyparse();
    
    // Close the file if it was opened
    if (argc > 1 && yyin) {
        fclose(yyin);
    }
    
    return 0;
}