%{
#include <iostream> 
using namespace std;

extern int yylex(); 
extern int yylineno;
extern FILE *yyin;
void yyerror(const char *s);
%}

%token TRUE FALSE AND OR NOT

%%
input:
    /* empty */ |
    E input
    ;
E:
    E OR F |
    F
    ;
F:
    F AND T |
    T
    ;
T:
    NOT T |
    '(' E ')' |
    TRUE |
    FALSE
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
    return 0;
}