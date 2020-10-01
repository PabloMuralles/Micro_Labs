.model small								;declaracion de modelo
.data										;inicia segmento de datos
 
 texto1 DB 'Ingrese primer numero. Ejemplo:15 o 05$'
 texto3 DB 'Resultado:$'
 num1 DB ?
 contadorFactores db 01h
 contadorD db 00h
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
	MOV DX, offset texto3
	MOV AH, 09h
	INT 21h
	

	XOR CX,CX 								;limpiar registros
	
	MOV CL, num1 							;las veces que se va repetir el ciclo 

	;DEC CL
	;MOV CL, 64h
	
	Divi:
		XOR AX,AX
		MOV AL, num1
		DIV contadorFactores
		CMP AH,00h
		JE Division
		JMP Suma

		
		Division:
		;imprimir espacio de linea
			MOV DL, 20h
			MOV AH, 02h
			INT 21h
			
			XOR BX, BX					
			MOV BL,contadorFactores
		;imprimir numero de resultado 
		SepararDecimas:
			CMP BL, 09h							;comparar el numero en b		
			JLE Imprimir						; si el numero es menor a 9 se va ir a imprimir 
			SUB BL, 0AH							;si es mayor a 9 se le resta 10 
			INC contadorD						; se cuenta cuantas veces se le resta 10
			CMP BL, 09h							;se compara con 9 el numero en bx
			JLE Imprimir						;si el numero es menor a 9 se va a imprimir 
			JMP SepararDecimas					;si el numero no es menor se vuelve a llamar a separr decimas 
			
		Imprimir:
			
			MOV AH, 02h							; se imprimir el contador de Decimas 
			MOV DL, contadorD
			ADD DL, 30h
			INT 21h
			
			MOV contadorD, 00h

			MOV DL,BL							; se impime la unidad
			ADD DL,30h
			INT 21h		
		
		
		Suma:
		INC contadorFactores
		
	LOOP Divi
	
	;finalizar el programa
	MOV AH, 4ch
	INT 21h
	

end program