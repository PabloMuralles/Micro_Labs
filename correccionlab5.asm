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
	y DB 00h
	num1 DB ?
	resultado DW ? 
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
	CMP BX,7Fh
	JGE Erro
	
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
		JL disp
		CALL MULTIPLICAR
		INC x
		
	JMP ciclo
	
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
		ciclo4:
			XOR DX, DX							;limpiar registros
			XOR AX,AX
			
			MOV AH, 02h							; se imprimir el contador de Decimas 
			MOV DL, [SI]
			ADD DL, 30h
			INT 21h
			
			DEC SI								;decrementar contadores e indice
			DEC largo
			
			XOR BX, BX
			MOV BX, largo						;comparar que no llegara al final
			CMP BX, 00h
		JG ciclo4

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