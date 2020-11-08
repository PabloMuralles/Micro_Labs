.386
.model		flat, stdcall ; stdcall convencion de paso de parametros es un orden, parametros al api del windows

;option
option	casemap:none ; convencion para mapear caracteres, y se utliza por windows.inc, se le pasa de parametro none

;include 
;include path\nombre.inc , son codigo estatico y se da cuando se genera el obj por lo que el codigo se copia a la solucion
;includelib path\nombre.lib , no pasa por el ensamblador sino por el linker y es mas dinamico, las incluye como una libreria de alto nivel
INCLUDE	\masm32\include\windows.inc ;funciones de windows
include	\masm32\include\kernel32.inc ;importa las llamas para el control de flujo del programa, de esta si existe un lib
include	\masm32\include\masm32.inc ;nos ayuda a que el codigo sea mas facil de mantener y programar
include	\masm32\include\masm32rt.inc ;nos ayuda a que el codigo sea mas facil de mantener y programar 

.data		; se usa para variable inicializadas 
	
	saludo DB "Hola mundo"

.data?	; se usa para variables no inicializadas

	nombre db 50 dup(?)
	num DB ?

.const	; valores que no van a cambiar

.code	

programa:
; no es necesario inicilizar el programa como en turbo assembler

	;finalizar 
	INVOKE	ExitProcess,0
end programa