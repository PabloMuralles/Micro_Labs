.386
.model		flat, stdcall ; stdcall convencion de paso de parametros es un orden, parametros al api del windows

;option
option	casemap:none ; convencion para mapear caracteres, y se utliza por windows.inc, se le pasa de parametro none

;include 
INCLUDE	\masm32\include\windows.inc
include	\masm32\include\kernel32.inc 
include	\masm32\include\masm32.inc 
include	\masm32\include\masm32rt.inc 

.data		; se usa para variable inicializadas 

	text1 DB	"Ingrese cadena 1",0
	text2 DB	"Ingrese cadena 2",0
	textresultado DB	"Resultado:",0
	cadena1 DB 100 dup(0),0 
	cadena2 DB 100 dup(0),0
	cero DB	0,0
	cantidad DB	0,0

.data?	; se usa para variables no inicializada
	   

.const	; valores que no van a cambiar

.code	

programa:

	;imprimir la instruccion para el usuario
	INVOKE	StdOut, ADDR	text1
	print chr$(13,10)
	INVOKE	StdIn, ADDR	cadena1,100d

	INVOKE	StdOut, ADDR	text2
	print chr$(13,10)
	INVOKE	StdIn, ADDR	cadena2,100d

	call COMPARAR	
	INVOKE	StdOut, ADDR	textresultado
	xor ax, ax
	mov al, cantidad
	print str$(ax),13d,10d	

	;finalizar 
	termina:
	INVOKE	ExitProcess,0
		

	COMPARAR PROC
		xor bx,bx			;limpiar registros
		xor ax,ax
		lea edi,cadena1		;iniciar la los indices
		lea esi,cadena2		

		recorrido:
			mov bl,[edi]	;pasar a un registro lo que tenga la cadena en esa posicion
			mov al,[esi]	
			inc edi			;incrementar los indices para comparar si se llego al final de la cadena en el caso que no casen los caracteres de las cadenas
			inc esi	
			cmp al,bl		;comparar el contenido de los indices para ver si son iguales si lo son es que tiene algo en comun y se repite el ciclo para ver si se encuentra todos 
			je recorrido
			lea edi, cadena1  ;se reinicia la cadena porque se pruba siempre desde el inicio cuando las letras no coinciden
			cmp al,cero		; comparar si la cadena 2 llego al final si si salir
			je salir
			cmp bl,cero		;se verifia si la cadena 1 llego al final si llwgo es que existe una coincidencia sino es que no caso con nada y se sigue comaparando con lo demas
			je incrementar
			jmp recorrido


		incrementar:
			inc cantidad	;si se encuentra la mismos caracteres en la cadena dos se incrementa en 1 la cantidad de concidencias
			dec esi			;se decrementa esi debido a que se incrementa antes para validar si se encuentra el final de la cadena o no 
			jmp recorrido

		salir:
		
	RET
	COMPARAR ENDP
	

end programa