#include <iostream>
#include <string>
#include <vector>
#include <cctype>
using namespace std;

class lexer {
    private:
        string expression;
        vector<string> tokens;

    public:
        lexer (string exp) : expression(exp) {}

        void addToken(string token) {
            this -> tokens.push_back(token);
        }
        vector<string> getTokens() {
            return tokens;
        }
        string checktype(char x) {
            if (isdigit(x)) return "NUMBER";
            else if (x == '+') return "PLUS";
            else if (x == '*') return "MUL";
            else if (x == '(') return "LPAR";
            else if (x == ')') return "RPAR";            
            else return "ID";
        }

        void showTokens() {
            for (int i=0; i < this->tokens.size() ; i++) {
                cout<< tokens[i]<< " ";
            }
        }

        void tokenize() {
            string token = "";
            string type = "";

            for (int i=0; i < this->expression.length(); i++) {
                char current = this->expression[i];                
                if (token.empty()){
                    token += current;
                    type = checktype(current);                    
                } else if ( current == ' ') continue;
                else if ( checktype(current) == type) {
                    token += current;                    
                } else {
                    token = type + "(" + token + ")";
                    addToken(token);                    
                    token = "";
                    token += current;
                    type = checktype(current);
                }
            }
            token = type + "(" + token + ")";
            addToken(token);
            addToken("EOF");
        }
};

int main() {
    lexer lex("a + b * 123");
    lex.tokenize();
    lex.showTokens();
}