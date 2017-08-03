%start prog

%{
#include "p1.h"
%}

%union {
		ListElement	dval ;
       }

%token <dval> REALNUM
%token RSEP

%type  <dval> prog lines expr

%left '+' '-'
%left '*' '/'
%left '^'
%left 'c'
%%
prog	: lines
	{
		if ($1.elnum)
		   printf("RESULT=%g\n", $$.elval = ($1.elval / $1.elnum) ) ;
		else
		   printf("RESULT=--NO DEFINIDA. LISTA VACÍA--\n") ;
	}
	;

lines 	: 
	{
		$$.elval = 0.0 ; $$.elnum = 0 ;
	//	printf("[--]:%g\n", $$.elval);
	} /* empty */
	| lines expr RSEP
	{
		$$.elval = $1.elval + $2.elval ;
		$$.elnum = $1.elnum + 1 ;
	//	printf("[%g(%d)]:%g\n", $2.elval, $$.elnum, $$.elval);
	}
	;

expr	: REALNUM
	{
		$$.elval = $1.elval;
	} 
	| expr '^' expr
	{
		$$.elval = pow($1.elval, $3.elval);
	}
	| expr '*' expr
	{
		$$.elval = $1.elval * $3.elval;
	}
	| expr '/' expr
	{
		$$.elval = $1.elval / $3.elval;
	}
	| expr '+' expr
	{
		$$.elval = $1.elval + $3.elval ;
	}
	| expr '-' expr
	{
		$$.elval = $1.elval - $3.elval;
	}
	| expr '^' expr
	{
		$$.elval = pow($1.elval,$3.elval);
	}
	| 'c' expr
	{
		$$.elval = -1*$2.elval;
	}
	;
%%

char	*progname = NULL ;
int	lineno = 0 ;

int main(int argc, char *argv[]) {

	printf("calculadora\n");
	progname = argv[0];
	lineno = 1 ;

	yyparse();
}


int yyerror(char *s) {
	avisa(s, (char *) 0);
}

void avisa(char *s, char *t) {
	fprintf(stderr, "[%s]-ERROR: %s", progname, s);
	if (t)
		fprintf(stderr, " %s", t);
	fprintf(stderr, " cerca de la línea %d\n", lineno);
}

