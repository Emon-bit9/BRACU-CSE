%{
#include "symbol_info.h"        // For symbol_info type
#include "symbol_table.h"       // For symbol_table
#include <fstream>              // For ofstream
#include <vector>               // For vector type
#define YYSTYPE symbol_info*    // Define YYSTYPE for parser-lexer communication
#include "y.tab.h"             // Include parser header for token definitions

extern YYSTYPE yylval;          // Lexer-parser communication
extern int lines;               // Line counter
extern ofstream outlog;         // Log file stream
extern ofstream outerr;         // Error file stream
extern symbol_table *sym_table; // Symbol table pointer
extern vector<symbol_info*> param_list; // Parameter list for function definitions
extern int error_count;

void yyerror(char *);           // Error handling function
%}

%option noyywrap

/* Definitions Section */
ws          [ \t]+
newline     \n
id          [a-zA-Z_][a-zA-Z0-9_]*
integers    [0-9]+
floats      [0-9]+\.[0-9]+

%%

{ws}        { /* ignore whitespace */ }
{newline}   { lines++; }

if          { return IF; }
else        { return ELSE; }
for         { return FOR; }
while       { return WHILE; }
do          { return DO; }
break       { return BREAK; }
continue    { return CONTINUE; }
return      { return RETURN; }
int         { return INT; }
float       { return FLOAT; }
char        { return CHAR; }
void        { return VOID; }
double      { return DOUBLE; }
switch      { return SWITCH; }
case        { return CASE; }
default     { return DEFAULT; }
printf      { return PRINTLN; }

"+"|"-"     {
                symbol_info *s = new symbol_info((string)yytext, "ADDOP");
                yylval = s;
                return ADDOP;
            }
"*"|"/"|"%" {
                symbol_info *s = new symbol_info((string)yytext, "MULOP");
                yylval = s;
                return MULOP;
            }
"++"        { return INCOP; }
"--"        { return DECOP; }
"<"|">"|"<="|">="|"=="|"!=" {
                symbol_info *s = new symbol_info((string)yytext, "RELOP");
                yylval = s;
                return RELOP;
            }
"="         { return ASSIGNOP; }
"&&"|"||"   {
                symbol_info *s = new symbol_info((string)yytext, "LOGICOP");
                yylval = s;
                return LOGICOP;
            }
"!"         { return NOT; }
"("         { return LPAREN; }
")"         { return RPAREN; }

"{"         { 
                sym_table->enter_scope();
                if (!param_list.empty()) {
                    for (auto param : param_list) {
                        symbol_info *p = new symbol_info(param->get_name(), "ID");
                        p->set_symbol_type("Variable");
                        p->set_data_type(param->get_data_type());
                        if (!sym_table->insert(p)) {
                            outerr << "At line no: " << lines << " Multiple declaration of variable " << param->get_name() << " in parameter" << endl;
                            error_count++;
                        }
                    }
                    // Note: param_list objects are deleted in func_definition
                }
                outlog << "New ScopeTable with ID " << sym_table->get_current_scope()->get_unique_id() << " created" << endl << endl;
                return LCURL; 
            }

"}"         { return RCURL; }
"["         { return LTHIRD; }
"]"         { return RTHIRD; }
";"         { return SEMICOLON; }
","         { return COMMA; }

{id}        {
                symbol_info *s = new symbol_info((string)yytext, "ID");
                yylval = s;
                return ID;
            }
{integers}  {
                symbol_info *s = new symbol_info((string)yytext, "CONST_INT");
                s->set_data_type("int");
                yylval = s;
                return CONST_INT;
            }
{floats}    {
                symbol_info *s = new symbol_info((string)yytext, "CONST_FLOAT");
                s->set_data_type("float");
                yylval = s;
                return CONST_FLOAT;
            }

%%

