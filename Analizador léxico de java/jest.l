%{

int	nflo ;	/* Numero de ficheros en línea de órdenes */
int	nfa ;	/* Número de fichero actualmente en uso */
char	**avg;	/* av[1..na]	*/

int	nrow;
int	ncol ;	/* Número de columna (carácter dentro de línea) */

%}

%S	CMNM
%S	CMNC
%S 	CLASSN
%S 	CLASS
%S 	ATTRIBUTE
%S	METHODN
%S	METHOD
%S	VAR

alfanum	[A-Za-z]([A-Za-z]|[0-9])*
nombre	($|_|[A-Za-z])($|_|[A-Za-z]|[0-9])*
tipo	{nombre}
clasn	{nombre}([ |\t])*
class	((public|private)[ |\t]+)?(class)[ |\t]+
attrn	[A-Za-z]+[ |\t]*;
attr	(public|protected|private)?[ |\t]+{tipo}[ |\t]+{nombre}[ |\t]*;
llavea	"{"
llavec	"}"
param	[ |\t]*{tipo}[ |\t]+{nombre}
method	(public|protected|private)?[ |\t]+{tipo}[ |\t]+{nombre}[ |\t]*"("({param}(","{param})*)?")"
tipob	(char|short|int|long|float|double)
tipoc	(((signed|unsigned)[ ])?{tipob}

%%

"//".*			{;}
"/*"([^"*/"]|\n)*"*/"		{
			int i;
			int len = strlen(yytext);
			for(i=0;i<=len;i++){

				if(yytext[i]==10){
					nrow ++;
					ncol = 0;
				}
				ncol++;
			}
			}

{class}{clasn} 		{
			printf("-Class: %s, ROW: %d, COL : %d\n",yytext ,nrow, ncol);
			ncol += strlen(yytext);
			BEGIN CLASSN ;
			}

<CLASSN>{
	
	{llavea}	{
			ncol += strlen(yytext);
			BEGIN CLASS;}
}

<CLASS>{
	
	{attr} 		{
			printf("	-Attr: %s, ROW: %d, COL: %d\n",yytext, nrow, ncol);
			}

	{llavec}	{
			printf("fin de class\n");
			ncol += strlen(yytext);
			BEGIN 0;
			}

	{method}	{
			printf("	-Method: %s, ROW: %d, COL: %d\n",yytext, nrow, ncol);
			ncol += strlen(yytext);
			BEGIN METHODN;
			}

	
}



<METHODN>{

	{llavea}	{
			ncol += strlen(yytext);
			BEGIN METHOD;
			}
}

<METHOD>{
	
	{llavec}	{
			ncol += strlen(yytext);
			printf("	fin de metodo\n");
			BEGIN CLASS;
			}

	[ |\t]*{tipo}		{
			ncol += strlen(yytext);
			BEGIN VAR;
			}

}

<VAR>{
	
	[ |\t]+{nombre}		{
			printf("		VAR: %s, ROW %d, COL: %d\n",yytext, nrow, ncol);
			ncol += strlen(yytext);
			}


	";"		{
			ncol += strlen(yytext);
			BEGIN METHOD;
			}
}

[^ \t\n]+		{
			ncol += strlen(yytext);
			}

.			{
			ncol += strlen(yytext);
			}

\n			{
			nrow ++;
			ncol = 0;
			}
%%


int main(int na, char *av[]) {

	int	i;

	ncol = nrow = 0 ;

	nflo = na - 1 ;
	avg = (char **) malloc(nflo * sizeof(char *)) ;
 	for (i=1 ; i<na ; i++) { 
			avg[i-1] = strdup(av[i]) ; 
	}

	if(nflo >=1){
	nfa = 0 ;
	int correct = 1;
	while(correct == 1){

		while((strcmp(strrchr(avg[nfa],'.'),".java"))!=0){

			nfa++;
			if(nfa>=nflo) { return 1;}
		}
		
		yyin = fopen(avg[nfa], "r");
		if(yyin == NULL){

			printf("archivo: %s no encontrado\n",avg[nfa]);
			nfa++;
			if(nfa >=nflo) {return 1;}
		}else{

			fprintf(stdout, "archivo %s actualmente en uso\n", avg[nfa]), fflush(stdout);
			correct = 0;
		}
	}
	}else{
		yyin = fopen(av[1], "r");
	}

	yylex();

}

int yywrap(void) {

	
    fclose(yyin) ;

     ncol = nrow = 0 ;

    if (nfa >= nflo) return 1;
    yyin=fopen(avg[nfa++], "r") ;
    return 0;
}
