

#include <stdio.h>
#include <ctype.h>


typedef struct _ListElement {
	int	elnum;
	double	elval;
} ListElement;


#include "y.tab.h"

extern int yylex();
extern int yyerror(char *) ;
extern void avisa(char *, char *) ;

extern int lineno ;
extern char *progname ;
extern int nterms ;

