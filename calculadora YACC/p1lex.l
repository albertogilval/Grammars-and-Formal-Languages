%{
/*
 * TENGO QUE INCLUIR LA DEFINICIÓN DE LOS MACROS QUE REPRESENTAN
 * LOS tokens.
 */
#include "p1.h"
%}

%%
[0-9][0-9]*\.[0-9][0-9]*	{ sscanf(yytext, "%lf", &yylval.dval.elval) ;
				  return REALNUM ; }


(\ |\t)*(,|;)(\ |\t)*				{ return RSEP ; }

\n				{ lineno++; return RSEP ; }

.				{ return (int) yytext[0] ; }
