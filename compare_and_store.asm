;************************************************
; Author Alex Barboza, alex.barboza@usp.br	*
; compare_and_store: main program		*
;						*
; This program (i) reads the end+1 position of	*
; program memory and (ii) then reads the end+2 	*
; position of program memory. 			*
; (iii)Compare the two bytes			*
; and store the max(end+1, end+2) byte. Some	*
; optimization still can be done. Fell free to	*
; for do it.					*
;************************************************

	ORG	0

START:	MOV	DPTR, #VALUES	; MAKES DPTR POINT TO DATA POSITION OF PROGRAM MEMORY

	CLR	A		; CLEAR THE ACCUMULATOR

	; STORES IN A THE VALUE AT @DPTR
	MOVC	A, @A+DPTR	; A += THE CONTENT OF DPTR
	MOV	R0, A		; MAKES R0 = A

	CLR	A		; MAKES A = 0
	INC	DPTR		; MAKES DPTR POINT TO NEXT POSITION OF MEMORY

	; STORES IN A THE VALUE AT @DPTR
	MOVC	A, @A+DPTR	; A += THE CONTENT OF DPTR
	MOV	R1, A		; MAKES R1 = A

	CLR	A

	MOV	A, R0		; MAKES A = R0
	MOV	B, R1		; MAKES B = R1
	MOV	DPTR, #1200H	; THE POSITION WHERE THE MAJOR VALUE WILL BE STORED.

	CJNE	A, B, IF
IF:	JC	ELSE
	MOVX	@DPTR, A	; IF A > B
	JMP	THEN
	
ELSE:	MOV	A, B		; IF B >A
	MOVX	@DPTR, A
	JMP	THEN
	
THEN:	SJMP	$

VALUES:	DB	1DH, 0C3H

	END
