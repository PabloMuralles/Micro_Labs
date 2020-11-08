OP1 MACRO numa,numb,numc,result
	XOR AX,AX			; limpiar registrso 
	XOR BX,BX
	XOR cx,cx

	MOV AL,numb			; multiplciar por dos
	MOV BL,02h
	MUL	BL
	MOV cl,AL

	XOR AX,AX			; limpiar registros
	XOR BX,BX

	mov al,numa			; restar y multiplicar por 3
	mov bl,numc
	sub al,bl
	MOV BL,03h
	MUL	BL

	mov result,cl		;sumar los dos resultados anteriores
	add result,al
ENDM	

OP2 MACRO numa,numb,result
	XOR AX,AX			;limpar registros
	XOR BX,BX

	MOV AL,numa			;dividr numa numb
	MOV BL,numb
	div	BL
	MOV result,al		;guardar el resutlado en result
ENDM	

OP3 MACRO numa,numb,numc,result
	XOR AX,AX			;limpiar registros
	XOR BX,BX

	MOV AL,numa			;multiplicar numa por numb
	mov bl,numb
	mul bl

	mov bl,numc			;divir el resultado por numc
	div bl

	mov result,al
ENDM	


OP4 MACRO numa,numb,numc,result
	XOR AX,AX		;limpiar registros
	XOR BX,BX

	MOV AL,numb		;divir el numb por el numb 
	mov bl,numc
	div bl

	mov bl,numa		;multicar el resultado por numa
	mul bl

	mov result,al
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

	text2 DB	"Ingrese a, numeros unicamente de un digito",0
	text3 DB	"Ingrese b, numeros unicamente de un digito",0
	text4 DB	"Ingrese c, numeros unicamente de un digito",0
	text5 DB	"Error pueda ser que esta ingresando que a es menor b, b o c son 0",0
	textresultado DB	"Resultado:",0
	numa DB 0,0
	numb DB 0,0
	numc DB 0,0
	result DB 0,0
	contadorU DB 0,0
	contadorD DB 0,0

.data?	; se usa para variables no inicializada
	   

.const	; valores que no van a cambiar

.code	

programa:

	;imprimir leer los numeros 
	INVOKE	StdOut, ADDR	text2
	print chr$(13,10)
	INVOKE	StdIn, ADDR	numa,10d

	INVOKE	StdOut, ADDR	text3
	print chr$(13,10)
	INVOKE	StdIn, ADDR	numb,10d

	INVOKE	StdOut, ADDR	text4
	print chr$(13,10)
	INVOKE	StdIn, ADDR	numc,10d

	;pasar los numeros a sus valores reales
	sub numa,30h
	sub numb,30h
	sub numc,30h
	
	;comparar que a no sea menor a c si lo es mostrar error
	xor bx,bx
	mov bl,numa
	
	cmp bl,numc
	JL error1
	;realizar operacion1
	OP1 numa,numb,numc,result
	INVOKE	StdOut, ADDR	textresultado
	xor ax, ax
	mov al,result
	print str$(ax),13d,10d	

	jmp operacion2	

	error1:
	print chr$("Error: a es menor a c")
	print chr$(13,10)
	;realizar operacion2
	operacion2:
	;comparar que b no sea 0 si lo es error
	mov bl,numb
	cmp bl,00h
	je error2	
	
	OP2 numa,numb,result
	INVOKE	StdOut, ADDR	textresultado
	xor ax, ax
	mov al,result
	print str$(ax),13d,10d	
	jmp operacion3	

	error2:
	print chr$("Error:b = 0")
	print chr$(13,10)
	;operacion3
	operacion3:
	;comaprar que c no sea 0 si lo es error
	mov bl,numc
	cmp bl,00h
	je error3	

	OP3 numa,numb,numc,result
	INVOKE	StdOut, ADDR	textresultado
	xor ax, ax
	mov al,result
	print str$(ax),13d,10d ; imprimir el resultado	
	jmp operacion4

	error3:
	print chr$("Error:c = 0")
	print chr$(13,10)
	;realizar operacion 4
	operacion4:
	;comaprar que c no sea 
	mov bl,numc
	cmp bl,00h
	je error4	

	OP4 numa,numb,numc,result
	INVOKE	StdOut, ADDR	textresultado
	xor ax, ax
	mov al,result
	print str$(ax),13d,10d	
	jmp termina	

	error4:
	print chr$("Error:c = 0")
	print chr$(13,10)

	;finalizar 
	termina:
	INVOKE	ExitProcess,0

end programa