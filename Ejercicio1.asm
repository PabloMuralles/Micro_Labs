CalculosCuadrado MACRO base, perimetro, area
	XOR AX,AX
	XOR BX,BX

	MOV AL,base
	MOV BL,04h
	MUL	BL
	MOV perimetro,AL

	XOR AX,AX
	XOR BX,BX

	MOV AL,base
	MOV BL,base
	MUL	BL
	MOV area, AL

ENDM	

CalculosRectangulo MACRO base, altura, perimetro, area
	XOR AX,AX
	XOR BX,BX

	MOV AL,base
	MOV BL,02h
	MUL	BL
	MOV perimetro,AL

	MOV AL,altura
	MOV BL,02h
	MUL	BL
	ADD perimetro,AL

	XOR AX,AX
	XOR BX,BX

	MOV AL,base
	MOV BL,altura
	MUL	BL
	MOV area, AL

ENDM	

CalculosTriangulos MACRO base, altura,lado2,lado3, perimetro, area, residuo 
	XOR AX,AX
	XOR BX,BX

	MOV AL,base
	mov bl,lado2
	add AL,bl
	mov bl,lado3

	add AL,bl
	MOV perimetro,AL

	XOR AX,AX
	XOR BX,BX

	MOV AL,base
	MOV BL,altura
	MUL	BL
	mov bl,02h
	div	bl
	MOV area, AL
	MOV residuo,AH

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

	text1 DB	"Ingrese 1 para cuadrado, 2 para rectangulo, 3 para triangulo y 4 para salir",0
	textCuadrado DB	"Ingrese el tamaño del lado, numeros unicamente de un digito",0
	textRectangulo1 DB	"Ingrese el tamaño de la base, numeros unicamente de un digito",0
	textRectangulo2 DB	"Ingrese el tamaño de la altura, numeros unicamente de un digito",0
	textTriangulo1 DB	"Ingrese la base, numeros unicamente de un digito",0
	textTriangulo2 DB	"Ingrese el lado2, numeros unicamente de un digito",0
	textTriangulo3 DB	"Ingrese el lado3, numeros unicamente de un digito",0
	textTriangulo4 DB	"Ingrese la altura, numeros unicamente de un digito",0
	salto DB	"Ingrese la altura, numeros unicamente de un digito",0
	rPerimetro DB	"Perimetro:",0
	rArea DB	"Area:",0
	punto DB	".",0
	base DB 0,0
	opcion DB 0,0
	altura DB 0,0
	lado2 DB 0,0
	lado3 DB 0,0
	perimetro DB 0,0
	area DB 0,0
	contadorU DB 0,0
	contadorD DB 0,0
	residuo DB 0,0

.data?	; se usa para variables no inicializada
	   

.const	; valores que no van a cambiar

.code	

programa:

	;imprimir menu al usuario y captar que es lo que desea hacer
	INVOKE	StdOut, ADDR	text1
	print chr$(13,10)
	INVOKE	StdIn, ADDR	opcion,10d
	

	XOR BX,BX					; limpiar registros 
	MOV BL,opcion				; mover la opcion al registro para comparar 
	SUB BL,30h					;convertirlo a numero real

	;comparar la opcion en el registro para ver que accion realizar
	CMP BL,01h				
	JE cuadrado	
	CMP BL,02h
	JE rectangulo
	CMP	BL,03h
	JE trinagulo
	CMP	BL,04h
	JE termina	
	JMP programa	


	cuadrado:
		INVOKE	StdOut, ADDR	textCuadrado
		print chr$(13,10)
		INVOKE	StdIn, ADDR	base,50d
		print chr$(13,10)
		
		SUB	base,30h
		CalculosCuadrado base, perimetro, area

		CALL MOSTRAR	

		JMP termina	

	rectangulo:
		INVOKE	StdOut, ADDR	textRectangulo1
		print chr$(13,10)
		INVOKE	StdIn, ADDR	base,10d

		print chr$(13,10)

		INVOKE	StdOut, ADDR	textRectangulo1
		print chr$(13,10)
		INVOKE	StdIn, ADDR	altura,10d

		SUB	base,30h
		SUB altura,30h

		CalculosRectangulo base, altura, perimetro, area

		CALL MOSTRAR	

		JMP termina	
	

	trinagulo:
		INVOKE	StdOut, ADDR	textTriangulo1
		print chr$(13,10)
		INVOKE	StdIn, ADDR	base,10d

		print chr$(13,10)

		INVOKE	StdOut, ADDR	textTriangulo2
		print chr$(13,10)
		INVOKE	StdIn, ADDR	lado2,10d

		print chr$(13,10)

		INVOKE	StdOut, ADDR	textTriangulo3
		print chr$(13,10)
		INVOKE	StdIn, ADDR	lado3,10d

		print chr$(13,10)

		INVOKE	StdOut, ADDR	textTriangulo4
		print chr$(13,10)
		INVOKE	StdIn, ADDR	altura,10d

		SUB	base,30h
		SUB altura,30h
		SUB lado2,30h
		SUB lado3,30h
		CalculosTriangulos base, altura, lado2, lado3, perimetro, area, residuo

		CALL MOSTRAR

	;finalizar 
	termina:
	INVOKE	ExitProcess,0

	IMPRIMIR PROC
		XOR AX,AX
		MOV contadorD,00h
		MOV contadorU,00h

		SepararDecimas:
			CMP BX, 09h							;comparar el numero en b		
			JLE Terminar						; si el numero es menor a 9 se va ir a imprimir 
			SUB BX, 0AH							;si es mayor a 9 se le resta 10 
			INC contadorD						; se cuenta cuantas veces se le resta 10
			CMP BX, 09h							;se compara con 9 el numero en bx
			JLE Terminar						;si el numero es menor a 9 se va a imprimir 
			JMP SepararDecimas					;si el numero no es menor se vuelve a llamar a separr decimas 
		
		Terminar:
		
			MOV contadorU,BL							; se impime la unidad
			ADD contadorU,30h
			ADD contadorD,30h

	RET
	IMPRIMIR ENDP

	MOSTRAR PROC
		xor BX,BX
		MOV BL,perimetro
		CALL IMPRIMIR	
		INVOKE	StdOut, ADDR	rPerimetro
		INVOKE	StdOut, ADDR	contadorD
		INVOKE	StdOut, ADDR	contadorU

		print chr$(13,10)
		 
		xor BX,BX
		MOV BL,area
		CALL IMPRIMIR	
		INVOKE	StdOut, ADDR	rArea
		INVOKE	StdOut, ADDR	contadorD
		INVOKE	StdOut, ADDR	contadorU

	RET
	MOSTRAR ENDP

end programa