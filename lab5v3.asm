.model small								;declaracion de modelo
.data										;inicia segmento de datos
	texto1 DB 'Ingrese primer numero. Ejemplo:015,005 o 128$'
	texto2 DB 'Resultado:$'
	texto3 DB 'Error$'
	resultadoTemp DB 500 DUP('$') 
	largo DW 01h
	x DB 02h
	i DW 00h
	carry DW 00h
	num1 DB ?
	centena DB 00h
	decena DB 00h
	unidad DB 00h
.stack						
.code 
program: 
	MOV AX,@DATA							;obtenemos la direccion de inicio
	MOV DS,AX								; iniciliza el segmento de datos
	CALL PEDIR
	;evaluar que el numero no sea mayor  
	CMP BX,7Fh								; si es menor a 126 se hace algo 						
	JL hacer1			
	CMP BX,7Fh								; si es igual a 127 se hace algo
	JE hacer2
	CMP BX,80h
	JE hacer3								; si es igual a 128 se hace algo
	JMP erro
	; se hace solo para menores a 126
	hacer1:
		;imprimir salto de linea
		MOV DL, 0AH
		MOV AH, 02h
		INT 21h
		XOR BX,BX
		LEA SI, resultadoTemp							; inicializar el indice 
		MOV BL,01h										; mover un 1 al resultado
		MOV [SI], BL
		ciclo:
			XOR BX,BX									; limpiar registro
			MOV BL, num1
			CMP BL, x									; validar que el numero no sea menor al contador si esto pasa es que se termino el ciclo de multiplicar y se imprime
			JL saltar1
			CALL MULTIPLICAR
			INC x
		JMP ciclo
	; se hace para el 127
	hacer2:
	;imprimir salto de linea
	MOV DL, 0AH
	MOV AH, 02h
	INT 21h
	MOV num1,7Eh
	XOR BX,BX
	LEA SI, resultadoTemp							; inicializar el indice 
	MOV BL,01h										; mover un 1 al resultado
	MOV [SI], BL
	variante1:
		XOR BX,BX									; limpiar registro
		MOV BL, num1
		CMP BL, x									; validar que el numero no sea menor al contador si esto pasa es que se termino el ciclo de multiplicar y se imprime
		JL conti
		CALL MULTIPLICAR
		INC x
	JMP variante1
	conti:
		MOV x, 7Fh									; el resultado de 126 se multiplica por 127
		CALL MULTIPLICAR
		JMP disp
	
	saltar1:										;salto intermedio
	JMP disp
	; se hace para 128
	hacer3:
	;imprimir salto de linea
	MOV DL, 0AH
	MOV AH, 02h
	INT 21h
	MOV num1,7Eh
	XOR BX,BX
	LEA SI, resultadoTemp							; inicializar el indice 
	MOV BL,01h										; mover un 1 al resultado
	MOV [SI], BL
	variante2:
		XOR BX,BX									; limpiar registro
		MOV BL, num1
		CMP BL, x									; validar que el numero no sea menor al contador si esto pasa es que se termino el ciclo de multiplicar y se imprime
		JL conti2
		CALL MULTIPLICAR
		INC x
	JMP variante2
	conti2:											;el resultado de 126 se multiplica por 127 y luego por 128
		MOV x, 7Fh
		CALL MULTIPLICAR
		MOV x, 80h
		CALL MULTIPLICAR
		JMP disp
	Erro:
	;imprimir error al usuario
	MOV DX, offset texto3
	MOV AH, 09h
	INT 21h
	JMP finalizar
	disp:
	;imprimir instruccion al usuario
	MOV DX, offset texto2
	MOV AH, 09h
	INT 21h
	CALL IMPRIMIR
	JMP finalizar
	MULTIPLICAR PROC 
		MOV i, 00h						; inicializar variables
		MOV carry, 00h
		LEA SI, resultadoTemp
		ciclo2:
			XOR AX,AX					;limpiar registros
			XOR BX,BX
			MOV AL,x					;multiplicar el contador con el resultado que se lleva
			MOV BL,[SI]
			MUL BX
			ADD AX,carry				; sumarle el carry 			
			XOR DX,DX					; limpiar registros
			XOR BX,BX			
			MOV BX, 0Ah					; dividir entre 10 para poder calcular cual se pone en el resutlado y cual se almacena en carry
			DIV BX		
			MOV carry, AX				; el mood se le coloca a el resultado y el div al carry 
			MOV [SI], DL			
			INC i			
			XOR BX,BX
			XOR AX,AX			
			MOV BX, i
			MOV AX, largo			
			CMP AX, BX		
			JNE aumentar
			JMP ciclo3		
		aumentar:
			INC SI
		JMP ciclo2	
		ciclo3:
			XOR AX,AX
			MOV AX, carry					;verificar que el carry sea distinto a 0
			CMP AL, 00h
			JE terminar			
			INC SI							; incrementar el si para poder poner el carry			
			XOR BX,BX						; limpiar registro
			XOR DX,DX 	
			MOV BX, 0Ah						;por si el carry es mayor a 10 ir poniendo solo los digitos con el mood y div
			DIV BX			
			MOV carry, AX					; el mood se pone al si y el div se pone al carry
			MOV [SI], DL
			INC largo						; se incrementa el largo del resultado
		JMP	ciclo3 
		terminar:
	RET
	MULTIPLICAR ENDP
	IMPRIMIR PROC 
		MOV x,00h							;inicializar variables
		LEA SI, resultadoTemp
		ciclo4:
			XOR AX,AX						;limpiar registros
			MOV AL,[SI]						; mover a al si 
			CMP AL,24h						; comparar que no sea $
			JE decrementar					; se va a imprimir
			INC SI							;incrementar registros
			INC x
		JMP ciclo4
		decrementar:						;decrementar
			DEC SI	
		ciclo5:
			XOR AX,AX						;limpiar registros
			MOV AL, x						; mover contador a al
			CMP AL,00h						; comparar que no se 0
			JE final 						; salirser del ciclo
			MOV AH,02h						; imprimir caracter
			MOV DL,[SI]
			ADD DL,30h
			INT 21h
			DEC x							;decrementar variables
			DEC SI
		JMP ciclo5
		final:
	RET
	IMPRIMIR ENDP
	PEDIR PROC 
		;imprimir la instruccion al usuario
		MOV DX, offset texto1
		MOV AH, 09h
		INT 21h
		;imprimir salto de linea
		MOV DL, 0AH
		MOV AH, 02h
		INT 21h
		XOR BX,BX 								;limpiar registros
		XOR AX,AX	
		;leer primer digito
		MOV AH, 01h                
		INT 21h
		SUB AL, 30h
		MOV BL, 64h
		MUL BL
		MOV centena, AL
		XOR BX,BX								;limpiar registros
		XOR AX,AX
		;leer segundo digito
		MOV AH, 01h               
		INT 21h
		SUB AL, 30h
		MOV decena, AL
		XOR BX,BX								;limpiar registros
		XOR AX,AX
		;leeer tercer digito
		MOV AH,01h                
		INT 21h
		SUB AL, 30h
		MOV unidad, AL
		XOR BX,BX								;limpiar registros
		XOR AX,AX
		;convertir y sumar numero por aparte
		MOV AL,decena                  
		MOV BL,0Ah
		MUL BL
		ADD AL,unidad                     
		ADD AL,centena
		MOV num1,AL               
		XOR BX,BX								;limpiar registos
		MOV BL,num1								;mover num1 al registro bx para poder realizar la validacion
	RET
	PEDIR ENDP
	finalizar:
	;finalizar el programa
	MOV AH, 4ch
	INT 21h
end program