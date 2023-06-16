%{
#include <ctype.h>
#include <stdio.h>
#define YYSTYPE double /* double type for YACC stack */
void yyerror(char *);
%}

%token NUMBER

%%
prog: expr '\n'   prog { printf("VALOR %g\n",$1);  };
prog:  ;
expr: expr '+'  term	{ $$ = $1 + $3; }		
	| term {$$=$1;}
    | expr '-' term     { $$ = $1 - $3; };
term: term '*' simb		{ $$ = $1 * $3; }
	| simb {$$=$1;};
simb: simb '/' num 	{ $$ = $1 / $3; }
	| num {$$ = $1;};

num: NUMBER;
%%

void yyerror(char *mgs){
	printf("error: %s",mgs);
}
int yylex(void)
{ double t;
	int c;
	while ((c = getchar()) == ' ');
	if (c == '.' || isdigit(c)) {
		ungetc(c, stdin);
		scanf("%lf", &t); yylval=t;// pasando valor a la pila
		return NUMBER;
	}
	return c;
}
int main(void)
{
	return yyparse();
}

