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

LOOP:
	MOV	A, #0FH
	CJNE	A, #00H, LOOP
	SJMP	$
	
INT0_HANDLER:
	MOV	A, #00H
	RETI