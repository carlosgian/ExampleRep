%{
//incluimos librerias y cabeceras
#include<stdio.h>
#include<string.h>
char lexema[64];
void yyerror(char *);
%}

%token  ID ENT NUM HER CLASE

%%
expresion:ENT NUM;
expresion: CLASE ID;
expresion: CLASE ID HER ID;

%%
//codigo, scanner, parser
void yyerror(char *mgs){
	printf("error: %s",mgs);
}
int yylex(){   //esto retorna un token es decir numeros
//analizador lexico hecho a mano
	char c;
	while(1){
		c=getchar();
		if(c=='\n') continue;
		if(isspace(c)) continue;
	 	//if(c=='=') return IGUAL;
		//if(c=='+') return MAS;
		
		if(c == 'e'){
			int i = 0;
			lexema[i++] = c;
			c = getchar();
			if(c == 'n'){
				lexema[i++] = c;
				c = getchar();
				if(c == 't'){
					lexema[i++] = c;
					return ENT;
				}
			}
		}
		
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
		
		if(c == 'h'){
			int i = 0;
			lexema[i++] = c;
			c = getchar();
			if(c == 'e'){
				lexema[i++] = c;
				c = getchar();
				if(c == 'r'){
					lexema[i++] = c;
					return HER;
				}
			}
		}
		
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

