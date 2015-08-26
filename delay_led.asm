;************************************
; Nome: Alex Frederico Ramos Barboza*
; Numero USP: 7986480		    *
;************************************

	ORG	0
	SETB	P3.0		; initializes the bit P3.0
	SETB	P3.1		; initializes the bit p3.1
	ACALL	LOOP		; call the delay
	SJMP	$
LOOP:
	CPL	P3.0		; one's complement in P3.0
	CPL	P3.1		; one's complemet in P3.1
	MOV	R0, #32H	; store 50 in R0
	DJNZ	R0, $		; 2 mS * 50 loops = 100 mS
	JMP	LOOP		; go to the loop again
	RET
	END
