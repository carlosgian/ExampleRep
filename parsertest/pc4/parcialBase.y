/* EJEMPLO EJECUCION
clase Animal {
var vel;
var peso;
Animal(var vel, var peso,){
vel = 43;
peso = 32;
}
var calcvel(var vel,){
vel = 23 + 32;
}
var calcpeso(var peso, var vel,){
densidad = 23 - 23;
peso = 32 + 12*densidad;
}
}
*/


%{
//incluimos librerias y cabeceras
#include<stdio.h>
#include<string.h>
#include<ctype.h>
char lexema[64];
void yyerror(char *);
%}

%token CLASE /*PRINCIPAL*/ ID IGUAL VAR NUM MAS MENOS POR ENTRE PCOMA COMA PI PD CI CD HEREDA

%%
/*total: listalib programa;
listalib: library listalib | library;
library: LIB MICHI ID POINT ID MICHI;
programa: PROG ID pcoma VAR lista pcoma body;
lista: ID coma lista | ID
body: ini asignaciones fin;
asignaciones: asignacion pcoma asignaciones | asignacion pcoma;
asignacion: ID equiv expresion;
expresion: RAIZ PI expresion PD
expresion: PI expresion PD | expresion suma expresion | expresion resta expresion | expresion multi expresion
expresion: expresion suma termino;
expresion: expresion resta termino;
expresion: termino;
termino: PI termino PD | termino multi simbolo;
termino: simbolo;
simbolo: PI simbolo PD | simbolo divi NUMHEX;
ini: INICIO;
fin: FIN;
simbolo: NUMHEX | ID;
equiv: IGUAL;
suma: MAS;
resta: MENOS;
multi: POR;
divi: ENTRE;
pcoma: PC;
coma: COMA;*/

programa: /* listaclases claseprincipal | */ listaclases;
listaclases: clase listaclases | clase;
clase: CLASE ID CI listaatributos constructor listametodos CD | CLASE ID HEREDA ID CI listaatributos constructor listametodos CD;
listaatributos: atributo PCOMA listaatributos | atributo PCOMA;
atributo: type ID;
constructor: ID PI listavar PD CI listainicializacion CD;
listavar: type ID COMA listavar | type ID COMA;
listainicializacion: inicializacion PCOMA listainicializacion | inicializacion PCOMA;
inicializacion: ID IGUAL NUM;
listametodos: metodo listametodos | metodo;
metodo: type ID PI listavar PD CI asignaciones CD;
asignaciones: asignacion PCOMA asignaciones | asignacion PCOMA;
asignacion: ID IGUAL expresion;
expresion: expresion MAS termino | expresion MENOS termino | termino;
termino: termino POR factor | termino ENTRE factor | factor;
factor: NUM | ID | PI expresion PD;

//claseprincipal: ;
/*
claseprincipal: CLASE PRINCIPAL CI metodoprincipal CD;
metodoprincipal: VOID PRINCIPAL PI listaargs PD CI metodoprincipalcuerpo CD;
metodoprincipalcuerpo:  declaraciones operaciones llamadasmetodos RETORNAR valorretorno;
llamadasmetodos: llamadametodo llamadasmetodos | llamadametodo;
metodocuerpo:  declaraciones operaciones RETORNAR valorretorno;
declaraciones: declaracion declaraciones | declaracion;
operaciones: operacion operaciones | operacion;
valorretorno: ID | operacion;
*/

type: VAR;

%%
//codigo, scanner, parser
void yyerror(char *mgs){
	printf("error: %s",mgs);
}

/*int ishex(char c){
	if( isdigit(c) || c == 'A' || c == 'B' || c == 'C' || c == 'D' || c == 'E' || c == 'F' ) return 1;
	return 0;
}*/

int yylex(){   //esto retorna un token es decir numeros
//analizador lexico hecho a mano
	char c;
	while(1){
		c=getchar();
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
		if(c == 'c'){
			int i = 0;
			lexema[i++] = c;
			c = getchar();
			if(c == 'l'){
				lexema[i++] = c;
				c = getchar();
				if(c == 'a'){
					lexema[i++] = c;
					c = getchar();
					if(c == 's'){
						lexema[i++] = c;
						c = getchar();
						if(c == 'e'){
							lexema[i++] = c;
							return CLASE;
						}
					}
				}
			}
		}
		
		if(c == 'v'){
			int i = 0;
			lexema[i++] = c;
			c = getchar();
			if(c == 'a'){
				lexema[i++] = c;
				c = getchar();
				if(c == 'r'){
					lexema[i++] = c;
					return VAR;
				}
			}
		}
		
		if(c == 'h'){
			int i = 0;
			lexema[i++] = c;
			c = getchar();
			if(c == 'e'){
				lexema[i++] = c;
				c = getchar();
				if(c == 'r'){
					lexema[i++] = c;
					return HEREDA;
				}
			}
		}
		
		/*if(isalpha(c)){//verifica si es un caracter
			int i=0;
			do{
				lexema[i++]=c;
				c=getchar();
			}while(isalpha(c));
		ungetc(c,stdin);//devuelve el caracter a la entrada estandar
		lexema[i]=0;
		return NAME; // devuelve el token
		}*/
		
 		if(isalpha(c)){//verifica si es un caracter
			int i=0;
			do{
				lexema[i++]=c;
				c=getchar();
			}while(isalnum(c));
		ungetc(c,stdin);//devuelve el caracter a la entrada estandar
		lexema[i]=0;
		return ID; // devuelve el token
		}
		
		/*if(ishex(c)){//verifica si es un nro. entero
			int i=0;
			do{
				lexema[i++]=c;
				c=getchar();
			}while(ishex(c));
		ungetc(c,stdin);//devuelve el caracter a la entrada estandar
		lexema[i]=0;
		return NUMHEX; // devuelve el token
		}*/
		
		if(isdigit(c)){//verifica si es un nro. entero
			int i=0;
			do{
				lexema[i++]=c;
				c=getchar();
			}while(isdigit(c));
		ungetc(c,stdin);//devuelve el caracter a la entrada estandar
		lexema[i]=0;
		return NUM; // devuelve el token
		}
		
		
		return c;
	}
}
void main(){
//llamar al scaner o analizador lexico esto lo inicia el parser o analizador sintactico(yyparse)
//yyparse

	if(!yyparse())
		printf("cadena es valida\n");
	else
		printf("cadena invalida\n");
}

