	ORG	00
TEST:
	MOV	P1, #00H
	JNB	P1.3, $				; verifica se o bit p1.3 eh 1
	SETB	P1.4				; se for, seta o bit p1.4 (pulso positivo)
	ACALL	DELAY				; aguarda 50 ms
	CPL	P1.4				; gera pulso negativo
	ACALL	DELAY				; agurda mais 50 ms
	SJMP	TEST

DELAY:
	; START: Wait loop, time: 50 ms
	; Clock: 12000.0 kHz (12 / MC)
	; Used registers: R0, R1, R2
	MOV	R2, #004h
	MOV	R1, #0A0h
	MOV	R0, #025h
	NOP
	DJNZ	R0, $
	DJNZ	R1, $-5
	DJNZ	R2, $-9
	MOV	R0, #021h
	DJNZ	R0, $
	; Rest: 0
	; END: Wait loop
	END