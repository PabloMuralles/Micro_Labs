.model small								;declaracion de modelo
.data										;inicia segmento de datos
 
 texto1 DB 'Ingrese primer numero. Ejemplo:015,005 o 128$'
 texto2 DB 'Resultado:$'
 texto3 DB 'Error$'
 num1 DB ?
 unidad DB '$'
 decena DB '0$'
 centena DB '00$'
 resultado DB '1$'
 ;temp DB ?
 ;abajo DB '2$'
 carry DB 00h
 contador DB 02h
 cUnidad DB 00h
 cDecena DB 00h
 cCentena DB 00h
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
	MOV BL, 64h								;le sumo 10 para las decenas 
	MUL BL									; lo multiplico para que se convierta a decenas
	ADD num1, AL							; se lo sumo a num1
	
	XOR AX,AX								;limpiar registos
	XOR BX,BX
 
	;leer segundo digito del num1
	MOV AH, 01h
	INT 21h
	
	SUB AL, 30h								;convertirlo al numero real
	MOV BL, 0AH								;le sumo 10 para las decenas 
	MUL BL									; lo multiplico para que se convierta a decenas
	ADD num1, AL							; se lo sumo a num1
	
	XOR AX,AX								;limpiar registos
	XOR BX,BX
	
	;leer tercer digito del num1
	MOV AH, 01h								
	INT 21h
	
	SUB AL, 30h								; obtener el numero real
	ADD num1, AL							; sumarlo a la variable
	
	;imprimir salto de linea
	MOV DL, 0AH
	MOV AH, 02h
	INT 21h
	
	XOR BX,BX								;limpiar registos
	MOV BL,num1								;mover num1 al registro bx para poder realizar la validacion
	
	;evaluar que el numero no sea mayor a 128
	CMP BX,80h
	JG disp
	
	;evaluar si el numero es 1
	CMP BX,01h
	JZ result
	
	XOR CX, CX 								; limpiar registro de contador
	MOV CL, num1							; mover la cantidad de veces que se va repetir el ciclo 
	SUB CL, 01h								; quitarle una unidad para que no llegue hasta 0
	
	factorial:
	
		CALL SEPARAR
		CALL MULTI
		CALL SUMAR
		
		INC contador

	
	LOOP factorial
	
	JMP result
 
	
	disp:
	;imprimir error al usuario
	MOV DX, offset texto3
	MOV AH, 09h
	INT 21h
	
	result1:
	MOV AH, 02h
	MOV DL, 31h 
	INT 21h
	JMP finalizar
	
	result:
	;imprimir la instruccion al usuario
	MOV DX, offset texto2
	MOV AH, 09h
	INT 21h

	LEA SI, resultado
	;imprimir la resultado al usuario
	imprimir:
		MOV AH, 02h
		MOV DL, resultado[SI]  
		ADD DL, 30h
		INT 21h
		INC SI
		CMP resultado[SI], 24h						; la parte de arriba llega al final terminar de multplicar 
		JE finalizar	
		JMP imprimir
	
 
	finalizar:
	;finalizar el programa
	MOV AH, 4ch
	INT 21h
;-----------------------------------------------------------------------------------------------------------------------------------------------------
	MULTI PROC
	
		LEA SI, resultado								; inicializar arriba
		LEA DI, unidad									; inicializar la cadena unidad
		MOV carry, 00h
		
		unidades:
			XOR AX, AX									;limpiar registros
			XOR BX,BX
			
			MOV AL,[SI]								;realizar multiplicacion 
			SUB AL,30h
			MUL cUnidad
			
			ADD AL,carry								
			AAM 										;calcula carry y dato a insertar
			SUB AL, 30h
			MOV BYTE PTR[DI], AL						;mover el caracter de la multiplicacion
			MOV carry, AH
			
			INC SI
			INC DI
			CMP resultado[SI], 24h						; la parte de arriba llega al final terminar de multplicar 
			JE reinicio1
			JMP unidades
		
		reinicio1:
			MOV BYTE PTR[DI], 24h							;agregar el fin de cadena
			LEA SI, resultado								; inicializar arriba
			LEA DI, decena									; inicializar la cadena decena
			INC DI
			
		decenas:
			XOR AX, AX									;limpiar registros
			XOR BX,BX
			
			MOV AL, [SI]								;realizar multiplicacion 
			MUL cDecena
			
			ADD AL,carry								
			AAM 										;calcula carry y dato a insertar
			MOV BYTE PTR[DI], AL						;mover el caracter de la multiplicacion
			MOV carry, AH
		
		
			INC SI
			INC DI
			CMP resultado[SI], 24h						; la parte de arriba llega al final terminar de multplicar 
			JE reinico2
			JMP decenas
			
		reinico2:
			MOV BYTE PTR[DI], 24h							; agegar el fin de cadena
			LEA SI, resultado								; inicializar arriba
			LEA DI, centena									; inicializar la cadena centena
			INC DI
			INC DI
			
		centenas:
			XOR AX, AX									;limpiar registros
			XOR BX,BX
			
			MOV AL, [SI]								;realizar multiplicacion 
			MUL cCentena
			
			ADD AL,carry								
			AAM 										;calcula carry y dato a insertar
			MOV BYTE PTR[DI], AL						;mover el caracter de la multiplicacion
			MOV carry, AH
			
			INC SI
			INC DI
			CMP resultado[SI], 24h						; la parte de arriba llega al final terminar de multplicar 
			JE salir
			JMP centenas
  
		salir:
			MOV BYTE PTR[DI], 24h							; agegar el fin de cadena
	
	RET
	MULTI ENDP
	
	;---------------
	SEPARAR PROC
		xor BX,BX 								;limpiar registros
		MOV BL,contador							;asignar el contador a bl	
	
		SepararCentecima:
			CMP BX,63h							;comparar si si el numero es menor a 99
			JLE	SepararDecimas					;si es menor o igual ir a separar decimas 
			SUB BX, 64h							;se le resta 100 al numero 
			INC cCentena						;se cuenta cuantas veces se le resta el numero
			CMP BX, 63h							;se compara el numero con 99
			JLE SepararDecimas					;si es menor a 99 se va ir a separar decimas 
			JMP SepararCentecima				;si no es menor se va a repetir la etiqueta	

		SepararDecimas:
			CMP BX, 09h							;comparar el numero en b		
			JLE separarUnidad						; si el numero es menor a 9 se va ir a imprimir 
			SUB BX, 0AH							;si es mayor a 9 se le resta 10 
			INC cDecena							; se cuenta cuantas veces se le resta 10
			CMP BX, 09h							;se compara con 9 el numero en bx
			JLE separarUnidad						;si el numero es menor a 9 se va a imprimir 
			JMP SepararDecimas					;si el numero no es menor se vuelve a llamar a separr decimas 
			
		separarUnidad:
			MOV cUnidad,BL						; se guarda la unidad
			 
			
	RET
	SEPARAR ENDP
	
	;---------------
	SUMAR PROC
		LEA SI, unidad										; inicializar arriba
		LEA DI, resultado								; inicializar la cadena unidad
		MOV carry, 00h
		
		leer1:
			XOR AX,AX
			MOV AL,unidad[SI]
			MOV BYTE PTR[DI], AL
			INC SI
			INC DI
			CMP unidad[SI],24h							;se valida si se llego al final
			JZ  empezar1
			JMP leer1
		
		empezar1:
			MOV BYTE PTR[SI], 24h							; agegar el fin de cadena
			LEA SI, decena									; inicializar arriba
			LEA DI, resultado								; inicializar la cadena unidad
		
		leer2:
			XOR AX, AX										;limpiar registros
			XOR BX,BX
			
			MOV AL, [DI]
			ADD AL, [SI]
			ADD AL, carry			
			AAM
			MOV BYTE PTR[DI], AL
			MOV carry, AH
			
			INC SI
			INC DI
			CMP resultado[DI],24h							;se valida si se llego al final
			JZ  empezar2
			JMP leer2
		
		empezar2:
			
			LEA SI, centena									; inicializar arriba
			LEA DI, resultado								; inicializar la cadena unidad
			
		leer3:
			XOR AX, AX										;limpiar registros
			XOR BX,BX
			
			MOV AL, [DI]
			ADD AL, [SI]
			ADD AL, carry			
			AAM
			MOV BYTE PTR[DI], AL
			MOV carry, AH
			
			INC SI
			INC DI
			CMP resultado[DI],24h							;se valida si se llego al final
			JNE  leer3

	RET
	SUMAR ENDP
	
	
	 
	

end program