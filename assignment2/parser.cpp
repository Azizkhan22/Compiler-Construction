#include <iostream>
#include "parser.h"
using namespace std;


Parser::Parser(Token* t, int s) {
    tokens = t;
    size = s;
    pos = 0;
}


Token Parser::current() {
    return tokens[pos];
}

void Parser::advance() {
    if (pos < size) pos++;
}

bool Parser::match(tokenType type) {
    if (current().type == type) {
        advance();
        return true;
    }
    return false;
}

bool Parser::E() {
    if (T()) {
        return EPrime();
    }
    return false;
}

bool Parser::EPrime() {
    if (current().type == PLUS) {
        match(PLUS);
        if (T()) return EPrime();
        return false;
    }
    return true; // ε
}

bool Parser::T() {
    if (F()) {
        return TPrime();
    }
    return false;
}

bool Parser::TPrime() {
    if (current().type == MUL) {
        match(MUL);
        if (F()) return TPrime();
        return false;
    }
    return true; // ε
}

bool Parser::F() {
    if (match(NUM)) return true;
    if (match(ID)) return true;

    if (match(LPAREN)) {
        if (E() && match(RPAREN)) {
            return true;
        }
        return false;
    }

    return false;
}


void Parser::parse() {
    if (E() && current().type == EOF_TOKEN) {
        cout << "Parsing Successful" << endl;
    } else {
        cout << "Syntax Error" << endl;
    }
}