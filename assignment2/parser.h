    #ifndef PARSER_H
    #define PARSER_H

    #include "lexer.h"

    class Parser {
    private:
        Token* tokens;
        int size;
        int pos;

        Token current();
        void advance();
        bool match(tokenType type);

        // Grammar functions
        bool E();
        bool EPrime();
        bool T();
        bool TPrime();
        bool F();

    public:
        Parser(Token* t, int s);

        void parse();
    };

    #endif