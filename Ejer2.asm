;pablo muralles 1113818
.model small
.data
	num1 DB 2h
	num2 DB 1h
	num3 DB 3h

.stack 
.code 
programa:
		;Se inicia el programa
		MOV AX, @DATA					;se obtiene la direccion de donde incia el segmento de datos
		MOV DS, AX						;se inicializa el segmento de datos con lo que tien AX
		
		xor AX,AX						; limpiar el registro AX
		
		;ejercicioA
		MOV AL, num1     				; le asiganmos a la parte baja de de AX el num1 para no perder el num1 a la hora de hacer la suma 
		ADD AL, num2					; realizamos la suma y el resultado se guardara en AL por lo que se perda lo que tengamos en AL
		ADD AL, 30h						; se le suma 30 al resultado para que imprima el numero que deseamos sino imprime el ascii del resultado


		;imprimir la suma 
		MOV DL, AL
		MOV AH, 02h
		INT 21h
		
		;imprimir salto de linea
		MOV DL, 0AH
		INT 21h
		
		; Ejercicio B
		MOV AL, num1
		SUB AL, num2
		ADD AL, 30h
		
		;imprimir resta
		MOV DL, AL
		MOV AH, 02h
		INT 21h
		
		;imprimir salto de linea
		MOV DL, 0AH
		INT 21h
		
		;ejercicioc
		MOV AL, num1
		ADD AL, num2
		ADD AL, num3
		ADD AL, num3
		ADD AL, 30h
		
		;imprimir resutlado
		MOV DL, AL
		MOV AH, 02h
		INT 21h
		
		;imprimir salto de linea 
		MOV DL, 0AH
		INT 21h
		
		;ejerciciod
		MOV AL, num1
		SUB AL, num2
		ADD AL, num3
		ADD AL, 30h
		
		;imprimir resutado
		MOV	DL, AL
		MOV AH, 02h
		INT 21h
		
		;finalizar el programa
		MOV AH, 4ch
		INT 21h



end programa