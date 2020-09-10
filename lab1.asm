.model small
.data

    Nombre DB 'Pablo Muralles $'
    Carnet DB '1113818$'

.stack 

.code
 programa: 

    ; INICIALIZAR EL PROGRAMA
    MOV AX, @data
    MOV DS, AX

    ; Imprimir nombre y carnet 
    MOV DX, offset Nombre
    MOV AH, 09h
    INT 21h

    MOV DX, offset Carnet
    MOV AH, 09h
    INT 21h

    ; IMPRIMIR LETRA POR DEL NOMBRE Y APELLIDO 
    ; SE PUEDE LIMPIAR EL REGISTRO O NO YA QUE LE VAMOS A CAER ENSIMA

    MOV DL, 2Dh ;guion
    MOV AH, 02h
    INT 21h 

    MOV DL, 50h ;P
    MOV AH, 02h
    INT 21h  
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 

    MOV DL, 61h ;a
    MOV AH, 02h
    INT 21h 
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 

    MOV DL, 62h ;b
    MOV AH, 02h
    INT 21h 
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 

    MOV DL, 6ch ;l
    MOV AH, 02h
    INT 21h 
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 
	
    MOV DL, 6fh ;o
    MOV AH, 02h
    INT 21h 

    MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 
    
    MOV DL, 4dh ;m
    MOV AH, 02h
    INT 21h 
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 

    MOV DL, 75h ;u
    MOV AH, 02h
    INT 21h 
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 

    MOV DL, 72h ;r
    MOV AH, 02h
    INT 21h 
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 

    MOV DL, 61h ;a
    MOV AH, 02h
    INT 21h 
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 

    MOV DL, 6ch ;l
    MOV AH, 02h
    INT 21h 
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 

    MOV DL, 6ch ;l
    MOV AH, 02h
    INT 21h 
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 

    MOV DL, 65h ;e
    MOV AH, 02h
    INT 21h 
	
	MOV DL, 20h ;espacio
    MOV AH, 02h
    INT 21h 

    MOV DL, 73h ;s
    MOV AH, 02h
    INT 21h 

    ; FINALIZAR EL PROGRAMA
    MOV AH, 4Ch
    INT 21h



END programa

