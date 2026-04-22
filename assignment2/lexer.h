#ifndef LEXER_H
#define LEXER_H

#include <string>
using namespace std;

enum tokenType {
    ID, NUM, PLUS, MUL, LPAREN, RPAREN, WS, EOF_TOKEN
};

string tokenTypeToString(tokenType type);

class Token {
public:
    tokenType type;
    string value;

    Token();
    Token(tokenType t, string v);

    string getToken();
};

class Lexer {
private:
    string expression;
    Token tokens[50];
    int totalTokens;

public:
    Lexer(string exp);

    void tokenize();
    void addToken(Token t);

    Token* getTokens();
    int getTokenCount();

    void showTokens();

    tokenType checktype(char x);
};

#endif