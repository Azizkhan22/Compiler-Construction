%{
#include <iostream>
#include <string>
#include <map>
#include <cstdlib>
#include <cstring>
using namespace std;

extern "C" int yywrap() { return 1; }  // required for C++ compilation

enum DataType { INT, DOUBLE, STRING };

struct Symbol {
    string name;
    DataType type;
    int intValue;
    double doubleValue;
    string stringValue;
};

map<string, Symbol> symbolTable;

// Store last read tokens
string lastIdentifier = "";
DataType lastType;
int lastInt;
double lastDouble;
string lastString;

// Assignment function
void assign(string name, DataType type, int ival=0, double dval=0, string sval="") {
    if(symbolTable.count(name)) {
        Symbol &sym = symbolTable[name];
        if(sym.type != type) {
            cerr << "Semantic Error: Type mismatch in assignment to " << name << endl;
            return; // <--- continue instead of exit
        }
        sym.intValue = ival;
        sym.doubleValue = dval;
        sym.stringValue = sval;
    } else {
        symbolTable[name] = {name, type, ival, dval, sval};
    }
}

// Evaluate addition of two variables
void evaluateAdd(string aName, string bName) {
    Symbol &a = symbolTable[aName];
    Symbol &b = symbolTable[bName];

    if(a.type == STRING && b.type == STRING) {
        cout << a.stringValue + b.stringValue << endl;
        return;
    }

    if((a.type == STRING && b.type != STRING) || (b.type == STRING && a.type != STRING)) {
        cerr << "Semantic Error: Cannot mix string with numeric type" << endl;
        return; // <--- continue instead of exit
    }

    double valA = (a.type == INT) ? a.intValue : a.doubleValue;
    double valB = (b.type == INT) ? b.intValue : b.doubleValue;
    cout << valA + valB << endl;
}

extern FILE* yyin;
%}

%%

"int"           { lastType = INT; return 1; }
"double"        { lastType = DOUBLE; return 2; }
"string"        { lastType = STRING; return 3; }

[0-9]+\.[0-9]+  { lastDouble = atof(yytext); return 4; }
[0-9]+          { lastInt = atoi(yytext); return 5; }

\"[^\"]*\"      { lastString = string(yytext).substr(1, strlen(yytext)-2); return 6; }

[a-zA-Z_][a-zA-Z0-9_]* { lastIdentifier = yytext; return 7; }

"="             { return 8; }
"+"             { return 9; }

[ \t\n]+        ;       // skip spaces, tabs, newlines
"#".*           ;       // skip comments

.               { /* ignore unknown characters */ }

%%

int main(int argc, char* argv[]) {
    if(argc > 1) {
        FILE* file = fopen(argv[1], "r");
        if(!file) {
            cerr << "Cannot open file: " << argv[1] << endl;
            return 1;
        }
        yyin = file;
    }

    int token;
    string a, b;
    while((token = yylex()) != 0) {
        switch(token) {
            case 1: case 2: case 3:  // type keywords
                if(yylex() == 7) { // identifier
                    string varName = lastIdentifier;
                    if(yylex() == 8) { // =
                        int valInt = 0;
                        double valDouble = 0;
                        string valStr = "";
                        int valueToken = yylex();
                        if(valueToken == 5) valInt = lastInt;
                        else if(valueToken == 4) valDouble = lastDouble;
                        else if(valueToken == 6) valStr = lastString;
                        else { cerr << "Syntax Error: Expected literal" << endl; exit(1); }

                        assign(varName, lastType, valInt, valDouble, valStr);
                    }
                }
                break;

            case 7: // identifier for expression
                a = lastIdentifier;
                if(yylex() == 9) { // +
                    if(yylex() == 7) {
                        b = lastIdentifier;
                        evaluateAdd(a, b);
                    }
                }
                break;
        }
    }

    return 0;
}