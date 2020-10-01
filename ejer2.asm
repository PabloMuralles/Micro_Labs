.model small								;declaracion de modelo
.data										;inicia segmento de datos
 
 texto1 DB 'Ingrese primer numero. Ejemplo:15 o 05$'
 texto2 DB 'Ingrese segundo numero. Ejemplo::90 o 01$'
 texto3 DB 'Resultado:$'
 texto4 DB 'Error$'
 num1 DB ?
 num2 DB ?
 contadorDiv db 1 dup (0)
 contadorD db 1 dup (0)
.stack						
.code 

program: 
	MOV AX,@DATA							;obtenemos la direccion de inicio
	MOV DS,AX								; iniciliza el segmento de datos
	
	;imprimir la instruccion al usuario
	MOV DX, offset texto1
	MOV AH, 09h
	INT 21h
	
	;imprimir salto de linea
	MOV DL, 0AH
	MOV AH, 02h
	INT 21h
	
	XOR AX,AX								;limpiar registos
	XOR BX,BX
 
	;leer primer digito del num1
	MOV AH, 01h
	INT 21h
	
	SUB AL, 30h								;convertirlo al numero real
	MOV BL, 0AH								;le sumo 10 para las decenas 
	MUL BL									; lo multiplico para que se convierta a decenas
	ADD num1, AL							; se lo sumo a num1
	
	XOR AX,AX								;limpiar registos
	XOR BX,BX
	
	;leer segundo digito del num1
	MOV AH, 01h								
	INT 21h
	
	SUB AL, 30h								; obtener el numero real
	ADD num1, AL							; sumarlo a la variable
	
	;imprimir salto de linea
	MOV DL, 0AH
	MOV AH, 02h
	INT 21h
	
	;imprimir la instruccion al usuario
	MOV DX, offset texto2
	MOV AH, 09h
	INT 21h
	
	;imprimir salto de linea
	MOV DL, 0AH
	MOV AH, 02h
	INT 21h
	
	XOR AX,AX								;limpiar registros
	
	;leer primer digito del num2
	MOV AH, 01h
	INT 21h
	
	SUB AL, 30h								;convertirlo al numero real
	MOV BL, 0AH								;le sumo 10 para las decenas 
	MUL BL									; lo multiplico para que se convierta a decenas
	ADD num2, Al							; se lo sumo a num1
	
	XOR AX,AX								;limpiar registos
	XOR BX,BX
	
	;leer segundo digito del num2
	MOV AH, 01h								
	INT 21h
	
	SUB AL, 30h								; obtener el numero real
	ADD num2, Al							; sumarlo a la variabl
	
	
	;imprimir salto de linea
	MOV DL, 0AH
	MOV AH, 02h
	INT 21h					 
	
	XOR BX,BX							;validar que el segundo digito no sea 0
	MOV BL,num2
	CMP BL,00h
	JE Erro
	
	XOR BX, BX							; limpiar registros
	XOR AX,AX
	XOR CX,CX 
	
	MOV CL, 63h 
	
	MOV BL,num1							; se asignar el numero al que se le va a restar le otro
	
	MOV AL, num2						; mover el numero a restar a al

	
	Divi:
		CMP BL, 00h
		JE SepararDecimas
		CMP BL, AL
		JL SepararDecimas
		SUB BL, AL
		INC contadorDiv
		CMP BL, 00h
		JLE SepararDecimas
		LOOP Divi
		
	 
	
	;imprimir numero de resultado 
	SepararDecimas:
		CMP contadorDiv, 09h					;comparar el numero en b		
		JLE Imprimir						; si el numero es menor a 9 se va ir a imprimir 
		SUB contadorDiv, 0AH							;si es mayor a 9 se le resta 10 
		INC contadorD						; se cuenta cuantas veces se le resta 10
		CMP contadorDiv, 09h							;se compara con 9 el numero en bx
		JLE Imprimir						;si el numero es menor a 9 se va a imprimir 
		JMP SepararDecimas					;si el numero no es menor se vuelve a llamar a separr decimas 
		
	Imprimir:
	
		;imprimir la instruccion al usuario
		MOV DX, offset texto3
		MOV AH, 09h
		INT 21h
		
		MOV AH, 02h							; se imprimir el contador de Decimas 
		MOV DL, contadorD
		ADD DL, 30h
		INT 21h
		
		MOV DL,contadorDiv							; se impime la unidad
		ADD DL,30h
		INT 21h
		JMP finalizar
	
	 erro:
	 ;imprimir la instruccion al usuario
		MOV DX, offset texto4
		MOV AH, 09h
		INT 21h
	 
	finalizar:
	;finalizar el programa
	MOV AH, 4ch
	INT 21h
	

end program