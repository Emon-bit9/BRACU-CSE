#include <bits/stdc++.h>
using namespace std;

class symbol_info {
private:
    string name;
    string type;
    // Write necessary attributes to store what type of symbol it is (variable/ array/ function).
    bool is_variable = false;
    bool is_function = false;
    bool is_array = false;
    // Write necessary attributes to store the type/return type of the symbol (int/ float/ void/ ...).
    string return_type;
    // Write necessary attributes to store the parameters of a function.
    list<symbol_info*> parameter_info;
    int parameter_size;
    // Write necessary attributes to store the array size if the symbol is an array.
    int array_size;
public:
    symbol_info(string name, string type) {
        this->name = name;
        this->type = type;
    }
    string get_name() {
        return name;
    }
    string get_type() {
        return type;
    }
    void set_name(string name) {
        this->name = name;
    }
    void set_type(string type) {
        this->type = type;
    }
    // Write necessary functions to set and get the attributes of the symbol_info class.
    void set_return_type(string return_type) {
        this->return_type = return_type;
    }
    string get_return_type() {
        return return_type;
    }
    void set_array_size(int array_size) {
        this->array_size = array_size;
    }
    int get_array_size() {
        return array_size;
    }
    void set_variable_state(bool state) {
        this->is_variable = state;
    }
    bool get_variable_state() {
        return is_variable;
    }
    void set_function_state(bool state) {
        this->is_function = state;
    }
    bool get_function_state() {
        return is_function;
    }
    void set_array_state(bool state) {
        this->is_array = state;
    }
    bool get_array_state() {
        return is_array;
    }
    void set_parameter_info(list<symbol_info*> parameter_info) {
        this->parameter_info = parameter_info;
    }
    list<symbol_info*> get_parameter_info() {
        return parameter_info;
    }
    void set_parameter_size(int size) {
        this->parameter_size = size;
    }
    int get_parameter_size() {
        return parameter_size;
    }
    ~symbol_info() {
        // Write necessary code to deallocate memory, if necessary (not needed in this case).
    }
};