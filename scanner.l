%{
#include <iostream>
#include <unordered_map>
#include <stack>
#include <string>

using namespace std;

/* ---------- Symbol Structure ---------- */

struct Symbol{
    string name;
    string type;
};

/* ---------- Scope Structure ---------- */

struct Scope{
    string scopeName;
    unordered_map<string,Symbol> symbols;
};

/* ---------- Symbol Table ---------- */

class SymbolTable{
public:

    stack<Scope> scopes;

    void enterScope(string name){
        Scope s;
        s.scopeName=name;
        scopes.push(s);
        cout<<"Entering Scope: "<<name<<endl;
    }

    void exitScope(){
        if(!scopes.empty()){
            cout<<"Leaving Scope: "<<scopes.top().scopeName<<endl;
            scopes.pop();
        }
    }

    void insert(string name,string type,int line){

        if(scopes.empty()) return;

        Scope &current=scopes.top();

        if(current.symbols.find(name)!=current.symbols.end()){
            cout<<"Semantic Error (line "<<line<<"): Duplicate declaration of "<<name<<endl;
            return;
        }

        Symbol s;
        s.name=name;
        s.type=type;

        current.symbols[name]=s;

        cout<<"Inserted "<<type<<" "<<name<<" in "<<current.scopeName<<endl;
    }
};

SymbolTable symtab;

string currentType="";

%}

%option noyywrap
%option yylineno

ID      [a-zA-Z_][a-zA-Z0-9_]*
TYPE    int|double|float|char|void

%%

"class"[ \t]+{ID}[ \t]*"{"    {
    string text = yytext;
    string cname = text.substr(6);
    symtab.enterScope("Class: "+cname);
}

{TYPE}[ \t]+{ID}"(".*")"[ \t]*"{"   {
    string text = yytext;

    size_t pos1 = text.find(" ");
    size_t pos2 = text.find("(");

    string method = text.substr(pos1+1,pos2-pos1-1);

    symtab.enterScope("Method: "+method);
}

"}" {
    symtab.exitScope();
}

{TYPE} {
    currentType=yytext;
}

{ID} {
    if(currentType!=""){
        symtab.insert(yytext,currentType,yylineno);
    }
}

";" {
    currentType="";
}

[ \t\r\n]+ ;

. ;

%%

int main(int argc,char **argv){

    if(argc>1){
        FILE *file=fopen(argv[1],"r");
        if(!file){
            cout<<"File not found"<<endl;
            return 1;
        }
        yyin=file;
    }

    symtab.enterScope("Global");

    yylex();

    return 0;
}