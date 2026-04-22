#include <iostream>
using namespace std;
class MyClass {
int x;
int y;
public:
MyClass(int a, int b) {
x = a;
y = b;
}
void display() {
cout << "x = " << x << endl;
cout << "y = " << y << endl;
}
};
int main() {
MyClass obj(10, 20);
obj.display();
if (obj.x > 5) {
cout << "x is greater than 5" << endl;
}
for (int i = 0; i < 3; i++) {
cout << i << endl;
}
return 0;
}