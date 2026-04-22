#include "myvector.h"
#include <iostream>
using namespace std;
 
MyVector::MyVector(int s){
    this->array = new string[s];
    this->size = s;
    this->elements = 0;
    this->currentIdx = 0;
    this->sizejmp = 20;
}

string* MyVector::newArray(int newsize) {    
    string* newarr = new string[newsize];    
    for (int i=0; i<this->size; i++) {
        newarr[i] = this->array[i];
    }    
    delete[] this->array;        
    this->size = newsize;    
    return newarr;
}

void MyVector::push(string val) {
    try {
        if (this->elements < this->size){
            array[this->currentIdx] = val; 
            currentIdx++;
            elements++;
    } else {        
        this->array = newArray(this->size+this->sizejmp);
        this->array[this->currentIdx] = val;         
        currentIdx++;
        elements++;
    }
    } catch (string e) {
        cout<<e;
    }
    
}

string MyVector::valueAt(int idx) {
    if (idx >= size || idx<0) {
        cout << "Out of bound index";
        return "\0";        
    } else {
        string value = this->array[idx];
        return value;
    }
}

string MyVector::pop() {
    if (elements == 0) {
        cout<<"The array is empty\n";
        return "";
    } else {
        string value = this->array[this->currentIdx];
        this->array[this->currentIdx] = '\0';
        this->currentIdx--;
        this->elements--;
        return value;
    }
}