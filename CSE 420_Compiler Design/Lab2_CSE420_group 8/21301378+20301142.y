%{
#include "symbol_table.h"
#define YYSTYPE symbol_info*
extern FILE *yyin;
int yyparse(void);
int yylex(void);
extern YYSTYPE yylval;
// Create your symbol table here.
symbol_table SymbolTable(8);
// You can store the pointer to your symbol table in a global variable.
symbol_table *new_symbol_table;
// Or you can create an object of your symbol table here.
symbol_info *new_symbol_info;
int lines = 1;
ofstream outlog;
// You may declare other necessary variables here to store necessary info such as function parameters, etc.
list<symbol_info*> parameter_info;
// Such as current variable type, variable list, function name, return type, function parameter types, parameters names etc.
symbol_info *function_info;
list<symbol_info*> store_var_info;

void yyerror(char *store_var_info) {
    outlog << "At line" << lines << " " << store_var_info << endl << endl;
    // You may need to reinitialize variables if you find an error in the input file.
}
%}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON CONST_INT CONST_FLOAT ID
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program {
    outlog << "At line no: " << lines << " start : program " << endl << endl;
    outlog << "Symbol Table" << endl << endl;
    // Print your whole symbol table here to the log file.
    new_symbol_table->print_all_scopes(outlog);
}
;

program : program unit {
    outlog << "At line no: " << lines << " program : program unit " << endl << endl;
    outlog << $1->get_name() + "\n" + $2->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + "\n" + $2->get_name(), "program");
}
| unit {
    outlog << "At line no: " << lines << " program : unit " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "program");
}
;

unit : var_declaration {
    outlog << "At line no: " << lines << " unit : var_declaration " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "unit");
}
| func_definition {
    outlog << "At line no: " << lines << " unit : func_definition " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "unit");
}
;

func_definition : type_specifier ID LPAREN parameter_list RPAREN {
    function_info = new symbol_info($2->get_name(), $2->get_type());
    function_info->set_function_state(true);
    function_info->set_return_type($1->get_name());
    function_info->set_parameter_size(parameter_info.size());
    function_info->set_parameter_info(parameter_info);
    cout << "Inserting Symbol: \n";
    int returned_result = new_symbol_table->insert(function_info);
    new_symbol_table->enter_scope(outlog);
    for (auto it = parameter_info.begin(); it != parameter_info.end(); it++) {
        int returned_result = new_symbol_table->insert((*it));
    }
    parameter_info.clear();
} compound_statement {
    outlog << "At line no: " << lines << " func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement " << endl << endl;
    outlog << $1->get_name() << " " << $2->get_name() << "(" << $4->get_name() << ")\n" << $7->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + " " + $2->get_name() + "(" + $4->get_name() + ")\n" + $7->get_name(), "func_def");
    // The function definition is complete.
    // You can now insert necessary information about the function into the symbol table.
    // However, note that the scope of the function and the scope of the compound statement are different.
}
| type_specifier ID LPAREN RPAREN {
    function_info = new symbol_info($2->get_name(), $2->get_type());
    function_info->set_function_state(true);
    function_info->set_return_type($1->get_name());
    function_info->set_parameter_size(0);
    cout << "Inserting Symbol: \n";
    int returned_result = new_symbol_table->insert(function_info);
    new_symbol_table->enter_scope(outlog);
} compound_statement {
    outlog << "At line no: " << lines << " func_definition : type_specifier ID LPAREN RPAREN compound_statement " << endl << endl;
    outlog << $1->get_name() << " " << $2->get_name() << "()\n" << $6->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + " " + $2->get_name() + "()\n" + $6->get_name(), "func_def");
    // The function definition is complete.
    // You can now insert necessary information about the function into the symbol table.
    // However, note that the scope of the function and the scope of the compound statement are different.
}
;

parameter_list : parameter_list COMMA type_specifier ID {
    outlog << "At line no: " << lines << " parameter_list : parameter_list COMMA type_specifier ID " << endl << endl;
    outlog << $1->get_name() << "," << $3->get_name() << " " << $4->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + "," + $3->get_name() + " " + $4->get_name(), "param_list");
    // Store the necessary information about the function parameters.
    // They will be needed when you want to enter the function into the symbol table.
    new_symbol_info = new symbol_info($4->get_name(), $4->get_type());
    new_symbol_info->set_return_type($3->get_name());
    new_symbol_info->set_variable_state(true);
    parameter_info.push_back(new_symbol_info);
}
| parameter_list COMMA type_specifier {
    outlog << "At line no: " << lines << " parameter_list : parameter_list COMMA type_specifier " << endl << endl;
    outlog << $1->get_name() << "," << $3->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + "," + $3->get_name(), "param_list");
    // Store the necessary information about the function parameters.
    // They will be needed when you want to enter the function into the symbol table.
}
| type_specifier ID {
    outlog << "At line no: " << lines << " parameter_list : type_specifier ID " << endl << endl;
    outlog << $1->get_name() << " " << $2->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + " " + $2->get_name(), "param_list");
    // Store the necessary information about the function parameters.
    // They will be needed when you want to enter the function into the symbol table.
    new_symbol_info = new symbol_info($2->get_name(), $2->get_type());
    new_symbol_info->set_variable_state(true);
    new_symbol_info->set_return_type($1->get_name());
    parameter_info.push_back(new_symbol_info);
}
| type_specifier {
    outlog << "At line no: " << lines << " parameter_list : type_specifier " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "param_list");
    // Store the necessary information about the function parameters.
    // They will be needed when you want to enter the function into the symbol table.
}
;

compound_statement : LCURL statements RCURL {
    outlog << "At line no: " << lines << " compound_statement : LCURL statements RCURL " << endl << endl;
    outlog << "{\n" << $2->get_name() << "\n}" << endl << endl;
    $$ = new symbol_info("{\n" + $2->get_name() + "\n}", "comp_stmnt");
    // The compound statement is complete.
    // Print the symbol table here and exit the scope.
    // Note that function parameters should be in the current scope.
    new_symbol_table->print_all_scopes(outlog);
    new_symbol_table->exit_scope(outlog);
    store_var_info.clear();
}
| LCURL RCURL {
    outlog << "At line no: " << lines << " compound_statement : LCURL RCURL " << endl << endl;
    outlog << "{\n}" << endl << endl;
    $$ = new symbol_info("{\n}", "comp_stmnt");
    // The compound statement is complete.
    // Print the symbol table here and exit the scope.
    new_symbol_table->print_all_scopes(outlog);
    new_symbol_table->exit_scope(outlog);
}
;

var_declaration : type_specifier declaration_list SEMICOLON {
    outlog << "At line no: " << lines << " var_declaration : type_specifier declaration_list SEMICOLON " << endl << endl;
    outlog << $1->get_name() << " " << $2->get_name() << ";" << endl << endl;
    $$ = new symbol_info($1->get_name() + " " + $2->get_name() + ";", "var_dec");
	// Insert necessary information about the variables in the symbol table here.
    for (auto it = store_var_info.begin(); it != store_var_info.end(); it++) {
        (*it)->set_return_type($1->get_name());
        int returned_result = new_symbol_table->insert(*it);
    }
    store_var_info.clear();
}
;

type_specifier : INT {
    outlog << "At line no: " << lines << " type_specifier : INT " << endl << endl;
    outlog << "int" << endl << endl;
    $$ = new symbol_info("int", "type");
}
| FLOAT {
    outlog << "At line no: " << lines << " type_specifier : FLOAT " << endl << endl;
    outlog << "float" << endl << endl;
    $$ = new symbol_info("float", "type");
}
| VOID {
    outlog << "At line no: " << lines << " type_specifier : VOID " << endl << endl;
    outlog << "void" << endl << endl;
    $$ = new symbol_info("void", "type");
}
;

declaration_list : declaration_list COMMA ID {
    outlog << "At line no: " << lines << " declaration_list : declaration_list COMMA ID " << endl << endl;
    outlog << $1->get_name() << "," << $3->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + "," + $3->get_name(), "declaration_list");
    // You may need to store the variable names to insert them in symbol table here or later in the var_declaration rule.
    new_symbol_info = new symbol_info($3->get_name(), $3->get_type());
    new_symbol_info->set_variable_state(true);
    store_var_info.push_back(new_symbol_info);
}
| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD { // Array after some declarations in the declaration list rule.
    outlog << "At line no: " << lines << " declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD " << endl << endl;
    outlog << $1->get_name() << "," << $3->get_name() << "[" << $5->get_name() << "]" << endl << endl;
    // You may need to store the variable names to insert them in symbol table here or later in the var_declaration rule.
    $$ = new symbol_info($1->get_name() + "," + $3->get_name() + "[" + $5->get_name() + "]", "declaration_list");
    new_symbol_info = new symbol_info($3->get_name(), $3->get_type());
    new_symbol_info->set_array_state(true);
    new_symbol_info->set_array_size(stoi($5->get_name()));
    store_var_info.push_back(new_symbol_info);
}
| ID {
    outlog << "At line no: " << lines << " declaration_list : ID " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    // You may need to store the variable names to insert them in symbol table here or later in the var_declaration rule.
    $$ = new symbol_info($1->get_name(), "declaration_list");
    new_symbol_info = new symbol_info($1->get_name(), $1->get_type());
    new_symbol_info->set_variable_state(true);
    store_var_info.push_back(new_symbol_info);
}
| ID LTHIRD CONST_INT RTHIRD {
    outlog << "At line no: " << lines << " declaration_list : ID LTHIRD CONST_INT RTHIRD " << endl << endl;
    outlog << $1->get_name() << "[" << $3->get_name() << "]" << endl << endl;
    // You may need to store the variable names to insert them in symbol table here or later in the var_declaration rule.
    $$ = new symbol_info($1->get_name() + "[" + $3->get_name() + "]", "declaration_list");
    new_symbol_info = new symbol_info($1->get_name(), $1->get_type());
    new_symbol_info->set_array_state(true);
    new_symbol_info->set_array_size(stoi($3->get_name()));
    store_var_info.push_back(new_symbol_info);
}
;

statements : statement {
    outlog << "At line no: " << lines << " statements : statement " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "stmnts");
}
| statements statement {
    outlog << "At line no: " << lines << " statements : statements statement " << endl << endl;
    outlog << $1->get_name() << "\n" << $2->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + "\n" + $2->get_name(), "stmnts");
}
;

statement : var_declaration {
    outlog << "At line no: " << lines << " statement : var_declaration " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "stmnt");
}
| func_definition {
    outlog << "At line no: " << lines << " statement : func_definition " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "stmnt");
}
| expression_statement {
    outlog << "At line no: " << lines << " statement : expression_statement " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "stmnt");
}
| {new_symbol_table->enter_scope(outlog);} compound_statement {
    outlog << "At line no: " << lines << " statement : compound_statement " << endl << endl;
    outlog << $2->get_name() << endl << endl;
    $$ = new symbol_info($2->get_name(), "stmnt");
}
| FOR LPAREN expression_statement expression_statement expression RPAREN statement {
    outlog << "At line no: " << lines << " statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement " << endl << endl;
    outlog << "for(" << $3->get_name() << $4->get_name() << $5->get_name() << ")\n" << $7->get_name() << endl << endl;
    $$ = new symbol_info("for(" + $3->get_name() + $4->get_name() + $5->get_name() + ")\n" + $7->get_name(), "stmnt");
}
| IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {
    outlog << "At line no: " << lines << " statement : IF LPAREN expression RPAREN statement " << endl << endl;
    outlog << "if(" << $3->get_name() << ")\n" << $5->get_name() << endl << endl;
    $$ = new symbol_info("if(" + $3->get_name() + ")\n" + $5->get_name(), "stmnt");
}
| IF LPAREN expression RPAREN statement ELSE statement {
    outlog << "At line no: " << lines << " statement : IF LPAREN expression RPAREN statement ELSE statement " << endl << endl;
    outlog << "if(" << $3->get_name() << ")\n" << $5->get_name() << "\nelse\n" << $7->get_name() << endl << endl;
    $$ = new symbol_info("if(" + $3->get_name() + ")\n" + $5->get_name() + "\nelse\n" + $7->get_name(), "stmnt");
}
| WHILE LPAREN expression RPAREN statement {
    outlog << "At line no: " << lines << " statement : WHILE LPAREN expression RPAREN statement " << endl << endl;
    outlog << "while(" << $3->get_name() << ")\n" << $5->get_name() << endl << endl;
    $$ = new symbol_info("while(" + $3->get_name() + ")\n" + $5->get_name(), "stmnt");
}
| PRINTLN LPAREN ID RPAREN SEMICOLON {
    outlog << "At line no: " << lines << " statement : PRINTLN LPAREN ID RPAREN SEMICOLON " << endl << endl;
    outlog << "printf(" << $3->get_name() << ");" << endl << endl;
    $$ = new symbol_info("printf(" + $3->get_name() + ");", "stmnt");
}
| RETURN expression SEMICOLON {
    outlog << "At line no: " << lines << " statement : RETURN expression SEMICOLON " << endl << endl;
    outlog << "return " << $2->get_name() << ";" << endl << endl;
    $$ = new symbol_info("return " + $2->get_name() + ";", "stmnt");
}
;

expression_statement : SEMICOLON {
    outlog << "At line no: " << lines << " expression_statement : SEMICOLON " << endl << endl;
    outlog << ";" << endl << endl;
    $$ = new symbol_info(";", "expr_stmt");
}
| expression SEMICOLON {
    outlog << "At line no: " << lines << " expression_statement : expression SEMICOLON " << endl << endl;
    outlog << $1->get_name() << ";" << endl << endl;
    $$ = new symbol_info($1->get_name() + ";", "expr_stmt");
}
;

variable : ID {
    outlog << "At line no: " << lines << " variable : ID " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "varbl");
    new_symbol_info = new symbol_info($1->get_name(), $1->get_type());
    new_symbol_info = new_symbol_table->lookup(new_symbol_info);
    outlog << new_symbol_info << "" << new_symbol_info->get_name() << endl << endl;
    if (new_symbol_info != NULL) {
        $$->set_return_type(new_symbol_info->get_return_type());
    }
}
| ID LTHIRD expression RTHIRD {
    outlog << "At line no: " << lines << " variable : ID LTHIRD expression RTHIRD " << endl << endl;
    outlog << $1->get_name() << "[" << $3->get_name() << "]" << endl << endl;
    $$ = new symbol_info($1->get_name() + "[" + $3->get_name() + "]", "varbl");
}
;

expression : logic_expression {
    outlog << "At line no: " << lines << " expression : logic_expression " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "expr");
    $$->set_return_type($1->get_return_type());
}
| variable ASSIGNOP logic_expression {
    outlog << "At line no: " << lines << " expression : variable ASSIGNOP logic_expression " << endl << endl;
    outlog << $1->get_name() << "=" << $3->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + "=" + $3->get_name(), "expr");
}
;

logic_expression : rel_expression {
    outlog << "At line no: " << lines << " logic_expression : rel_expression " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "lgc_expr");
    $$->set_return_type($1->get_return_type());
}
| rel_expression LOGICOP rel_expression {
    outlog << "At line no: " << lines << " logic_expression : rel_expression LOGICOP rel_expression " << endl << endl;
    outlog << $1->get_name() << $2->get_name() << $3->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + $2->get_name() + $3->get_name(), "lgc_expr");
}
;

rel_expression : simple_expression {
    outlog << "At line no: " << lines << " rel_expression : simple_expression " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "rel_expr");
    $$->set_return_type($1->get_return_type());
}
| simple_expression RELOP simple_expression {
    outlog << "At line no: " << lines << " rel_expression : simple_expression RELOP simple_expression " << endl << endl;
    outlog << $1->get_name() << $2->get_name() << $3->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + $2->get_name() + $3->get_name(), "rel_expr");
}
;

simple_expression : term {
    outlog << "At line no: " << lines << " simple_expression : term " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "simp_expr");
    $$->set_return_type($1->get_return_type());
}
| simple_expression ADDOP term {
    outlog << "At line no: " << lines << " simple_expression : simple_expression ADDOP term " << endl << endl;
    outlog << $1->get_name() << $2->get_name() << $3->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + $2->get_name() + $3->get_name(), "simp_expr");
}
;

term : unary_expression { //term can be void because of unary_expression -> factor.
    outlog << "At line no: " << lines << " term : unary_expression " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "term");
    $$->set_return_type($1->get_return_type());
}
| term MULOP unary_expression {
    outlog << "At line no: " << lines << " term : term MULOP unary_expression " << endl << endl;
    outlog << $1->get_name() << $2->get_name() << $3->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + $2->get_name() + $3->get_name(), "term");
}
;

unary_expression : ADDOP unary_expression { // unary_expression can be void because of factor.
    outlog << "At line no: " << lines << " unary_expression : ADDOP unary_expression " << endl << endl;
    outlog << $1->get_name() << $2->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + $2->get_name(), "un_expr");
}
| NOT unary_expression {
    outlog << "At line no: " << lines << " unary_expression : NOT unary_expression " << endl << endl;
    outlog << "!" << $2->get_name() << endl << endl;
    $$ = new symbol_info("!" + $2->get_name(), "un_expr");
}
| factor {
    outlog << "At line no: " << lines << " unary_expression : factor " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "un_expr");
    $$->set_return_type($1->get_return_type());
}
;

factor : variable {
    outlog << "At line no: " << lines << " factor : variable " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "fctr");
    $$->set_return_type($1->get_return_type());
}
| ID LPAREN argument_list RPAREN {
    outlog << "At line no: " << lines << " factor : ID LPAREN argument_list RPAREN " << endl << endl;
    outlog << $1->get_name() << "(" << $3->get_name() << ")" << endl << endl;
    $$ = new symbol_info($1->get_name() + "(" + $3->get_name() + ")", "fctr");
    new_symbol_info = new symbol_info($1->get_name(), $1->get_type());
    new_symbol_info = new_symbol_table->lookup(new_symbol_info);
    int index = 1;
    list<symbol_info*> parameter_info2 = new_symbol_info->get_parameter_info();
    cout << "=====>>>>" << $1->get_name() << endl << endl;
    for (auto it = parameter_info.begin(), it2 = parameter_info2.begin(); it != parameter_info.end() && it2 != parameter_info2.end(); it++, it2++) {
        cout << (*it)->get_variable_state() + " ---------------- " + (*it2)->get_variable_state() << endl << endl;
        if ((*it)->get_return_type() != (*it2)->get_return_type()) {
            cout << (*it)->get_return_type() << " " << (*it2)->get_return_type() << endl << endl;
        }
        index++;
    }
    parameter_info.clear();
    parameter_info2.clear();
}
| LPAREN expression RPAREN {
    outlog << "At line no: " << lines << " factor : LPAREN expression RPAREN " << endl << endl;
    outlog << "(" << $2->get_name() << ")" << endl << endl;
    $$ = new symbol_info("(" + $2->get_name() + ")", "fctr");
}
| CONST_INT {
    outlog << "At line no: " << lines << " factor : CONST_INT " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "fctr");
    $$->set_return_type("int");
}
| CONST_FLOAT {
    outlog << "At line no: " << lines << " factor : CONST_FLOAT " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "fctr");
    $$->set_return_type("float");
}
| variable INCOP {
    outlog << "At line no: " << lines << " factor : variable INCOP " << endl << endl;
    outlog << $1->get_name() << "++" << endl << endl;
    $$ = new symbol_info($1->get_name() + "++", "fctr");
}
| variable DECOP {
    outlog << "At line no: " << lines << " factor : variable DECOP " << endl << endl;
    outlog << $1->get_name() << "--" << endl << endl;
    $$ = new symbol_info($1->get_name() + "--", "fctr");
}
;

argument_list : arguments {
    outlog << "At line no: " << lines << " argument_list : arguments " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "arg_list");
    $$->set_return_type($1->get_return_type());
}
| {
    outlog << "At line no: " << lines << " argument_list :  " << endl << endl;
    outlog << "" << endl << endl;
    $$ = new symbol_info("", "arg_list");
}
;

arguments : arguments COMMA logic_expression {
    outlog << "At line no: " << lines << " arguments : arguments COMMA logic_expression " << endl << endl;
    outlog << $1->get_name() << "," << $3->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name() + "," + $3->get_name(), "arg");
    new_symbol_info = new symbol_info($3->get_name(), $3->get_type());
    new_symbol_info->set_return_type($1->get_return_type());
    parameter_info.push_back(new_symbol_info);
}
| logic_expression {
    outlog << "At line no: " << lines << " arguments : logic_expression " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    $$ = new symbol_info($1->get_name(), "arg");
    new_symbol_info = new symbol_info($1->get_name(), $1->get_type());
    new_symbol_info->set_return_type($1->get_return_type());
    parameter_info.push_back(new_symbol_info);
}
;

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        cout << "Please provide the input file" << endl;
        return 0;
    }
    yyin = fopen(argv[1], "r");
    outlog.open("21301378+20301142_log.txt", ios::trunc);
    if (yyin == NULL) {
        cout << "Couldn't open file" << endl;
        return 0;
    }
    // Enter the global or the first scope here.
    new_symbol_table = &SymbolTable;
    new_symbol_table->enter_scope(outlog);
    yyparse();
    outlog << endl << "Total lines: " << lines << endl;
    outlog.close();
    fclose(yyin);
    return 0;
}