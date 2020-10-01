.model small								;declaracion de modelo
.data										;inicia segmento de datos
 
 texto1 DB 'Ingrese primer numero. Ejemplo:15 o 05$'
 texto2 DB 'Ingrese segundo numero. Ejemplo::90 o 01$'
 texto3 DB 'Resultado:$'
 num1 DB ?
 num2 DB ?
 contadorM db 1 dup (0)
 contadorC db 1 dup (0)
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
	
	;imprimir la instruccion al usuario
	MOV DX, offset texto3
	MOV AH, 09h
	INT 21h
	
	
	;asignar contador
	XOR CX,CX	
	MOV CL, num1							; las veces que se va sumar el otro numero 
	
	XOR BX, BX							; limpiar registros
	xor AX,AX
	
	MOV AL, num2						; mover el numero a sumar a al
	
	Mult:
		ADD BX, AX						; se va sumar num2 la veces de num1
		SUB CL,01h
		CMP CL, 00h
		JZ SepararMiles
		JMP Mult
	
	;imprimir numero de resultado 
	SepararMiles:
		CMP BX,3E7h							;comparar si es mayor con 999
		JLE	SepararCentecima				;si es menor salta separa centecima
		SUB BX, 3E8h						;resto 1000 a lo que este en bx
		INC contadorM						;contador de cuantas veces se le resta 1000
		CMP BX, 3E7h						;comparar si es menor a 999 si es menor salta a centecimas sino Repite lo mismo
		JLE SepararCentecima				;si es menor a 999 se va a separar centecima 
		JMP SepararMiles					;si no es menor se va a saltar a la misma etiqueta y se repetira esto
		
	SepararCentecima:
		CMP BX,63h							;comparar si si el numero es menor a 99
		JLE	SepararDecimas					;si es menor o igual ir a separar decimas 
		SUB BX, 64h							;se le resta 100 al numero 
		INC contadorC						;se cuenta cuantas veces se le resta el numero
		CMP BX, 63h							;se compara el numero con 99
		JLE SepararDecimas					;si es menor a 99 se va ir a separar decimas 
		JMP SepararCentecima				;si no es menor se va a repetir la etiqueta	
	
	SepararDecimas:
		CMP BX, 09h							;comparar el numero en b		
		JLE Imprimir						; si el numero es menor a 9 se va ir a imprimir 
		SUB BX, 0AH							;si es mayor a 9 se le resta 10 
		INC contadorD						; se cuenta cuantas veces se le resta 10
		CMP BX, 09h							;se compara con 9 el numero en bx
		JLE Imprimir						;si el numero es menor a 9 se va a imprimir 
		JMP SepararDecimas					;si el numero no es menor se vuelve a llamar a separr decimas 
		
	Imprimir:
	
		MOV AH, 02h							; se imprimir el contdor de miles
		MOV DL, contadorM	
		ADD DL, 30h		
		INT 21h
		
		MOV AH, 02h							; se imprime el contdor de centenas
		MOV DL, contadorC
		ADD DL, 30h
		INT 21h
	
		MOV AH, 02h							; se imprimir el contador de Decimas 
		MOV DL, contadorD
		ADD DL, 30h
		INT 21h
		
		MOV DL,BL							; se impime la unidad
		ADD DL,30h
		INT 21h
	
	 
	;finalizar el programa
	MOV AH, 4ch
	INT 21h
	

end program
