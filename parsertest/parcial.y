%{
//incluimos librerias y cabeceras
#include<stdio.h>
#include<string.h>
#include<ctype.h>
char lexema[64];
void yyerror(char *);
%}

%token ID IGUAL NUMHEX MAS MENOS POR ENTRE PC INICIO FIN VAR PROG COMA MICHI LIB POINT RAIZ PD PI

%%
total: listalib programa;
listalib: library listalib | library;
library: LIB MICHI ID POINT ID MICHI;
programa: PROG ID pcoma VAR lista pcoma body;
lista: ID coma lista | ID;
body: ini asignaciones fin;
asignaciones: asignacion pcoma asignaciones | asignacion pcoma;
asignacion: ID equiv expresion;
expresion: RAIZ PI expresion PD | expresion suma RAIZ PI expresion PD | expresion resta RAIZ PI expresion PD;
expresion: RAIZ PI expresion PD resta expresion | RAIZ PI expresion PD suma expresion;
expresion: PI expresion PD | expresion suma PI expresion PD | PI expresion PD suma expresion ;
expresion: | expresion resta PI expresion PD | PI expresion PD resta expresion;
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
coma: COMA;

%%
//codigo, scanner, parser
void yyerror(char *mgs){
	printf("error: %s",mgs);
}

int ishex(char c){
	if( isdigit(c) || c == 'A' || c == 'B' || c == 'C' || c == 'D' || c == 'E' || c == 'F' ) return 1;
	return 0;
}

int yylex(){   //esto retorna un token es decir numeros
//analizador lexico hecho a mano
	char c;
	
	
	
	while(1){
		c=getchar();
		if(c=='\n') continue;
		if(isspace(c)) continue;
	 	if(c=='=') return IGUAL;
		if(c=='+') return MAS;
		if(c=='-') return MENOS;
		if(c=='*') return POR;
		if(c=='/') return ENTRE;
		if(c==';') return PC;
		if(c==',') return COMA;
		if(c == '#') return MICHI;
		if(c == '.') return POINT;
		if(c == ')') return PD;
		if(c == '(') return PI;
		
		if(c == 'I'){
			int i = 0;
			lexema[i++] = c;
			c = getchar();
			if(c == 'n'){
				lexema[i++] = c;
				c = getchar();
				if(c == 'i'){
					lexema[i++] = c;
					c = getchar();
					if(c == 'c'){
						lexema[i++] = c;
						c = getchar();
						if(c == 'i'){
							lexema[i++] = c;
							c = getchar();
							if(c == 'o'){
								lexema[i++] = c;
								return INICIO;
							}
						}
					}
				}
			}
		}
		
		if(c == 'P'){
			int i = 0;
			lexema[i++] = c;
			c = getchar();
			if(c == 'r'){
				lexema[i++] = c;
				c = getchar();
				if(c == 'o'){
					lexema[i++] = c;
					c = getchar();
					if(c == 'g'){
						lexema[i++] = c;
						c = getchar();
						if(c == 'r'){
							lexema[i++] = c;
							c = getchar();
							if(c == 'a'){
								lexema[i++] = c;
								c = getchar();
								if(c == 'm'){
									lexema[i++] = c;
									c = getchar();
									if(c == 'a'){
										lexema[i++] = c;
										return PROG;
									}
								}
							}
							
						}
					}
				}
			}
		}
		
		if(c == 'l'){
			int i = 0;
			lexema[i++] = c;
			c = getchar();
			if(c == 'i'){
				lexema[i++] = c;
				c = getchar();
				if(c == 'b'){
					lexema[i++] = c;
					c = getchar();
					if(c == 'r'){
						lexema[i++] = c;
						c = getchar();
						if(c == 'e'){
							lexema[i++] = c;
							c = getchar();
							if(c == 'r'){
								lexema[i++] = c;
								c = getchar();
								if(c == 'i'){
									lexema[i++] = c;
									c = getchar();
									if(c == 'a'){
										lexema[i++] = c;
										return LIB;
									}
								}
							}
							
						}
					}
				}
			}
		}
		
		if(c == 'F'){
			int i = 0;
			lexema[i++] = c;
			c = getchar();
			if(c == 'i'){
				lexema[i++] = c;
				c = getchar();
				if(c == 'n'){
					lexema[i++] = c;
					return FIN;
				}
			}
		}
		
		if(c == 'r'){
			int i = 0;
			lexema[i++] = c;
			c = getchar();
			if(c == 'a'){
				lexema[i++] = c;
				c = getchar();
				if(c == 'i'){
					lexema[i++] = c;
					c = getchar();
					if(c == 'z'){
						lexema[i++] = c;
						return RAIZ;
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
		
		if(ishex(c)){//verifica si es un nro. entero
			int i=0;
			do{
				lexema[i++]=c;
				c=getchar();
			}while(ishex(c));
		ungetc(c,stdin);//devuelve el caracter a la entrada estandar
		lexema[i]=0;
		return NUMHEX; // devuelve el token
		}
		
		/*if(isdigit(c)){//verifica si es un nro. entero
			int i=0;
			do{
				lexema[i++]=c;
				c=getchar();
			}while(isdigit(c));
		ungetc(c,stdin);//devuelve el caracter a la entrada estandar
		lexema[i]=0;
		return NUM; // devuelve el token
		}*/
		
		
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

