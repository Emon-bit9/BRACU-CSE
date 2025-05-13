#include "scope_table.h"

class symbol_table {
private:
    scope_table *current_scope;
    int bucket_count;
    int current_scope_id;
public:
    symbol_table(int bucket_count);
    ~symbol_table();
    void enter_scope(ofstream& outlog);
    void exit_scope(ofstream& outlog);
    bool insert(symbol_info* symbol);
    symbol_info* lookup(symbol_info* symbol);
    void print_current_scope(ofstream& outlog);
    void print_all_scopes(ofstream& outlog);
    // You can add more methods if you need...
    symbol_info* lookup_in_current_scope(symbol_info* symbol);
};

// initializing the symbol table
symbol_table::symbol_table(int _bucket_count) {
    bucket_count = _bucket_count;
    current_scope_id = 1;
}

symbol_table::~symbol_table() {
    delete current_scope;
}

void symbol_table::enter_scope(ofstream& outlog) {
    outlog << "New ScopeTable with ID " << current_scope_id << " created\n\n";
    scope_table *temp_scope = current_scope;
    current_scope = new scope_table(bucket_count, current_scope_id, temp_scope);
    cout << "....Scope entered....\n";
    current_scope_id++;
}

void symbol_table::exit_scope(ofstream& outlog) {
    outlog << "ScopeTable with ID " << current_scope->get_unique_id() << " removed" << endl << endl;
    cout << "....Exiting Scope....\n";
    current_scope = current_scope->get_parent_scope();
    cout << "....Scope exited....\n";
}

bool symbol_table::insert(symbol_info* symbol) {
    symbol_info* returnedResult = lookup_in_current_scope(symbol);
    cout << "....RETURNED RESULT.... => " << returnedResult << endl << endl;
    if (returnedResult == 0) {
        cout << "....Inserting symbol....\n";
        current_scope->insert_in_scope(symbol);
    } else {
        cout << "[Returning 0]\n\n";
        return 0;
    }
    return 1;
}

symbol_info* symbol_table::lookup_in_current_scope(symbol_info* symbol) {
    return (this->current_scope)->lookup_in_only_current_scope(symbol);
}

symbol_info *symbol_table::lookup(symbol_info* symbol) {
    return current_scope->lookup_in_scope(symbol);
}

// Complete the methods of symbol_table class here (if needed)...
void symbol_table::print_current_scope(ofstream& outlog) {
    current_scope->print_scope_table(outlog);
}

void symbol_table::print_all_scopes(ofstream& outlog) {
    outlog << "################################" << endl << endl;
    scope_table *temp = current_scope;
    while (temp != NULL) {
        temp->print_scope_table(outlog);
        if (temp->get_parent_scope() != NULL) {
            outlog << endl;
        }
        temp = temp->get_parent_scope();
    }
    outlog << "################################" << endl << endl;
}