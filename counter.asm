; A SIMPLE EXAMPLE OF A COUNTER
	
	ORG	0
	CLR	A		; CLEAR THE ACCUMULATOR
LOOP:				; DEFINE THE LOOP LABEL
	INC	A		; MAKES A <- A + 1
	CJNE	A, #3H, LOOP	; COMPARE A TO 3, JUMPS IF NOT EQUAL
	SJMP	$		; END OF PROGRAM
	END
