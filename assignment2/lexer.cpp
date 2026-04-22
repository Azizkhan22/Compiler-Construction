#include "lexer.h"
#include <iostream>
#include <cctype>
using namespace std;

Token::Token() {}

Token::Token(tokenType t, string v) {
    type = t;
    value = v;
}
string tokenTypeToString(tokenType type) { 
    switch (type) 
    { 
        case ID: return "ID"; 
        case NUM: return "NUM"; 
        case PLUS: return "PLUS"; 
        case MUL: return "MUL"; 
        case LPAREN: return "LPAREN"; 
        case RPAREN: return "RPAREN"; 
        case WS: return "WS"; 
        case EOF_TOKEN: return "EOF"; 
        default: return "UNKNOWN"; 
    } 
}

string Token::getToken() {
    switch (type) {
        case ID: return "<ID, " + value + ">";
        case NUM: return "<NUM, " + value + ">";
        case PLUS: return "<PLUS, " + value + ">";
        case MUL: return "<MUL, " + value + ">";
        case LPAREN: return "<LPAREN, " + value + ">";
        case RPAREN: return "<RPAREN, " + value + ">";
        case WS: return "<WS, " + value + ">";
        case EOF_TOKEN: return "<EOF, " + value + ">";
        default: return "<UNKNOWN>";
    }
}


Lexer::Lexer(string exp) : expression(exp) {
    totalTokens = 0;
}

tokenType Lexer::checktype(char x) {
    if (isdigit(x)) return NUM;
    else if (x == '+') return PLUS;
    else if (x == '*') return MUL;
    else if (x == '(') return LPAREN;
    else if (x == ')') return RPAREN;
    else if (x == ' ') return WS;
    else return ID;
}

void Lexer::addToken(Token t) {
    if (totalTokens < 50) {
        tokens[totalTokens++] = t;
    }
}

void Lexer::tokenize() {
    string value;

    for (int i = 0; i < expression.length();) {

        char current = expression[i];        

        if (current == ' ') {
            i++;
            continue;
        }

        tokenType type = checktype(current);

        // NUMBER
        if (type == NUM) {
            value = "";
            while (i < expression.length() && isdigit(expression[i])) {
                value += expression[i];
                i++;
            }
            addToken(Token(NUM, value));
        }

        // IDENTIFIER
        else if (type == ID) {
            value = "";
            while (i < expression.length() && isalnum(expression[i])) {
                value += expression[i];
                i++;
            }
            addToken(Token(ID, value));
        }

        // OPERATORS
        else {
            string op(1, current);

            if (type == PLUS) addToken(Token(PLUS, op));
            else if (type == MUL) addToken(Token(MUL, op));
            else if (type == LPAREN) addToken(Token(LPAREN, op));
            else if (type == RPAREN) addToken(Token(RPAREN, op));

            i++;
        }
    }

    addToken(Token(EOF_TOKEN, "EOF"));
}
void Lexer::showTokens() {
    for (int i = 0; i < totalTokens; i++) {
        cout << tokens[i].getToken() << "\n";
    }
    cout << endl;
}

Token* Lexer::getTokens() {
    return tokens;
}

int Lexer::getTokenCount() {
    return totalTokens;
}