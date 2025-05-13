#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include "scope_table.h"
#include <fstream>

class symbol_table {
private:
    scope_table *current_scope;
    int bucket_count;
    int current_scope_id;

public:
    symbol_table(int bucket_count) {
        this->bucket_count = bucket_count;
        this->current_scope_id = 0;
        this->current_scope = nullptr;
        enter_scope(); // Create global scope
    }

    ~symbol_table() {
        while (current_scope != nullptr) {
            exit_scope();
        }
    }

    void enter_scope() {
        scope_table *new_scope = new scope_table(bucket_count, ++current_scope_id, current_scope);
        current_scope = new_scope;
    }

    void exit_scope() {
        if (current_scope == nullptr) return;
        scope_table *temp = current_scope;
        current_scope = current_scope->get_parent_scope();
        delete temp;
    }

    bool insert(symbol_info* symbol) {
        if (current_scope == nullptr) return false;
        return current_scope->insert_in_scope(symbol);
    }

    symbol_info* lookup(symbol_info* symbol) {
        scope_table *temp = current_scope;
        while (temp != nullptr) {
            symbol_info *found = temp->lookup_in_scope(symbol);
            if (found != nullptr) return found;
            temp = temp->get_parent_scope();
        }
        return nullptr;
    }

    void print_current_scope(ofstream& outlog) {
        if (current_scope != nullptr) {
            current_scope->print_scope_table(outlog);
        }
    }

    void print_all_scopes(ofstream& outlog) {
        outlog << "################################" << endl << endl;
        scope_table *temp = current_scope;
        while (temp != nullptr) {
            temp->print_scope_table(outlog);
            temp = temp->get_parent_scope();
        }
        outlog << "################################" << endl << endl;
    }

    scope_table* get_current_scope() { return current_scope; } // Added getter
};
#endif