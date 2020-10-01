.model small								;declaracion de modelo
.data										;inicia segmento de datos
 

.stack						
.code 

program: 
	MOV AX,@DATA							;obtenemos la direccion de inicio
	MOV DS,AX								; iniciliza el segmento de datos
 


	;finalizar el programa
	MOV AH, 4ch
	INT 21h
	

end program
