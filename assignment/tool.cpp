#include <iostream>
#include "myvector.h"
#include <fstream>
#define SIZE 40
using namespace std;

class IndentationTool {
    private:
        MyVector lines;
        string inputFile;
        string outputFile;
        string indentStr;

    public:
        IndentationTool(string input, string output) : lines(100), inputFile(input), outputFile(output) {
            indentStr = "    "; // 4 spaces
        }

        void readFile() {
            ifstream file(inputFile);
            if (!file.is_open()) {
                cout << "Error: Could not open file " << inputFile << endl;
                return;
            }

            string line;
            while (getline(file, line)) {
                lines.push(line);
            }
            file.close();
        }

        string trim(string str) {
            int start = 0;
            int end = str.length() - 1;

            while (start < str.length() && str[start] == ' ') start++;
            while (end >= 0 && str[end] == ' ') end--;

            if (start > end) return "";
            return str.substr(start, end - start + 1);
        }

        string getIndent(int level) {
            string result = "";
            for (int i = 0; i < level; i++) {
                result += indentStr;
            }
            return result;
        }

        void processAndIndent() {
            MyVector indentedLines(100);
            int indentLevel = 0;

            for (int i = 0; i < lines.elements; i++) {
                string line = trim(lines.valueAt(i));
                
                if (line.empty()) {
                    indentedLines.push("");
                    continue;
                }

                // Decrease indent for closing braces BEFORE adding line
                if (line[0] == '}') {
                    indentLevel--;
                    if (indentLevel < 0) indentLevel = 0;
                }

                // Add indented line
                string indentedLine = getIndent(indentLevel) + line;
                indentedLines.push(indentedLine);

                // Increase indent for opening braces AFTER adding line
                for (int j = 0; j < line.length(); j++) {
                    if (line[j] == '{') {
                        indentLevel++;
                    }
                }
            }

            // Display on screen
            cout << "\n=== Indented Code ===\n" << endl;
            for (int i = 0; i < indentedLines.elements; i++) {
                cout << indentedLines.valueAt(i) << endl;
            }

            // Write to output file
            ofstream outFile(outputFile);
            if (!outFile.is_open()) {
                cout << "Error: Could not create output file " << outputFile << endl;
                return;
            }

            for (int i = 0; i < indentedLines.elements; i++) {
                outFile << indentedLines.valueAt(i) << endl;
            }
            outFile.close();

            cout << "\nIndented code written to " << outputFile << endl;
        }

        void indent() {
            readFile();
            processAndIndent();
        }
};

int main() {
    IndentationTool tool("input.cpp", "output.cpp");
    tool.indent();

    return 0;
}