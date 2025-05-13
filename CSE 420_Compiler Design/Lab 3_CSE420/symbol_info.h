#ifndef SYMBOL_INFO_H
#define SYMBOL_INFO_H

#include <bits/stdc++.h>
using namespace std;

class symbol_info {
private:
    string name;          // Symbol name (e.g., "a", "func")
    string type;          // Token type (e.g., "ID")
    string symbol_type;   // "Variable", "Array", "Function"
    string data_type;     // "int", "float", "void", etc.
    int array_size;       // Size if symbol is an array, -1 otherwise
    vector<pair<string, string>> parameters; // For functions: <param_type, param_name>
    vector<string> arg_types; // For argument lists in function calls

public:
    symbol_info(string name, string type) {
        this->name = name;
        this->type = type;
        this->symbol_type = "";
        this->data_type = "";
        this->array_size = -1; // Default: not an array
    }

    string get_name() { return name; }
    string get_type() { return type; }
    string get_symbol_type() { return symbol_type; }
    string get_data_type() { return data_type; }
    int get_array_size() { return array_size; }
    vector<pair<string, string>>& get_parameters() { return parameters; }
    vector<string>& get_arg_types() { return arg_types; }

    void set_name(string name) { this->name = name; }
    void set_type(string type) { this->type = type; }
    void set_symbol_type(string stype) { this->symbol_type = stype; }
    void set_data_type(string dtype) { this->data_type = dtype; }
    void set_array_size(int size) { this->array_size = size; }
    void add_parameter(string param_type, string param_name) {
        parameters.push_back({param_type, param_name});
    }

    ~symbol_info() {
        parameters.clear();
        arg_types.clear();
    }
};
#endif 