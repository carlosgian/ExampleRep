%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
char lexema[60];
void yyerror(char *);
int yylex();
typedef struct{
	char nombre[60];
	double valor;
	int token;
}tipoTS;
tipoTS TablaSim[100];
int nSim=0;//fila de la tabla de símbolo
typedef struct{
	int op;
	int a1;
	int a2;
	int a3;
}tipoCodigo;
tipoCodigo TCodigo[100];
int cx=-1; //fila de la tabla de tabla de código
void generaCodigo(int,int,int,int);//llena la tabla de código
int localizaSimb(char *,int);//llena la tabla de símbolos
void imprimeTablaSim();
void imprimeTablaCod();
int GenVarTemp();//genera variables temporales
int nVarTemp=0;
void interpretaCodigo();//recorre la tabla de código para actualizar la tabla de símbolos
int esPalabraReservada(char lexema[]);
%}

//%token PROGRAMA ID INICIO FIN NUM ASIGNAR SUMAR RESTAR MULTIPLICAR DIVIDIR SI ENTONCES MAYOR SALTARF
%token CLASE INICIO FIN ID IGUAL VAR NUM MAS MENOS POR ENTRE PCOMA COMA PI PD CI CD HEREDA RETURN  ASIGNAR SUMAR RESTAR MULTIPLICAR DIVIDIR SI SINO ENTONCES MAYOR MENOR SALTARF

/*
Program MiProg;
Begin
	x:=5;
	y:=6;
	if y>x then
		Begin
			a:=2;
			b:=3;
		End
	z:=6;
End.
*/
%%
/*
S: PROGRAMA ID ';' INICIO listaInstr FIN '.';
listaInstr: instr listaInstr| ;
instr: SI cond {generaCodigo(SALTARF,$2,'?','-');$$=cx;} ENTONCES bloque{TCodigo[$3].a2=cx+1;};
bloque: INICIO listaInstr FIN|instr;
instr: ID {$$=localizaSimb(lexema,ID);}':''=' expr{generaCodigo(ASIGNAR,$2,$5,'-');} ';';
cond: expr'>'expr  {int i=GenVarTemp(); generaCodigo(MAYOR,i,$1,$3);$$=i;}; 
expr: expr '+' term {int i=GenVarTemp(); generaCodigo(SUMAR,i,$1,$3);$$=i;};
expr: expr '-' term {int i=GenVarTemp(); generaCodigo(RESTAR,i,$1,$3);$$=i;};
expr: term;
term: term '*' factor {int i=GenVarTemp(); generaCodigo(MULTIPLICAR,i,$1,$3);$$=i;};
term: term '/' factor {int i=GenVarTemp(); generaCodigo(DIVIDIR,i,$1,$3);$$=i;};
term: factor;
factor: NUM {$$=localizaSimb(lexema,NUM);}|ID{$$=localizaSimb(lexema,ID);};
*/

programa: /* listaclases claseprincipal | */ listaclases;
listaclases: clase listaclases |;
clase: CLASE ID CI listaatributos constructor listametodos CD | CLASE ID HEREDA ID CI listaatributos constructor listametodos CD;
listaatributos: atributo listaatributos | ;
atributo: type ID PCOMA;
constructor: ID PI listavar PD CI listainicializacion CD;
listavar: type ID COMA listavar | type ID | ;
listainicializacion: inicializacion listainicializacion |;
inicializacion: ID  IGUAL ID PCOMA;
listametodos: metodo listametodos | ;
metodo: type ID PI listavar PD CI asignaciones RETURN ID PCOMA CD;
asignaciones: asignacion asignaciones | ;

condicionIni: SI cond {generaCodigo(SALTARF,$2,'?','-');$$=cx;} ENTONCES bloque{TCodigo[$3].a2=cx+1;};
condicionesExt: condicionExt condicionesExt | ;
condicionExt: SINO cond {generaCodigo(SALTARF,$2,'?','-');$$=cx;} ENTONCES bloque{TCodigo[$3].a2=cx+1;};

asignacion: condicionIni condicionesExt;

bloque: INICIO asignaciones FIN;

asignacion: ID {$$=localizaSimb(lexema,ID);} IGUAL expresion {generaCodigo(ASIGNAR,$2,$4,'-');} PCOMA;

cond: expresion'>'expresion  {int i=GenVarTemp(); generaCodigo(MAYOR,i,$1,$3);$$=i;}; 
cond: expresion'<'expresion  {int i=GenVarTemp(); generaCodigo(MENOR,i,$1,$3);$$=i;}; 

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
	char t[20];
	sprintf(t,"_T%d",nVarTemp++);
	return localizaSimb(t,ID);
}

void generaCodigo(int op,int a1,int a2, int a3){
	cx++;
	TCodigo[cx].op=op;
	TCodigo[cx].a1=a1;
	TCodigo[cx].a2=a2;
	TCodigo[cx].a3=a3;
}

int localizaSimb(char *nom, int tok){
	int i;
	for(i=0;i<nSim;i++){
		if(!strcasecmp(TablaSim[i].nombre,nom))
			return i;	
	}
	strcpy(TablaSim[nSim].nombre,nom);
	TablaSim[nSim].token=tok;
	if(tok=ID) TablaSim[nSim].valor=0.0;
	if(tok=NUM) sscanf(nom,"%lf",&TablaSim[nSim].valor);
	nSim++;
	return nSim-1;
}

void imprimeTablaSim(){
	int i;
	for(i=0;i<nSim;i++)
	printf("%d nombre=%s tok=%d valor=%lf\n",i,TablaSim[i].nombre,TablaSim[i].token, TablaSim[i].valor);
}
void imprimeTablaCod(){
	int i;
	for(i=0;i<=cx;i++)
	printf("%d op=%d a1=%d a2=%d a3=%d\n",i,TCodigo[i].op, TCodigo[i].a1,TCodigo[i].a2, TCodigo[i].a3);
}

void interpretaCodigo(){
	int i,a1,a2,a3,op;
	for(i=0;i<=cx;i++){
		op=TCodigo[i].op;
		a1=TCodigo[i].a1;
		a2=TCodigo[i].a2;
		a3=TCodigo[i].a3;
		if(op==ASIGNAR)
			TablaSim[a1].valor=TablaSim[a2].valor;
		if(op==SUMAR)
			TablaSim[a1].valor=TablaSim[a2].valor+TablaSim[a3].valor;
		if(op==RESTAR)
			TablaSim[a1].valor=TablaSim[a2].valor-TablaSim[a3].valor;
		if(op==MULTIPLICAR)
			TablaSim[a1].valor=TablaSim[a2].valor*TablaSim[a3].valor;
		if(op==DIVIDIR)
			TablaSim[a1].valor=TablaSim[a2].valor/TablaSim[a3].valor;
		if(op==MAYOR)
			if(TablaSim[a2].valor>TablaSim[a3].valor)
				TablaSim[a1].valor=1;
			else 
				TablaSim[a1].valor=0;
		if(op==MENOR)
			if(TablaSim[a2].valor<TablaSim[a3].valor)
				TablaSim[a1].valor=1;
			else 
				TablaSim[a1].valor=0;
		if(op==SALTARF)
			if(TablaSim[a1].valor==0)
				i=a2-1;
	}
}
void yyerror(char *msg){
	printf("Error: %s\n",msg);
}

int esPalabraReservada(char lexema[]){
	if (strcasecmp(lexema,"clase")==0) return CLASE;
	if (strcasecmp(lexema,"var")==0) return VAR;
	if (strcasecmp(lexema,"her")==0) return HEREDA;
	if (strcasecmp(lexema,"return")==0) return RETURN;
	if(strcasecmp(lexema,"inicio")==0) return INICIO;
	if(strcasecmp(lexema,"fin")==0) return FIN;
	if(strcasecmp(lexema,"si")==0) return SI;
	if(strcasecmp(lexema,"sino")==0) return SINO;
	if(strcasecmp(lexema,"entonces")==0) return ENTONCES;
	return ID;
}
int yylex(){
	char c;
	int i;
	while(1){
		c=getchar();
		if(c==' ') continue;
		if(c=='\t')continue;
		if(c=='\n')continue;
		
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
		
		if(isdigit(c)){
			i=0;
			do{
				lexema[i++]=c;
				c=getchar();
			}while(isdigit(c));
			ungetc(c,stdin);
			lexema[i]='\0';
			return NUM;
		}
		if(isalpha(c)){
			i=0;
			do{
				lexema[i++]=c;
				c=getchar();
			}while(isalnum(c));
			ungetc(c,stdin);
			lexema[i]='\0';
			return esPalabraReservada(lexema);
		}
		return c;

	}

}
int main(){
	if(!yyparse()) printf("Cadena valida\n");
	else printf("Cadena invalida\n");
	printf("Tabla de simbolos\n");
	imprimeTablaSim();
	printf("Tabla de codigos\n");
	imprimeTablaCod();
	printf("Interpreta codigo\n");
	interpretaCodigo();
	imprimeTablaSim();
}
