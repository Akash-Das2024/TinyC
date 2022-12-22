%{
#include "ass6_20CS10006_translator.h"
#include <stdio.h>
#include <string.h>
#include "ass6_20CS10006.tab.h"
%}

%option noyywrap

WS                              [ \t\n]+
LETTER                          [_a-zA-Z]
DIGIT                           [0-9]
NON_ZERO_DIGIT                  [1-9]
ZERO                            "0"
ID                              {LETTER}({LETTER}|{DIGIT})*
SIGN                            "+"|"-"
INTEGER_CONSTANT                {ZERO}|({NON_ZERO_DIGIT}({DIGIT})*)
DIGIT_SEQUENCE                  {DIGIT}+
FRACTIONAL_CONSTANT             {DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE}|{DIGIT_SEQUENCE}"."
EXPONENT_SEQUENCE               ("e"|"E")({SIGN}?){DIGIT_SEQUENCE}
FLOATING_CONSTANT               {FRACTIONAL_CONSTANT}({EXPONENT_SEQUENCE}?)|{DIGIT_SEQUENCE}{EXPONENT_SEQUENCE}
ESCAPE_SEQUENCE                 "\\\'"|"\\\""|"\\\?"|"\\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"
C_CHAR                          {ESCAPE_SEQUENCE}|[^\'\\\n]
C_CHAR_SEQUENCE                 {C_CHAR}+
CHAR_CONSTANT                   '{C_CHAR_SEQUENCE}'
S_CHAR                          {ESCAPE_SEQUENCE}|[^\"\\\n]
S_CHAR_SEQUENCE                 {S_CHAR}+
STRING_LITERAL                  \"({S_CHAR_SEQUENCE}?)\"
PUNCTUATOR			            "["|"]"|"."|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"("|")"|"{"|"}"|"%"|","|"<"|">"|"^"|"|"|"?"|":"|";"|"#"
SINGLE_LINE_COMMENT             ["/"]["/"][^\n]*
END_COMMENT                     ["*"]["/"]
START_COMMENT                   ["/"]["*"]
CONTENT                         [^*]|[*][^/]
MULTI_LINE_COMMENT              {START_COMMENT}{CONTENT}*{END_COMMENT}

%%
"auto"				    {printf("TOKEN: AUTO\n");   return AUTO;}
"break"				    {printf("TOKEN: BREAK\n");   return BREAK;}
"case"				    {printf("TOKEN: CASE\n");   return CASE;}
"char"				    {printf("TOKEN: CHAR\n");   return CHAR;}
"const"				    {printf("TOKEN: CONST\n");   return CONST;}
"continue"			    {printf("TOKEN: CONTINUE\n");   return CONTINUE;}
"default"			    {printf("TOKEN: DEFAULT\n");   return DEFAULT;}
"do"				    {printf("TOKEN: DO\n");   return DO;}
"double"			    {printf("TOKEN: DOUBLE\n");   return DOUBLE;}
"else"				    {printf("TOKEN: ELSE\n");   return ELSE;}
"enum"				    {printf("TOKEN: ENUM\n");   return ENUM;}
"extern"			    {printf("TOKEN: EXTERN\n");   return EXTERN;}
"float"				    {printf("TOKEN: FLOAT\n");   return FLOAT;}
"for"				    {printf("TOKEN: FOR\n");   return FOR;}
"goto"				    {printf("TOKEN: GOTO\n");   return GOTO;}
"if"				    {printf("TOKEN: IF\n");   return IF;}
"inline"			    {printf("TOKEN: INLINE\n");   return INLINE;}
"int"				    {printf("TOKEN: INT\n");   return INT;}
"long"				    {printf("TOKEN: LONG\n");   return LONG;}
"register"			    {printf("TOKEN: REGISTER\n");   return REGISTER;}
"restrict"			    {printf("TOKEN: RESTRICT\n");   return RESTRICT;}
"return"			    {printf("TOKEN: RETURN\n");   return RETURN;}
"short"				    {printf("TOKEN: SHORT\n");   return SHORT;}
"signed"			    {printf("TOKEN: SIGNED\n");   return SIGNED;}
"sizeof"		        {printf("TOKEN: SIZEOF\n");   return SIZEOF;}
"static"			    {printf("TOKEN: STATIC\n");   return STATIC;}
"struct"			    {printf("TOKEN: STRUCT\n");   return STRUCT;}
"switch"			    {printf("TOKEN: SWITCH\n");   return SWITCH;}
"typedef"			    {printf("TOKEN: TYPEDEF\n");   return TYPEDEF;}
"union"				    {printf("TOKEN: UNION\n");   return UNION;}
"unsigned"			    {printf("TOKEN: UNSIGNED\n");   return UNSIGNED;}
"void"				    {printf("TOKEN: VOID\n");   return VOID;}
"volatile"			    {printf("TOKEN: VOLATILE\n");   return VOLATILE;}
"while"				    {printf("TOKEN: WHILE\n");   return WHILE;}
"_Bool"				    {printf("TOKEN: BOOL\n");   return BOOL;}
"_Complex"			    {printf("TOKEN: COMPLEX\n");   return COMPLEX;}
"_Imaginary"		    {printf("TOKEN: IMAGINARY\n");   return IMAGINARY;}
"->"				    {printf("TOKEN: ARROW\n");   return ARROW;}
"++"				    {printf("TOKEN: INCREMENT\n");   return INCREMENT;}
"--"				    {printf("TOKEN: DECREMENT\n");   return DECREMENT;}
"<<"				    {printf("TOKEN: LEFT_SHIFT\n");   return LEFT_SHIFT;}
">>"				    {printf("TOKEN: RIGHT_SHIFT\n");   return RIGHT_SHIFT;}
"<"                     {printf("TOKEN: LESS_THAN\n");   return LESS_THAN;}
">"                     {printf("TOKEN: GREATER_THAN\n");   return GREATER_THAN;}
"<="				    {printf("TOKEN: LESS_THAN_EQUAL_TO\n");   return LESS_THAN_EQUAL_TO;}
">="				    {printf("TOKEN: GREATER_THAN_EQUAL_TO\n");   return GREATER_THAN_EQUAL_TO;}
"=="				    {printf("TOKEN: EQUAL_TO\n");   return EQUAL_TO;}
"!="				    {printf("TOKEN: NOT_EQUAL_TO\n");   return NOT_EQUAL_TO;}
"&&"				    {printf("TOKEN: LOGICAL_AND\n");   return LOGICAL_AND;}
"||"				    {printf("TOKEN: LOGICAL_OR\n");   return LOGICAL_OR;}
"..."				    {printf("TOKEN: ELLIPSIS\n");   return ELLIPSIS;}
"="                     {printf("TOKEN: EQUAL\n");   return EQUAL;}
"*="				    {printf("TOKEN: MUL_EQUAL\n");   return MUL_EQUAL;}
"/="				    {printf("TOKEN: DIV_EQUAL\n");   return DIV_EQUAL;}
"%="				    {printf("TOKEN: PERCENTILE_EQUAL\n");   return PERCENTILE_EQUAL;}
"+="				    {printf("TOKEN: PLUS_EQUAL\n");   return PLUS_EQUAL;}
"-="				    {printf("TOKEN: MINUS_EQUAL\n");   return MINUS_EQUAL;}
"<<="				    {printf("TOKEN: LEFT_SHIFT_EQUAL\n");   return LEFT_SHIFT_EQUAL;}
">>="				    {printf("TOKEN: RIGHT_SHIFT_EQUAL\n");   return RIGHT_SHIFT_EQUAL;}
"&="				    {printf("TOKEN: AND_EQUAL\n");   return AND_EQUAL;}
"^="				    {printf("TOKEN: XOR_EQUAL\n");   return XOR_EQUAL;}
"|="				    {printf("TOKEN: OR_EQUAL\n");   return OR_EQUAL;}
{ID}		            {yylval.symp = table->lookup(yytext);printf("TOKEN: IDENTIFIER\n");   return IDENTIFIER;}
{INTEGER_CONSTANT}		{yylval.intval = atoi(yytext);printf("TOKEN: INTEGER_CONSTANT\n");   return INTEGER_CONSTANT;}
{FLOATING_CONSTANT}	    {yylval.charval = yytext;printf("TOKEN: FLOATING_CONSTANT\n");   return FLOATING_CONSTANT;}
{CHAR_CONSTANT}	        {yylval.charval = yytext;printf("TOKEN: CHAR_CONSTANT\n");   return CHAR_CONSTANT;}
{STRING_LITERAL}	    {yylval.charval = yytext;printf("TOKEN: STRING_LITERAL\n");   return STRING_LITERAL;}
{PUNCTUATOR}            {printf("TOKEN: PUNCTUATOR: %s\n",yytext);   return yytext[0];}
{SINGLE_LINE_COMMENT}   {printf("SINGLE LINE COMMENT\n");}
{MULTI_LINE_COMMENT}	{printf("MULTI LINE COMMENT\n");}
{WS}				    {}
%%
