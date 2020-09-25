.model small								;declaracion de modelo
.data										;inicia segmento de datos
	texto1 DB 'Ingrese pruebas realizada. Ejemplo:125 o 025$'
	texto2 DB 'Ingrese resultados positivos Ejemplo:100 o 055$'
	num1 DB ?
	num2 DB ?
	alerRoja DB 'Alerta Roja$'
	alerNaranja DB 'Alerta Naranja$'
	alerAmarilla DB 'Alerta Amarilla$'
	alerVerde DB 'Alerta Verde$'
	fallos DB 'Positovos no pueden ser mayor a pruebas$'

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
	
	;leer primero numero, pruebas realizadas 
	;leer un digito
	MOV AH, 01h
	INT 21h
	
	SUB AL, 30h							 	;convertirlo al numero real
	MOV BL, 100d							; pasar 100 a bl para comvertirlo a centena 
	MUL BL									;multiplicar le numero leido en AL por BL para convertirlo a centena 
	MOV num1, AL							; guradar la centena en num1 
	
	XOR AX,AX								; limpiar registros
	XOR BX,BX
	
	;leer segundo digito
	MOV AH, 01h
	INT 21h
	
	SUB AL, 30h								;convertirlo al numero real
	MOV BL, 10d								;le sumo 10 para las decenas 
	MUL BL									; lo multiplico para que se convierta a decenas
	ADD num1, AL							; se lo sumo a num1
	
	XOR AX,AX								;limpiar registos
	XOR BX,BX
	
	;leer tercer digito
	MOV AH, 01h								
	INT 21h
	
	SUB AL, 30h								; obtener el numero real
	ADD num1, AL							; sumarlo a la variable
	
	XOR AX,AX
	XOR BX,BX
	
	
	;imprimir salto de linea
	MOV DL, 0AH
	MOV AH, 02h
	INT 21h
	
	;imprimir la instruccion al usuario
	MOV DX, offset texto2
	MOV AH, 09h
	INT 21h
	
	;leer segundo numero, pruebas positivas
	;imprimir salto de linea
	MOV DL, 0AH
	MOV AH, 02h
	INT 21h
	
	;leer un digito
	MOV AH, 01h
	INT 21h
	
	SUB AL, 30h							 	;convertirlo al numero real
	MOV BL, 100d							; pasar 100 a bl para comvertirlo a centena 
	MUL BL									;multiplicar le numero leido en AL por BL para convertirlo a centena 
	MOV num2, AL							; guradar la centena en num1 
	
	XOR AX,AX								;limpiar registos
	XOR BX,BX
	
	;leer segundo digito
	MOV AH, 01h
	INT 21h
	
	SUB AL, 30h								;convertirlo al numero real
	MOV BL, 10d								;le sumo 10 para las decenas 
	MUL BL									; lo multiplico para que se convierta a decenas
	ADD num2, AL							; se lo sumo a num1
	
	XOR AX,AX
	XOR BX,BX
	
	;leer tercer digito
	MOV AH, 01h							
	INT 21h
	
	SUB AL, 30h								;obtenemos el numero real						
	ADD num2, AL							; se le suma a la variable 
	
	
	;imprimir salto de linea
	MOV DL, 0AH
	MOV AH, 02h
	INT 21h
	
	XOR AX,AX								;limpiar registros
	XOR BX,BX
	
	;mover num1 a AL para hacer comparacion
	MOV AL,num1
	
	;validar numeros 
	CMP AL,num2
	JC fallo	
				
	xor AX,AX								;limpiar registros
 
	;calcular porcentaje
	MOV AL,num2
	MOV BL, 100d
	MUL BL
	MOV BL, num1
	DIV BL
	
	; DESTINO < ORIGEN --> CF ACTIVA, ZF DESACTIVADA
	; DESTINO > ORIGEN ---> CF DESACTIVADA, ZF DESACTIVADA
	; DESTINO = ORIGEN ---> ZF ACTIVA, CF DESACTIVADA
	
	XOR BX,BX								;limpiar registros
	MOV BL, AL
	
	; realizar comparaciones entre los distinto rangos
	CMP BL, 14h 
	JG roja
	
	CMP BL, 0Fh 
	JGE anaranjada
	
	CMP BL,05h
	JGE amarilla
	
	CMP BL, 00h
	JGE verde
	
	;imprimir alertas
	roja:
	MOV DX, offset alerRoja 				
    MOV AH, 09h
    INT 21h
	JMP finalizar
	
	amarilla:
	MOV DX, offset alerAmarilla
    MOV AH, 09h
    INT 21h
	JMP finalizar
	
	anaranjada:
	MOV DX, offset alerNaranja
    MOV AH, 09h
    INT 21h
	JMP finalizar
	
	verde:
	MOV DX, offset alerVerde
    MOV AH, 09h
    INT 21h
	JMP finalizar
	
	fallo:
	MOV DX, offset fallos
    MOV AH, 09h
    INT 21h
	JMP finalizar
	
	
	finalizar:

	;finalizar el programa
	MOV AH, 4ch
	INT 21h
	

end program

 