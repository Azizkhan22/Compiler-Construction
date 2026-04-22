#include <iostream>
#include "parser.h"
using namespace std;

int main() {    
    string expression;
    cout<<"Enter your expression to be parsed: \n";    
    getline(cin,expression);
    Lexer lex(expression);
    cout<<"Tokenizing now...\n";
    lex.tokenize();
    lex.showTokens();
    Parser parser(lex.getTokens(),lex.getTokenCount());
    cout<<"Parsing now...\n";
    parser.parse();
}
