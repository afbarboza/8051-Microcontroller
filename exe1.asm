	ORG	00
	MOV	P1, #00H
	MOV	TMOD, #01100000B
	MOV	TH1, #00H		; 0 como valor de recarga, em caso de overflow

LOOP:
	MOV	TL1, #00H		; evita overflow
	SETB	TR1			; liga o contador
	CALL	DELAY			; aguarda 640 ciclos de maquina
	MOV	P1, #00H
	CLR	TR1			; desliga o contador
	MOV	P1, TL1			; armazena em P1 o valor de TL1
	SJMP	LOOP			; faz o programa ficar em loop

DELAY:
	; START: Wait loop, time: 640 us
	; Clock: 12000.0 kHz (12 / MC)
	; Used registers: R0, R1
	MOV	R1, #00Bh
	MOV	R0, #01Bh
	NOP
	DJNZ	R0, $
	DJNZ	R1, $-5
	NOP
	; Rest: 0
	; END: Wait loop
	RET

	END
