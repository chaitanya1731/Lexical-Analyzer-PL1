%{
#include <stdio.h>
#include <string.h>
extern int line;
int variableCounter = 0;

struct Table{
	char key[20];
	int value;
}symTable[100];

int yyerror();
int yylex();
int getValueFromVariable(char* key);
void assignValueToVariable(char* key,int value);

%}

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_NUM TOK_PRINTLN
%token TOK_MAIN TOK_ID TOK_EQUAL TOK_NEGATIVE
%token TOK_ROUNDOPEN TOK_ROUNDCLOSE TOK_CURLYOPEN TOK_CURLYCLOSE

%union{
    	int int_val;
	char var_val[20];
}

%type <int_val> expr TOK_NUM
%type <var_val> TOK_ID

%left TOK_ADD
%left TOK_MUL 
%left TOK_EQUAL
%left '{' '}'

%%

Prog: TOK_MAIN TOK_ROUNDOPEN TOK_ROUNDCLOSE TOK_CURLYOPEN stmt TOK_CURLYCLOSE
;

stmt: 
	| expr_stmt TOK_SEMICOLON stmt
;

expr_stmt:
	  TOK_ID TOK_EQUAL expr
	{
		assignValueToVariable($1, $3);    
	}
	| TOK_PRINTLN TOK_ID
        {
        	fprintf(stdout, "the value is %d\n", getValueFromVariable($2));
        }
	| TOK_PRINTLN expr
	{
		fprintf(stdout, "the value is %d\n", $2);
	}
	| TOK_ID TOK_MUL TOK_EQUAL expr
	{
		assignValueToVariable($1 ,getValueFromVariable($1) * $4);
	}	
	| TOK_ID TOK_ADD TOK_EQUAL expr
        {
		assignValueToVariable($1 ,getValueFromVariable($1) + $4);
        }
;


expr: 
	 TOK_NUM
	{ 	
		$$ = $1;
	}	 
	| expr TOK_MUL expr
	{
		$$ = $1 * $3;
	}
	| expr TOK_ADD expr
	{
		$$ = $1 + $3;
	}
	| TOK_ID
	{
		$$ = getValueFromVariable($1);
	}
	| TOK_NEGATIVE TOK_NUM TOK_ROUNDCLOSE
	{
		$$ = -$2;
	}
	| TOK_ROUNDOPEN expr TOK_ROUNDCLOSE
	{
		$$ = $2;
	}
;
%%

int yyerror(char *s) {
	//printf("syntax error\n");
	printf("Parsing Error: line %d\n",line);
	return 0;
}

int main() {
   yyparse();
   return 0;
}

int getValueFromVariable(char* key){
	for(int i = 0; i < variableCounter; i++){
		if(strcmp(symTable[i].key, key) == 0){
			return symTable[i].value;
		}
	}
	return 0;
}

void assignValueToVariable(char* key,int value){
	int ifExist = 0;
	int i = 0; 
	for(i = 0; i < variableCounter; i++){
		if(strcmp(symTable[i].key, key) == 0){
			symTable[i].value = value;
			ifExist = 1;
			break;				
		}
	}
	if(ifExist == 0){
		strcpy(symTable[i].key, key);
		symTable[i].value = value;
		variableCounter++;
	}
}
