#ifndef ASS6_20CS10006_TRANSLATOR
#define ASS6_20CS10006_TRANSLATOR
#include <bits/stdc++.h>
#define CHAR_SIZE          1
#define INT_SIZE           4
#define DOUBLE_SIZE        8
#define POINTER_SIZE       4

extern char *yytext;
extern int yyparse();

using namespace std;

class sym;
class quad;
class symtype;
class symtable;
class quadArray;
extern quadArray q;
extern symtable * table;
extern sym * currentSymbol;
extern symtable * globalTable;


class symtype
{	public:
	symtype(string type, symtype *ptr = NULL, int width = 1);
	string type;
	int width;
	symtype * ptr;
};

class quad
{
	public:
	string op;
	string result;
	string arg1;
	string arg2;

	void print();
	quad(string result, string arg1, string op = "EQUAL", string arg2 = "");
	quad(string result, int arg1, string op = "EQUAL", string arg2 = "");
	quad(string result, float arg1, string op = "EQUAL", string arg2 = "");
};

class quadArray
{
	public:
	vector<quad> Array;
	void print();
};


class sym
{
	public:
	string name;
	symtype * type;
	string initial_value;
	string category;
	int size;
	int offset;
	symtable * nested;

	sym(string name, string t = "INTEGER", symtype *ptr = NULL, int width = 0);
	sym* update(symtype *t);
	sym* link_to_symbolTable(symtable *t);
};


class symtable
{
	public:
	string name;
	int count;
	list<sym> table;
	symtable * parent;
	map<string, int> ar;
	symtable(string name = "NULL");
	sym* lookup(string name);
	void print();
	void update();
};


struct statement
{
	list<int> nextlist;
};


struct Array
{
	string cat;
	sym * loc;
	sym * Array;
	symtype * type;
};


struct expr
{
	string type;
	sym * loc;
	list<int> truelist;
	list<int> falselist;
	list<int> nextlist;
};

sym* gentemp(symtype *t, string init = "");
void emit(string op, string result, string arg1 = "", string arg2 = "");
void emit(string op, string result, int arg1, string arg2 = "");
void emit(string op, string result, float arg1, string arg2 = "");
void backpatch(list<int> lst, int i);
list<int> makelist(int i);
list<int> merge(list<int> &lst1, list<int> &lst2);
sym* conv(sym *, string);
bool typecheck(sym* &s1, sym* &s2);
bool typecheck(symtype *t1, symtype *t2);
expr* convertInt2Bool(expr*);
expr* convertBool2Int(expr*);
void changeTable(symtable *newtable);
int nextinstr();
int size_type(symtype*);
string print_type(symtype*);

#endif