.model small								;declaracion de modelo
.data										;inicia segmento de datos
 
	num1 DB ?								;estas variables no pueden ir al final
	temp DB ?
	texto1 DB 'Ingrese primer numero. Ejemplo:15 o 05$'
	texto3 DB 'Resultado:$'
 
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
	
	;imprimir el bit 8
	MOV AH, 02h
	MOV DL, 30h                  
	INT 21h
	
	MOV temp,40h
	
	;pasar a binario
	evaluar:

		
		CMP temp, 00h
		JZ Terminar
		
		XOR AX,AX	
		
		MOV AL,num1	
		
		CMP AL, temp	
		JGE imprimirUno
	
		
	
	
	imprimirCero:
		;imprimir un cero
		MOV AH, 02h
		MOV DL, 30h                  
		INT 21h
		
		XOR AX,AX
		XOR BX,BX
		
		MOV AL, temp
		MOV BL, 02h
		DIV BL
		MOV temp, AL
		
		JMP evaluar
	
	imprimirUno:
		;imprimir un uno
		MOV AH, 02h
		MOV DL, 31h                  
		INT 21h
		
		XOR BX,BX
		
		MOV BL,num1
		SUB BL,temp
		MOV num1, BL

	
		XOR AX,AX
		XOR BX,BX
		
		MOV AL, temp
		MOV BL, 02h
		DIV BL
		MOV temp, AL
		
		JMP evaluar
		

	
	Terminar:
	;finalizar el programa
	MOV AH, 4ch
	INT 21h
	
	

end program