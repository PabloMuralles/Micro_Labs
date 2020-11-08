.386
.model		flat, stdcall ; stdcall convencion de paso de parametros es un orden, parametros al api del windows

;option
option	casemap:none ; convencion para mapear caracteres, y se utliza por windows.inc, se le pasa de parametro none

;include 
INCLUDE	\masm32\include\windows.inc  
include	\masm32\include\kernel32.inc  
include	\masm32\include\masm32.inc  
include	\masm32\include\masm32rt.inc  

.data		 
	
	saludo DB "Hola mundo"

.data?	 

	nombre db 50 dup(?)
	num DB ?

.const	; valores que no van a cambiar

.code	

programa:
 

	;finalizar 
	INVOKE	ExitProcess,0
end programa