%{
#include <iostream>
#include <cstdlib>
#include <string>
#include <stdio.h>
#include <sstream>
#include "ass6_20CS10006_translator.h"
extern int yylex();
void yyerror(string s);
extern string Type;
vector <string> allstrings;
using namespace std;
%}

%union {
  int intval;
  char* charval;
  int instr;
  sym* symp;
  symtype* symtp;
  expr* Expressions;
  statement* Statements;
  Array* Arr;
  char unaryOperator;
}
%token AUTO
%token BREAK
%token CASE
%token CHAR
%token CONST
%token CONTINUE
%token DEFAULT
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EXTERN
%token FLOAT
%token FOR
%token GOTO
%token IF
%token INLINE
%token INT
%token LONG
%token REGISTER
%token RESTRICT
%token RETURN
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRUCT
%token SWITCH
%token TYPEDEF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE
%token BOOL
%token COMPLEX
%token IMAGINARY
%token ARROW
%token INCREMENT
%token DECREMENT
%token LEFT_SHIFT
%token RIGHT_SHIFT
%token LESS_THAN
%token GREATER_THAN
%token LESS_THAN_EQUAL_TO
%token GREATER_THAN_EQUAL_TO
%token EQUAL_TO
%token NOT_EQUAL_TO
%token LOGICAL_AND
%token LOGICAL_OR
%token EQUAL
%token MUL_EQUAL
%token DIV_EQUAL
%token PERCENTILE_EQUAL
%token PLUS_EQUAL
%token MINUS_EQUAL
%token LEFT_SHIFT_EQUAL
%token RIGHT_SHIFT_EQUAL
%token AND_EQUAL
%token XOR_EQUAL
%token OR_EQUAL
%token ELLIPSIS
%token <symp>IDENTIFIER
%token <intval>INTEGER_CONSTANT
%token <charval>FLOATING_CONSTANT
%token <charval>CHAR_CONSTANT
%token <charval>STRING_LITERAL
%token PUNCTUATOR

%start translation_unit

%type <Expressions> expression
%type <Expressions> primary_expression
%type <Expressions> multiplicative_expression
%type <Expressions> additive_expression
%type <Expressions> shift_expression
%type <Expressions> relational_expression
%type <Expressions> equality_expression
%type <Expressions> AND_expression
%type <Expressions> exclusive_OR_expression
%type <Expressions> inclusive_OR_expression
%type <Expressions> logical_AND_expression
%type <Expressions> logical_OR_expression
%type <Expressions> conditional_expression
%type <Expressions> assignment_expression
%type <Expressions> expression_statement
%type <intval> argument_expression_list
%type <Arr> postfix_expression
%type <Arr> unary_expression
%type <Arr> cast_expression
%type <unaryOperator> unary_operator
%type <symp> constant initializer
%type <symp> direct_declarator init_declarator declarator
%type <symtp> pointer
%type <Statements> statement
%type <Statements> labeled_statement
%type <Statements> compound_statement
%type <Statements> selection_statement
%type <Statements> iteration_statement
%type <Statements> jump_statement
%type <Statements> block_item
%type <Statements> block_item_list
%type <instr> B
%type <Statements> A



%%
primary_expression:
                    IDENTIFIER
                    {
                        $$ = new expr();
						$$->loc = $1;
						$$->type = "NONBOOL";
                    }
                    |constant
                    {
						$$ = new expr();
						$$->loc = $1;
                    }
                    |STRING_LITERAL
                    {
						$$ = new expr();
						symtype* tmp = new symtype("PTR");
						$$->loc = gentemp(tmp, $1);
						$$->loc->type->ptr = new symtype("CHAR");

						allstrings.push_back($1);
						stringstream strs;
						strs << allstrings.size()-1;
						string temp_str = strs.str();
						char* intStr = (char*) temp_str.c_str();
						string str = string(intStr);
						emit("EQUALSTR", $$->loc->name, str);
                    }
                    |'(' expression ')'
                    {
                        $$ = $2;
                    }
                    ;
constant:
					INTEGER_CONSTANT
					{
						stringstream strs;
						strs << $1;
						string temp_str = strs.str();
						char* intStr = (char*) temp_str.c_str();
						string str = string(intStr);
						$$ = gentemp(new symtype("INTEGER"), str);
						emit("EQUAL", $$->name, $1);
					}
					|FLOATING_CONSTANT
					{
						$$ = gentemp(new symtype("DOUBLE"), string($1));
						emit("EQUAL", $$->name, string($1));
					}
					|CHAR_CONSTANT
					{
						$$ = gentemp(new symtype("CHAR"),$1);
						emit("EQUALCHAR", $$->name, string($1));
					}
					;
postfix_expression:
                    primary_expression
                    {
                        $$ = new Array ();
						$$->Array = $1->loc;
						$$->loc = $$->Array;
						$$->type = $1->loc->type;
                    }
                    |postfix_expression '[' expression ']'
                    {
                        $$ = new Array();

						$$->Array = $1->loc;
						$$->type = $1->type->ptr;
						$$->loc = gentemp(new symtype("INTEGER"));
						if ($1->cat=="ARR")
						{
							sym* t = gentemp(new symtype("INTEGER"));
							stringstream strs;
		    				strs <<size_type($$->type);
		    				string temp_str = strs.str();
		    				char* intStr = (char*) temp_str.c_str();
							string str = string(intStr);
 							emit ("MULT", t->name, $3->loc->name, str);
							emit ("ADD", $$->loc->name, $1->loc->name, t->name);
						}
 						else
						{
							stringstream strs;
		    				strs <<size_type($$->type);
		    				string temp_str = strs.str();
		    				char* intStr1 = (char*) temp_str.c_str();
							string str1 = string(intStr1);
	 						emit("MULT", $$->loc->name, $3->loc->name, str1);
 						}
						$$->cat = "ARR";
                    }
                    |postfix_expression '(' argument_expression_list ')'
                    {
                        $$ = new Array();
						$$->Array = gentemp($1->type);
						stringstream strs;
	    				strs <<$3;
	    				string temp_str = strs.str();
	    				char* intStr = (char*) temp_str.c_str();
						string str = string(intStr);
						emit("CALL", $$->Array->name, $1->Array->name, str);
                    }
                    |postfix_expression '.' IDENTIFIER
                    {

                    }
                    |postfix_expression ARROW IDENTIFIER
                    {

                    }
                    |postfix_expression INCREMENT
                    {
						$$ = new Array();
						$$->Array = gentemp($1->Array->type);
						emit ("EQUAL", $$->Array->name, $1->Array->name);
						emit ("ADD", $1->Array->name, $1->Array->name, "1");
                    }
                    |postfix_expression DECREMENT
                    {
						$$ = new Array();
						$$->Array = gentemp($1->Array->type);
						emit ("EQUAL", $$->Array->name, $1->Array->name);
						emit ("SUB", $1->Array->name, $1->Array->name, "1");
                    }
                    |'(' type_name ')' '{' initializer_list '}'
                    {
						$$ = new Array();
						$$->Array = gentemp(new symtype("INTEGER"));
						$$->loc = gentemp(new symtype("INTEGER"));
                    }
                    |'(' type_name ')' '{' initializer_list ',' '}'
                    {
						$$ = new Array();
						$$->Array = gentemp(new symtype("INTEGER"));
						$$->loc = gentemp(new symtype("INTEGER"));
                    }
                    |postfix_expression '(' ')'
                    {

                    }
                    ;
argument_expression_list:
                    assignment_expression
                    {
						emit ("PARAM", $1->loc->name);
						$$ = 1;
				    }
                    |argument_expression_list ',' assignment_expression
                    {
						emit ("PARAM", $3->loc->name);
						$$ = $1+1;
                    }
                    ;
unary_expression:
                    postfix_expression
                    {
                        $$ = $1;
                    }
                    |INCREMENT unary_expression
					{
                        emit ("ADD", $2->Array->name, $2->Array->name, "1");
						$$ = $2;
                    }
                    |DECREMENT unary_expression
                    {
                        emit ("SUB", $2->Array->name, $2->Array->name, "1");
						$$ = $2;
                    }
                    |unary_operator cast_expression
                    {
                        $$ = new Array();
						switch ($1) {
							case '&':
								$$->Array = gentemp((new symtype("PTR")));
								$$->Array->type->ptr = $2->Array->type;
								emit ("ADDRESS", $$->Array->name, $2->Array->name);
								break;
							case '*':
								$$->cat = "PTR";
								$$->loc = gentemp ($2->Array->type->ptr);
								emit ("PTRR", $$->loc->name, $2->Array->name);
								$$->Array = $2->Array;
								break;
							case '+':
							// unary plus
								$$ = $2;
								break;
							case '-':
							// unary minus
								$$->Array = gentemp(new symtype($2->Array->type->type));
								emit ("UMINUS", $$->Array->name, $2->Array->name);
								break;
							case '~':
							//bitwise not
								$$->Array = gentemp(new symtype($2->Array->type->type));
								emit ("BNOT", $$->Array->name, $2->Array->name);
								break;
							case '!':
							//logical not
								$$->Array = gentemp(new symtype($2->Array->type->type));
								emit ("LNOT", $$->Array->name, $2->Array->name);
								break;
							default:
								break;
						}
                    }
                    |SIZEOF unary_expression
                    {

                    }
                    |SIZEOF '(' type_name ')'
                    {

                    }
                    ;
unary_operator:
                    '&'
                    {
                        $$ = '&';
                    }
                    |'*'
                    {
                        $$ = '*';
                    }
                    |'+'
                    {
                        $$ = '+';
                    }
                    |'-'
                    {
                        $$ = '-';
                    }
                    |'~'
                    {
                        $$ = '~';
                    }
                    |'!'
                    {
                        $$ = '!';
                    }
                    ;
cast_expression:
                    unary_expression
                    {
                        $$ = $1;
                    }
                    |'(' type_name ')' cast_expression
                    {
						$$ = $4;
                    }
                    ;
multiplicative_expression:
                    cast_expression
                    {
                        $$ = new expr();
						if ($1->cat=="ARR")
						{
							$$->loc = gentemp($1->loc->type);
							emit("ARRR", $$->loc->name, $1->Array->name, $1->loc->name);
						}
						else if ($1->cat=="PTR")
						{
							$$->loc = $1->loc;
						}
						else
						{
							$$->loc = $1->Array;
						}
                    }
                    |multiplicative_expression '*' cast_expression
                    {
                        if (typecheck ($1->loc, $3->Array) )
						{
							$$ = new expr();
							$$->loc = gentemp(new symtype($1->loc->type->type));
							emit ("MULT", $$->loc->name, $1->loc->name, $3->Array->name);
						}
						else cout << "Type Error"<< endl;
                    }
                    |multiplicative_expression '/' cast_expression
                    {
                        if (typecheck ($1->loc, $3->Array) )
						{
							$$ = new expr();
							$$->loc = gentemp(new symtype($1->loc->type->type));
							emit ("DIVIDE", $$->loc->name, $1->loc->name, $3->Array->name);
						}
						else cout << "Type Error"<< endl;
                    }
                    |multiplicative_expression '%' cast_expression
                    {
                        if (typecheck ($1->loc, $3->Array) )
						{
							$$ = new expr();
							$$->loc = gentemp(new symtype($1->loc->type->type));
							emit ("MODOP", $$->loc->name, $1->loc->name, $3->Array->name);
						}
						else cout << "Type Error"<< endl;
                    }
                    ;
additive_expression:
                    multiplicative_expression
                    {
                        $$ = $1;
                    }
                    |additive_expression '+' multiplicative_expression
                    {
                        if (typecheck ($1->loc, $3->loc) )
						{
							$$ = new expr();
							$$->loc = gentemp(new symtype($1->loc->type->type));
							emit ("ADD", $$->loc->name, $1->loc->name, $3->loc->name);
						}
						else cout << "Type Error"<< endl;
                    }
                    |additive_expression '-' multiplicative_expression
                    {
                        if (typecheck ($1->loc, $3->loc) )
						{
							$$ = new expr();
							$$->loc = gentemp(new symtype($1->loc->type->type));
							emit ("SUB", $$->loc->name, $1->loc->name, $3->loc->name);
						}
						else cout << "Type Error"<< endl;
                    }
                    ;
shift_expression:
                    additive_expression
                    {
                        $$ = $1;
                    }
                    |shift_expression LEFT_SHIFT additive_expression
                    {
                        if ($3->loc->type->type == "INTEGER")
						{
							$$ = new expr();
							$$->loc = gentemp (new symtype("INTEGER"));
							emit ("LEFTOP", $$->loc->name, $1->loc->name, $3->loc->name);
						}
						else cout << "Type Error"<< endl;
					}
                    |shift_expression RIGHT_SHIFT additive_expression
                    {
				  	    if ($3->loc->type->type == "INTEGER")
						{
							$$ = new expr();
							$$->loc = gentemp (new symtype("INTEGER"));
							emit ("RIGHTOP", $$->loc->name, $1->loc->name, $3->loc->name);
						}
						else cout << "Type Error"<< endl;
                    }
                    ;
relational_expression:
                    shift_expression
                    {
                        $$ = $1;
                    }
                    |relational_expression LESS_THAN shift_expression
                    {
                        if (typecheck ($1->loc, $3->loc) )
						{
							$$ = new expr();
							$$->type = "BOOL";
							$$->truelist = makelist (nextinstr());
							$$->falselist = makelist (nextinstr()+1);
							emit("LT", "", $1->loc->name, $3->loc->name);
							emit ("GOTOOP", "");
						}
						else cout << "Type Error"<< endl;
                    }
                    |relational_expression GREATER_THAN shift_expression
                    {
                        if (typecheck ($1->loc, $3->loc) )
						{
							$$ = new expr();
							$$->type = "BOOL";
							$$->truelist = makelist (nextinstr());
							$$->falselist = makelist (nextinstr()+1);
							emit("GT", "", $1->loc->name, $3->loc->name);
							emit ("GOTOOP", "");
						}
						else cout << "Type Error"<< endl;
                    }
                    |relational_expression LESS_THAN_EQUAL_TO shift_expression
                    {
                       if (typecheck ($1->loc, $3->loc) )
						{
							$$ = new expr();
							$$->type = "BOOL";
							$$->truelist = makelist (nextinstr());
							$$->falselist = makelist (nextinstr()+1);
							emit("LE", "", $1->loc->name, $3->loc->name);
							emit ("GOTOOP", "");
						}
						else cout << "Type Error"<< endl;
                    }
                    |relational_expression GREATER_THAN_EQUAL_TO shift_expression
                    {
                        if (typecheck ($1->loc, $3->loc) )
						{
							$$ = new expr();
							$$->type = "BOOL";
							$$->truelist = makelist (nextinstr());
							$$->falselist = makelist (nextinstr()+1);
							emit("GE", "", $1->loc->name, $3->loc->name);
							emit ("GOTOOP", "");
						}
						else cout << "Type Error"<< endl;
                    }
                    ;
equality_expression:
                    relational_expression
                    {
                        $$ = $1;
                    }
                    |equality_expression EQUAL_TO relational_expression
                    {
                        if (typecheck ($1->loc, $3->loc))
						{
							convertBool2Int ($1);
							convertBool2Int ($3);
							$$ = new expr();
							$$->type = "BOOL";
							$$->truelist = makelist (nextinstr());
							$$->falselist = makelist (nextinstr()+1);
							emit("EQOP", "", $1->loc->name, $3->loc->name);
							emit ("GOTOOP", "");
						}
						else cout << "Type Error"<< endl;
                    }
                    |equality_expression NOT_EQUAL_TO relational_expression
                    {
                        if (typecheck ($1->loc, $3->loc))
						{
							convertBool2Int ($1);
							convertBool2Int ($3);
							$$ = new expr();
							$$->type = "BOOL";
							$$->truelist = makelist (nextinstr());
							$$->falselist = makelist (nextinstr()+1);
							emit("NEOP", "", $1->loc->name, $3->loc->name);
							emit ("GOTOOP", "");
						}
						else cout << "Type Error"<< endl;
                    }
                    ;
AND_expression:
                    equality_expression
                    {
                        $$ = $1;
                    }
                    |AND_expression '&' equality_expression
                    {
                        if (typecheck ($1->loc, $3->loc))
						{
							convertBool2Int ($1);
							convertBool2Int ($3);
							$$ = new expr();
							$$->type = "NONBOOL";
							$$->loc = gentemp (new symtype("INTEGER"));
							emit("BAND", $$->loc->name, $1->loc->name, $3->loc->name);
						}
						else cout << "Type Error"<< endl;
                    }
                    ;
exclusive_OR_expression:
                    AND_expression
                    {
                        $$ = $1;
                    }
                    |exclusive_OR_expression '^' AND_expression
                    {
                        if (typecheck ($1->loc, $3->loc))
						{
							convertBool2Int ($1);
							convertBool2Int ($3);
							$$ = new expr();
							$$->type = "NONBOOL";
							$$->loc = gentemp (new symtype("INTEGER"));
							emit("XOR", $$->loc->name, $1->loc->name, $3->loc->name);
						}
						else cout << "Type Error"<< endl;
                    }
                    ;
inclusive_OR_expression:
                    exclusive_OR_expression
                    {
                        $$ = $1;
                    }
                    |inclusive_OR_expression '|' exclusive_OR_expression
                    {
                        if (typecheck ($1->loc, $3->loc))
						{
							convertBool2Int ($1);
							convertBool2Int ($3);
							$$ = new expr();
							$$->type = "NONBOOL";
							$$->loc = gentemp (new symtype("INTEGER"));
							emit("INOR", $$->loc->name, $1->loc->name, $3->loc->name);
						}
						else cout << "Type Error"<< endl;
                    }
                    ;
logical_AND_expression:
                    inclusive_OR_expression
                    {
                        $$ = $1;
                    }
                    |logical_AND_expression A LOGICAL_AND B inclusive_OR_expression
                    {
                        convertInt2Bool($5);
						backpatch($2->nextlist, nextinstr());
						convertInt2Bool($1);
						$$ = new expr();
						$$->type = "BOOL";
						backpatch($1->truelist, $4);
						$$->truelist = $5->truelist;
						$$->falselist = merge ($1->falselist, $5->falselist);
                    }
                    ;
logical_OR_expression:
                    logical_AND_expression
                    {
                        $$ = $1;
                    }
                    |logical_OR_expression A LOGICAL_OR B logical_AND_expression
                    {
                        convertInt2Bool($5);
						backpatch($2->nextlist, nextinstr());
						convertInt2Bool($1);
						$$ = new expr();
						$$->type = "BOOL";
						backpatch ($1->falselist, $4);
						$$->truelist = merge ($1->truelist, $5->truelist);
						$$->falselist = $5->falselist;
                    }
                    ;
conditional_expression:
                    logical_OR_expression
                    {
                        $$ = $1;
                    }
                    |logical_OR_expression A '?' B expression A ':' B conditional_expression
                    {
                        $$->loc = gentemp($5->loc->type);
						$$->loc->update($5->loc->type);
						emit("EQUAL", $$->loc->name, $9->loc->name);
						list<int> l = makelist(nextinstr());
						emit ("GOTOOP", "");
						backpatch($6->nextlist, nextinstr());
						emit("EQUAL", $$->loc->name, $5->loc->name);
						list<int> m = makelist(nextinstr());
						l = merge (l, m);
						emit ("GOTOOP", "");
						backpatch($2->nextlist, nextinstr());
						convertInt2Bool($1);
						backpatch ($1->truelist, $4);
						backpatch ($1->falselist, $8);
						backpatch (l, nextinstr());
                    }
                    ;
assignment_expression:
                    conditional_expression
                    {
                        $$ = $1;
                    }
                    |unary_expression assignment_operator assignment_expression
                    {
						if($1->cat=="ARR")
						{
							$3->loc = conv($3->loc, $1->type->type);
							emit("ARRL", $1->Array->name, $1->loc->name, $3->loc->name);
						}
						else if($1->cat=="PTR")
						{
							emit("PTRL", $1->Array->name, $3->loc->name);
						}
						else
						{
							$3->loc = conv($3->loc, $1->Array->type->type);
							emit("EQUAL", $1->Array->name, $3->loc->name);
						}
						$$ = $3;
                    }
                    ;
assignment_operator:
                    EQUAL
                    {

                    }
                    |MUL_EQUAL
                    {

                    }
                    |DIV_EQUAL
                    {

                    }
                    |PERCENTILE_EQUAL
                    {

                    }
                    |PLUS_EQUAL
                    {

                    }
                    |MINUS_EQUAL
                    {

                    }
                    |LEFT_SHIFT_EQUAL
                    {

                    }
                    |RIGHT_SHIFT_EQUAL
                    {

                    }
                    |AND_EQUAL
                    {

                    }
                    |XOR_EQUAL
                    {

                    }
                    |OR_EQUAL
                    {

                    }
                    ;
expression:
                    assignment_expression
                    {
                        $$ = $1;
                    }
                    |expression ',' assignment_expression
                    {

                    }
                    ;
constant_expression:
                    conditional_expression
                    {

                    }
                    ;
declaration:
                    declaration_specifier init_declarator_list ';'
                    {

                    }
                    |declaration_specifier ';'
                    {

                    }
                    ;
declaration_specifier:
                    storage_class_specifier declaration_specifier
                    {

                    }
                    |storage_class_specifier
                    {

                    }
                    |type_specifier declaration_specifier
                    {

                    }
                    |type_specifier
                    {

                    }
                    |type_qualifier declaration_specifier
                    {

                    }
                    |type_qualifier
                    {

                    }
                    |function_specifier declaration_specifier
                    {

                    }
                    |function_specifier
                    {

                    }
                    ;
init_declarator_list:
                    init_declarator
                    {

                    }
                    |init_declarator_list ',' init_declarator
                    {

                    }
                    ;
init_declarator:
                    declarator
                    {
                        $$ = $1;
                    }
                    |declarator EQUAL initializer
                    {
                        if ($3->initial_value!="") $1->initial_value=$3->initial_value;
						emit ("EQUAL", $1->name, $3->name);
                    }
                    ;
storage_class_specifier:
                    EXTERN
                    {

                    }
                    |STATIC
                    {

                    }
                    |AUTO
                    {

                    }
                    |REGISTER
                    {

                    }
                    ;
type_specifier:
                    VOID
                    {
                        Type = "VOID";
                    }
                    |CHAR
                    {
                        Type = "CHAR";
                    }
                    |SHORT
                    {

                    }
                    |INT
                    {
                        Type = "INTEGER";
                    }
                    |LONG
                    {

                    }
                    |FLOAT
                    {

                    }
                    |DOUBLE
                    {
                        Type = "DOUBLE";
                    }
                    |SIGNED
                    {

                    }
                    |UNSIGNED
                    {

                    }
                    |BOOL
                    {

                    }
                    |COMPLEX
                    {

                    }
                    |IMAGINARY
                    {

                    }
                    |enum_specifier
                    {

                    }
                    ;
specifier_qualifier_list:
                    type_specifier specifier_qualifier_list
                    {

                    }
                    |type_specifier
                    {

                    }
                    |type_qualifier specifier_qualifier_list
                    {

                    }
                    |type_qualifier
                    {

                    }
                    ;
enum_specifier:
                    ENUM IDENTIFIER '{' enumerator_list '}'
                    {

                    }
                    |ENUM '{' enumerator_list '}'
                    {

                    }
                    |ENUM IDENTIFIER '{' enumerator_list ',' '}'
                    {

                    }
                    |ENUM '{' enumerator_list ',' '}'
                    {

                    }
                    |ENUM IDENTIFIER
                    {

                    }
                    ;
enumerator_list:
                    enumerator
                    {

                    }
                    |enumerator_list ',' enumerator
                    {

                    }
                    ;
enumerator:
                    enumeration_constant
                    {

                    }
                    |enumeration_constant EQUAL constant_expression
                    {

                    }
                    ;
enumeration_constant:
                    IDENTIFIER
                    {

                    }
                    ;
type_qualifier:
                    CONST
                    {

                    }
                    |RESTRICT
                    {

                    }
                    |VOLATILE
                    {

                    }
                    ;
function_specifier:
                    INLINE
                    {

                    }
                    ;
declarator:
                    pointer direct_declarator
                    {
                        symtype * t = $1;
						while (t->ptr !=NULL)
							t = t->ptr;
						t->ptr = $2->type;
						$$ = $2->update($1);
                    }
                    |direct_declarator
                    {

                    }
                    ;
direct_declarator:
                    IDENTIFIER
                    {
                        $$ = $1->update(new symtype(Type));
						currentSymbol = $$;
                    }
				    |'(' declarator ')'
                    {
						$$ = $2;
                    }
				    |direct_declarator '[' type_qualifier_list assignment_expression ']'
                    {

                    }
                    |direct_declarator '[' assignment_expression ']'
                    {
                        symtype * t = $1 -> type;
						symtype * prev = NULL;
						while (t->type == "ARR")
						{
							prev = t;
							t = t->ptr;
						}
						if (prev==NULL)
						{
							int temp = atoi($3->loc->initial_value.c_str());
							symtype* s = new symtype("ARR", $1->type, temp);
							$$ = $1->update(s);
						}
						else
						{
							prev->ptr =  new symtype("ARR", t, atoi($3->loc->initial_value.c_str()));
							$$ = $1->update ($1->type);
						}
                    }
                    |direct_declarator '[' ']'
                    {
                        symtype * t = $1 -> type;
						symtype * prev = NULL;
						while (t->type == "ARR")
						{
							prev = t;
							t = t->ptr;
						}
						if (prev==NULL)
						{
							symtype* s = new symtype("ARR", $1->type, 0);
							$$ = $1->update(s);
						}
						else
						{
							prev->ptr =  new symtype("ARR", t, 0);
							$$ = $1->update ($1->type);
						}
                    }
                    |direct_declarator '[' type_qualifier_list ']'
                    {

                    }
				    |direct_declarator '[' STATIC assignment_expression ']'
                    {

                    }
                    |direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
                    {

                    }
				    |direct_declarator '[' '*' ']'
                    {

                    }
                    |direct_declarator '[' type_qualifier_list '*' ']'
                    {

                    }
				    |direct_declarator '(' C parameter_type_list ')'
                    {
                        table->name = $1->name;

						if ($1->type->type !="VOID")
						{
							sym *s = table->lookup("return");
							s->update($1->type);
						}
						$1->nested=table;
						$1->category = "function";
						table->parent = globalTable;

						changeTable (globalTable);
						currentSymbol = $$;
                    }
				    |direct_declarator '('C ')'
                    {
                        table->name = $1->name;

						if ($1->type->type !="VOID")
						{
							sym *s = table->lookup("return");
							s->update($1->type);
						}
						$1->nested=table;
						$1->category = "function";
						table->parent = globalTable;
						changeTable (globalTable);
						currentSymbol = $$;
                    }
                    |direct_declarator '(' identifier_list ')'
                    {

                    }
				    ;
pointer:
                    '*' type_qualifier_list
                    {

                    }
                    |'*'
                    {
                        $$ = new symtype("PTR");
                    }
                    |'*' pointer
                    {
                        $$ = new symtype("PTR", $2);
                    }
                    |'*' type_qualifier_list pointer
                    {

                    }
                    ;
type_qualifier_list:
                    type_qualifier
                    {

                    }
                    |type_qualifier_list type_qualifier
                    {

                    }
                    ;
parameter_type_list:
                    parameter_list
                    {

                    }
                    |parameter_list ',' ELLIPSIS
                    {

                    }
                    ;
parameter_list:
                    parameter_declaration
                    {

                    }
                    |parameter_list ',' parameter_declaration
                    {

                    }
                    ;
parameter_declaration:
                    declaration_specifier declarator
                    {
                        $2->category = "param";
                    }
                    |declaration_specifier
                    {

                    }
                    ;
identifier_list:
                    IDENTIFIER
                    {

                    }
                    |identifier_list ',' IDENTIFIER
                    {

                    }
                    ;
type_name:
                    specifier_qualifier_list
                    {

                    }
                    ;
initializer:
                    assignment_expression
                    {
                        $$ = $1->loc;
                    }
                    |'{' initializer_list '}'
                    {

                    }
                    |'{' initializer_list ',' '}'
                    {

                    }
                    ;
initializer_list:
                    designation initializer
                    {

                    }
                    |initializer
                    {

                    }
                    |initializer_list ',' initializer
                    {

                    }
                    |initializer_list ',' designation initializer
                    {

                    }
                    ;
designation:
                    designator_list EQUAL
                    {

                    }
                    ;
designator_list:
                    designator
                    {

                    }
                    |designator_list designator
                    {

                    }
                    ;
designator:
                    '[' constant_expression ']'
                    {

                    }
                    |'.' IDENTIFIER
                    {

                    }
                    ;
statement:
                    labeled_statement
                    {

                    }
                    |compound_statement
                    {
                        $$ = $1;
                    }
                    |expression_statement
                    {
                        $$ = new statement();
						$$->nextlist = $1->nextlist;
                    }
                    |selection_statement
                    {
                        $$ = $1;
                    }
                    |iteration_statement
                    {
                        $$ = $1;
                    }
                    |jump_statement
                    {
                        $$ = $1;
                    }
                    ;
labeled_statement:
                    IDENTIFIER ':' statement
                    {
						$$ = new statement();
                    }
                    |CASE constant_expression ':' statement
                    {
						$$ = new statement();
                    }
                    |DEFAULT ':' statement
                    {
						$$ = new statement();
                    }
                    ;
compound_statement:
                    '{' block_item_list '}'
                    {
                        $$ = $2;
                    }
                    |'{' '}'
                    {
						$$ = new statement();
                    }
                    ;
block_item_list:
                    block_item
                    {
                        $$ = $1;
                    }
                    |block_item_list B block_item
                    {
                        $$=$3;
						backpatch ($1->nextlist, $2);
                    }
                    ;
block_item:
                    declaration
                    {
						$$ = new statement();
                    }
                    |statement
                    {
                        $$ = $1;
                    }
                    ;
expression_statement:
                    expression ';'
                    {
                        $$ = $1;
                    }
                    |';'
                    {
						$$ = new expr();
                    }
                    ;
selection_statement:
                    IF '(' expression A')' B statement A
				    {
						backpatch ($4->nextlist, nextinstr());
						convertInt2Bool($3);
						$$ = new statement();
						backpatch ($3->truelist, $6);
						list<int> temp = merge ($3->falselist, $7->nextlist);
						$$->nextlist = merge ($8->nextlist, temp);
				    }
				    |IF '(' expression A')' B  statement A ELSE B statement
				    {
					  	backpatch ($4->nextlist, nextinstr());
						convertInt2Bool($3);
						$$ = new statement();
						backpatch ($3->truelist, $6);
						backpatch ($3->falselist, $10);
						list<int> temp = merge ($7->nextlist, $8->nextlist);
						$$->nextlist = merge ($11->nextlist,temp);
					}
				    |SWITCH '(' expression ')' statement
                    {

                    }
				   ;

iteration_statement:
                    WHILE B '(' expression ')' B  statement
				    {
				  	    $$ = new statement();
						convertInt2Bool($4);
						backpatch($7->nextlist, $2);
						backpatch($4->truelist, $6);
						$$->nextlist = $4->falselist;

						stringstream strs;
	    				strs << $2;
	    				string temp_str = strs.str();
	    				char* intStr = (char*) temp_str.c_str();
						string str = string(intStr);
						emit ("GOTOOP", str);
				   	}
				    |DO B statement B WHILE '(' expression A')' ';'
				    {
					  	$$ = new statement();
						convertInt2Bool($7);
						backpatch ($7->truelist, $2);
						backpatch ($3->nextlist, $4);
						$$->nextlist = $7->falselist;
					}
				    |FOR '(' expression_statement B expression_statement B  expression A ')' B statement
				    {
					  	$$ = new statement();
						convertInt2Bool($5);

						backpatch ($5->truelist, $10);
						backpatch ($8->nextlist, $4);
						backpatch ($11->nextlist, $6);

						stringstream strs;
	    				strs << $6;
	    				string temp_str = strs.str();
	    				char* intStr = (char*) temp_str.c_str();
						string str = string(intStr);
						emit ("GOTOOP", str);
						$$->nextlist = $5->falselist;
					}
				    |FOR '(' declaration expression_statement expression ')' statement
                    {

                    }
				   ;
jump_statement:
                    GOTO IDENTIFIER ';'
                    {
						$$ = new statement();
                    }
                    |CONTINUE ';'
                    {
						$$ = new statement();
                    }
                    |BREAK ';'
                    {
						$$ = new statement();
                    }
                    |RETURN expression ';'
                    {
                        $$ = new statement();
						emit("RETURN",$2->loc->name);
                    }
                    |RETURN ';'
                    {
						$$ = new statement();
                        emit("RETURN","");
                    }
                    ;
translation_unit:
                    external_declaration
                    {

                    }
                    |translation_unit external_declaration
                    {

                    }
                    ;
external_declaration:
                    function_definition
                    {

                    }
                    |declaration
                    {

                    }
                    ;
function_definition:
                    declaration_specifier declarator declaration_list F compound_statement
                    {

                    }
				    |declaration_specifier declarator F compound_statement
				    {
						emit ("FUNCEND", table->name);
						table->parent = globalTable;
						changeTable (globalTable);
					}
				    ;
declaration_list:
                    declaration
					{

					}
                    |declaration_list declaration
					{

					}
                    ;
B: %empty
                    {
						$$ = nextinstr();
				    }
				    ;
A: %empty
                    {
                        $$  = new statement();
						$$->nextlist = makelist(nextinstr());
						emit ("GOTOOP","");
                    }
                    ;
F: %empty
                    {
                        if (currentSymbol->nested==NULL) changeTable(new symtable(""));
						else
						{
							changeTable (currentSymbol->nested);
							emit ("FUNC", table->name);
						}
                    }
                    ;
C: %empty
					{
						if (currentSymbol->nested==NULL) changeTable(new symtable(""));
						else
						{
							changeTable (currentSymbol->nested);
							emit ("FUNC", table->name);
						}
					}
%%
void yyerror(string s){
    cout << s << endl;
}
