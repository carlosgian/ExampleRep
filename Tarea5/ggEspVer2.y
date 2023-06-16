%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char lexema[60];
void yyerror(char *msg);
typedef struct{char nombre[60];double valor;int token;}tipoTS;
tipoTS TablaSim[100];
int nSim=0;
typedef struct{int op;int a1;int  a2;int a3;}tipoCodigo;
int cx=-1;
tipoCodigo TCodigo[100];
void generaCodigo(int ,int ,int ,int);
int localizaSimb(char *,int );
void imprimeTablaSim();
void imprimeTablaCod();
int nVarTemp=0;
int GenVarTemp();
%}

%token CLASE /*PRINCIPAL*/ ID IGUAL VAR NUM MAS MENOS POR ENTRE PCOMA COMA PI PD CI CD HEREDA RETURN  ASIGNAR SUMAR RESTAR MULTIPLICAR DIVIDIR

%%

programa: /* listaclases claseprincipal | */ listaclases;
listaclases: clase listaclases | clase;
clase: CLASE ID CI listaatributos constructor listametodos CD | CLASE ID HEREDA ID CI listaatributos constructor listametodos CD;
listaatributos: atributo PCOMA listaatributos | atributo PCOMA;
atributo: type ID;
constructor: ID PI listavar PD CI listainicializacion CD;
listavar: type ID COMA listavar | type ID | ;
listainicializacion: inicializacion PCOMA listainicializacion | inicializacion PCOMA;
inicializacion: ID  IGUAL ID;
listametodos: metodo listametodos | metodo | ;
metodo: type ID PI listavar PD CI asignaciones RETURN ID PCOMA CD;
asignaciones: asignacion asignaciones | asignacion ;

asignacion: ID {$$=localizaSimb(lexema,ID);} IGUAL expresion PCOMA | ;
expresion:    expresion MAS termino {int i=GenVarTemp();generaCodigo(SUMAR,i,$1,$3);$$=i;}
			| expresion MENOS termino {int i=GenVarTemp();generaCodigo(RESTAR,i,$1,$3);$$=i;}
			| termino ;
termino:      termino POR factor {int i=GenVarTemp();generaCodigo(MULTIPLICAR,i,$1,$3);$$=i;}
			| termino ENTRE factor {int i=GenVarTemp();generaCodigo(DIVIDIR,i,$1,$3);$$=i;} 
			| factor;
factor: NUM {$$=localizaSimb(lexema,NUM);} | ID {$$=localizaSimb(lexema,ID);} | PI expresion PD;

type: VAR;

%%

int GenVarTemp(){
	char t[60];
	sprintf(t,"_T%d",nVarTemp++);
	return localizaSimb(t,ID);
}
void generaCodigo(int op,int a1,int a2,int a3){
	cx++;	
	TCodigo[cx].op=op;
	TCodigo[cx].a1=a1;
	TCodigo[cx].a2=a2;
	TCodigo[cx].a3=a3;
}

int localizaSimb(char *nom,int tok){
	int i;
	for (i=0;i<nSim;i++){
		if(!strcasecmp(TablaSim[i].nombre,nom)) 
			return i;
	}
	strcpy(TablaSim[nSim].nombre,nom);
	TablaSim[nSim].token=tok;
	if (tok==ID) TablaSim[nSim].valor=0.0;
	if (tok==NUM) sscanf(nom,"%lf",&TablaSim[nSim].valor);
	nSim++;
	return nSim-1; 
}
void imprimeTablaSim(){
	int i;
	for ( i=0;i<nSim;i++){
		printf("%d  nombre=%s tok=%d valor=%lf\n",i,TablaSim[i].nombre,TablaSim[i].token,TablaSim[i].valor);
	}
}
void imprimeTablaCod(){
	int i;
	for ( i=0;i<=cx;i++){
		printf("%d  a1=%d a2=%d a3=%d\n",TCodigo[i].op,TCodigo[i].a1,TCodigo[i].a2,TCodigo[i].a3);
	}
}

void yyerror(char *msg){
	printf("ERROR:%s\n",msg);
}
int EsPalabraReservada(char lexema[]){
	//strcmp considera may y minusc
	//strcasecmp ignora may de min
	if (strcasecmp(lexema,"clase")==0) return CLASE;
	if (strcasecmp(lexema,"var")==0) return VAR;
	if (strcasecmp(lexema,"her")==0) return HEREDA;
	if (strcasecmp(lexema,"return")==0) return RETURN;
	return ID;

}
int yylex(){
	char c;int i;
	while(1){
	    c=getchar();
	    if(c==' ') continue;
	    if(c=='\t') continue;
	    if(c=='\n') continue;
		if(isspace(c)) continue;
		
		if(c == ';') return PCOMA;
	 	if(c=='=') return IGUAL;
		if(c=='+') return MAS;
		if(c=='-') return MENOS;
		if(c=='*') return POR;
		if(c=='/') return ENTRE;
		if(c==',') return COMA;
		if(c == '(') return PI;
		if(c == ')') return PD;
		if(c == '{') return CI;
		if(c == '}') return CD;
		 
	     if (isdigit(c)){
	         i=0;
	         do{
	      	 	lexema[i++]=c;
			c=getchar();			
   	         }while(isdigit(c));
		 ungetc(c,stdin);
		 lexema[i]='\0';
		 //lexema[i]=0;
		 return NUM;
		 	
	     }		
	     if (isalpha(c)){
	         i=0;
	         do{
	      	 	lexema[i++]=c;
			c=getchar();			
   	         }while(isalnum(c));
		 ungetc(c,stdin);
		 lexema[i]='\0';
		 //lexema[i]=0;
		 return EsPalabraReservada(lexema);
		 	
	     }		
	     return c; 
	}
}
int main(){
	if (!yyparse()) printf("La cadena es valida\n");
	else 
		printf("La cadena es invalida\n");
	printf("tabla de simbolos\n");
	imprimeTablaSim();
	printf("tabla de codigos\n");
	imprimeTablaCod();

}


