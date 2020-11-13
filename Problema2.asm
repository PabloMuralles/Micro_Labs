 CalcularDimension MACRO	filas, columnas, dimension
	xor	bx,bx		;limpiar registros
	xor ax,ax

	mov bl, filas
	mov al, columnas
	mul bl
	mov dimension,al
	;el resultado se quedara en ax para despues imprimirlo

ENDM

Mapeo MACRO i, j, filas, columnas, tamano, resultado
	xor ax,ax			;limpiar registros
	xor cx,cx		
	;primera parte de la formula
	mov al,i			;pasar a ax el contador con la posicion de la fila que se desea saber
	mul columnas			;multiplicar ax por la cantidad de elementos que tiene una fila
	mul tamano			;mutiplicar ax por el tamaño de dato
	mov cl,al			;guardar el resultado en cl
	;segunda parte de la formula
	xor ax,ax			;limpiar registros
	
	mov al,j			;mover a al el contador de las columas con la posicion de la columna que se desea saber a
	mul tamano			;multiplicar al por el tamaño de los elementos 
	;resultado final
	add cl,al	
	mov resultado, cl
ENDM	


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

	text1 DB	"Ingrese N, solo numeros de un digito",0
	text2 DB	"Ingrese M, solo numeros de un digito",0
	text3 DB	"Ingrese data con la que desea llenar la matriz",0
	textDimension DB	"Tamano de la matriz:",0
	textMatriz DB	"Matriz:",0
	i DB 0,0
	j DB 0,0
	filas DB 0,0
	columnas DB	0,0
	dimension DB 0,0
	resultado DB 0,0
	temp DB 0,0
	largoDatos DB 1,0
	textoIngreso DB 500 dup(0),0
	matriz DB 500 dup(0),0

.data?	; se usa para variables no inicializada
	   

.const	; valores que no van a cambiar

.code	

programa:
LLENARMATRIZ PROC NEAR
	INVOKE	StdOut, ADDR	text1						;pedirle al usuario n
	print chr$(13,10)
	INVOKE	StdIn, ADDR	filas,50d

	INVOKE	StdOut, ADDR	text2						;pedir al usuario m
	print chr$(13,10)
	INVOKE	StdIn, ADDR	columnas,50d

	INVOKE	StdOut, ADDR	text3						;pedir al usuario m
	print chr$(13,10)
	INVOKE	StdIn, ADDR	textoIngreso,500d
 

	sub columnas, 30h									; obtener los valores originales de lo que inserto el usuario
	sub filas, 30h 

	CalcularDimension filas,columnas, dimension

	INVOKE	StdOut, ADDR	textDimension				;texto para el usuario
	xor ax,ax											;limpiar registros
	mov al,dimension									
	print str$(ax)										;imprimir registro donde se quedo el calculo del tamaño 

	lea esi,textoIngreso

	cicloFilas:
		 
		mov j,00h										;iniciar de nuevo el contador de columnas									
		
		cicloColumnas:

		Mapeo i, j, filas, columnas, largoDatos, resultado
		lea edi,matriz	

		call	AUMENTARINDICE

		;insertar en la matriz
		xor ebx,ebx
		mov bl,[esi]
		mov [edi],ebx

		inc esi

		inc j											; se incrementa el contador de columnas
		xor bx,bx										; se limpia el registros
		mov bl,j										; se pasa a bl el contador de columnas para poder comparar
		cmp bl,columnas									; se compara si el contador columnas llego al final  de las columnas
		jl cicloColumnas								; si es menor es que no ha llego al final y se repite el cilo columnas
		inc i											; si no es menor se incrementan la filaes 
		mov bl,i										; se mueve el contador filas a bl para comparar  
		cmp bl, filas									;se compara bl con la cantidad de filas para ver si se llego al final de las filas
		jl cicloFilas									; si es menor es que no a llegado y se repite el ciclo filas y si llego se sale
    
LLENARMATRIZ ENDP

print chr$(13,10)								;se imprime salto de linea
INVOKE	StdOut, ADDR	textMatriz 
call	IMPRIMIRMATRIZ	
jmp terminar	

IMPRIMIRMATRIZ PROC	
mov j,00h
mov i,00h

cicloRows:
		 
		mov j,00h										;iniciar de nuevo el contador de columnas									
		print chr$(13,10)								;se imprime salto de linea

		cicloColumns:

			Mapeo i, j, filas, columnas, largoDatos, resultado
			lea edi,matriz	

			call	 AUMENTARINDICE	

			call	IMPRIMIRPOS	
	


		inc j											; se incrementa el contador de columnas
		xor bx,bx										; se limpia el registros
		mov bl,j										; se pasa a bl el contador de columnas para poder comparar
		cmp bl,columnas									; se compara si el contador columnas llego al final  de las columnas
		jl cicloColumns								; si es menor es que no ha llego al final y se repite el cilo columnas
		inc i											; si no es menor se incrementan la filaes 
		mov bl,i										; se mueve el contador filas a bl para comparar  
		cmp bl, filas									;se compara bl con la cantidad de filas para ver si se llego al final de las filas
		jl cicloRows									; si es menor es que no a llegado y se repite el ciclo filas y si llego se sale
RET
IMPRIMIRMATRIZ ENDP

;procedimiento para incrementar la posicion de la cadena de la matriz hasta la que devuelva el mapeo 
AUMENTARINDICE PROC
xor ax,ax
mov al,resultado

ciclo2:
	cmp al,00h
	je retornar
	inc edi
	dec al
	jmp ciclo2


	retornar:

RET
AUMENTARINDICE ENDP	

;procedimiento imprimir una posicion de la matriz
IMPRIMIRPOS PROC

xor ax,ax
mov al,[edi]
mov temp,al

INVOKE	StdOut, ADDR temp

print chr$(9)

RET
IMPRIMIRPOS ENDP	

	terminar:
	;finalizar programa
	INVOKE	ExitProcess,0
end programa