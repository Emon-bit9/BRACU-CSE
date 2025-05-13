#ifndef SCOPE_TABLE_H
#define SCOPE_TABLE_H

#include "symbol_info.h"
#include <vector>
#include <list>
#include <fstream>

class scope_table {
private:
    int bucket_count;
    int unique_id;
    scope_table *parent_scope = NULL;
    vector<list<symbol_info*>> table;

    int hash_function(string name) {
        unsigned int hash = 0;
        for (char c : name) {
            hash = (hash * 31 + c) % bucket_count;
        }
        return hash;
    }

public:
    scope_table() : bucket_count(0), unique_id(0) {}

    scope_table(int bucket_count, int unique_id, scope_table *parent_scope) {
        this->bucket_count = bucket_count;
        this->unique_id = unique_id;
        this->parent_scope = parent_scope;
        table.resize(bucket_count);
    }

    scope_table *get_parent_scope() { return parent_scope; }
    int get_unique_id() { return unique_id; }

    symbol_info *lookup_in_scope(symbol_info* symbol) {
        int index = hash_function(symbol->get_name());
        for (auto &entry : table[index]) {
            if (entry->get_name() == symbol->get_name()) {
                return entry;
            }
        }
        return nullptr;
    }

    bool insert_in_scope(symbol_info* symbol) {
        if (lookup_in_scope(symbol) != nullptr) {
            return false; // Already exists in this scope
        }
        int index = hash_function(symbol->get_name());
        table[index].push_back(symbol);
        return true;
    }

    bool delete_from_scope(symbol_info* symbol) {
        int index = hash_function(symbol->get_name());
        for (auto it = table[index].begin(); it != table[index].end(); ++it) {
            if ((*it)->get_name() == symbol->get_name()) {
                delete *it; // Deallocate memory
                table[index].erase(it);
                return true;
            }
        }
        return false;
    }

    void print_scope_table(ofstream& outlog) {
        outlog << "ScopeTable # " << unique_id << endl;
        for (int i = 0; i < bucket_count; i++) {
            if (!table[i].empty()) {
                outlog << i << " --> ";
                for (auto &symbol : table[i]) {
                    outlog << "< " << symbol->get_name() << " : " << symbol->get_type() << " >\n";
                    outlog << symbol->get_symbol_type() << "\n";
                    if (symbol->get_symbol_type() == "Variable" || symbol->get_symbol_type() == "Array") {
                        outlog << "Type: " << symbol->get_data_type() << "\n";
                        if (symbol->get_symbol_type() == "Array") {
                            outlog << "Size: " << symbol->get_array_size() << "\n";
                        }
                    } else if (symbol->get_symbol_type() == "Function") {
                        outlog << "Return Type: " << symbol->get_data_type() << "\n";
                        outlog << "Number of Parameters: " << symbol->get_parameters().size() << "\n";
                        outlog << "Parameter Details: ";
                        for (size_t j = 0; j < symbol->get_parameters().size(); j++) {
                            outlog << symbol->get_parameters()[j].first << " " << symbol->get_parameters()[j].second;
                            if (j < symbol->get_parameters().size() - 1) outlog << ", ";
                        }
                        outlog << "\n";
                    }
                }
            }
        }
        outlog << endl;
    }

    ~scope_table() {
        for (auto &bucket : table) {
            for (auto &symbol : bucket) {
                delete symbol;
            }
            bucket.clear();
        }
    }
};
#endif 