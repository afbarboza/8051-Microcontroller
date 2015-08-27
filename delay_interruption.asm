	ORG	0
	SJMP	MAIN
;****************************
	ORG	0003
	SJMP	INT0_HANDLER	; CALLS THE HANDLER FOR THE IT0 INTERRUPTION
;****************************

MAIN:
	; ENABLING THE IT0 INTERRUPTION HANDLER
	SETB	IE.0
	CLR	IT0
	SETB	EA
	
;********* 1 HZ LOOP *****************
	MOV R2, #0AH
TEN_TIMES:
	CPL	P3.0
	
MAIN_LOOP:
	MOV	R1, #00H	; 1 ciclo
SUB_LOOP:
	MOV	R0, #00H	; 1 ciclo
	DJNZ	R0, $		; 2 ciclos
	;end of sub loop
	DJNZ	R1, MAIN_LOOP		; 2 ciclos
	; end of main loop
	
	DEC R2
	CJNE	R2, #0H, TEN_TIMES
;*********END OF 1HZ LOOP*****************

	SJMP	$		; 1 ciclo

INT0_HANDLER:

;********* 4 HZ LOOP *****************
	MOV	R3, #02H
TWO_TIMES:
	CPL P3.0
MAIN_LOOP_HANDLER:
	MOV	R1, #00H	; 1 ciclo
	MOV	R0, #00H	; 1 ciclo
	DJNZ	R0, $		; 2 ciclos
	;end of sub loop
	DJNZ	R1, MAIN_LOOP_HANDLER		; 2 ciclos
	; end of main loop
	
	DEC R3
	CJNE	R3, #0H, TWO_TIMES
;********** END OF 4 HZ LOOP **********
	RETI