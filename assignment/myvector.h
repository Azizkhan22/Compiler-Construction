#ifndef myvector_h 
#define myvector_h
#include <string>
using namespace std;

class MyVector {

public:
    string* array;
    int elements;
    int size;
    int currentIdx;
    int sizejmp;

    MyVector(int);

    void push(string);
    string pop();
    string valueAt(int);
    string* newArray(int);

};


#endif