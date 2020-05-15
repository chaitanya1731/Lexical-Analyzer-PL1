%{
#include <stdio.h>
#include "calc.tab.h"
int line = 1;
%}

digit	([0-9])
variables [a-zA-Z][a-zA-Z0-9]*
errVariables [0-9a-z]*
substractionErr [-]
divisionErr [/]
%%

"main"  { 	return (TOK_MAIN);  	}
"print" { 	return(TOK_PRINTLN);	}
"="	{	return(TOK_EQUAL);	}
";"	{	return(TOK_SEMICOLON);	}
"("	{	return(TOK_ROUNDOPEN);	}
")"	{	return(TOK_ROUNDCLOSE);	}
"{"	{	return(TOK_CURLYOPEN);	}
"}"	{	return(TOK_CURLYCLOSE);	}
"+"	{	return(TOK_ADD);	}	
"(-" 	{	return(TOK_NEGATIVE); 	}
"*"	{	return(TOK_MUL);	}
[\n]		line++;
[ \t\r]+  	{  }

{digit}+ {
	sscanf(yytext, "%d", &(yylval.int_val));
	return (TOK_NUM);
}

{variables}  {	
	sscanf(yytext, "%s", yylval.var_val);
	return (TOK_ID); 
}

{errVariables} {
	printf("Lexical error: %s \n",yytext); 
	return(yytext[0]);
}

{substractionErr} {	
	printf("Lexical Error: %c", yytext[0]);
	return(yytext[0]);	
}

{divisionErr} {	
	printf("Lexical Error: %c", yytext[0]);
	return(yytext[0]);	
}

.	{
	printf("Invalid character '%c', ignored\n", yytext[0]);
	return (yytext[0]);
}

%%
