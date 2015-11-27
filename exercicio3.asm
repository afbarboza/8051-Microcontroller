	ORG	0
	SJMP	MAIN

	ORG	000BH
	SJMP	TIMER_0

MAIN:
	INC	A
	CALL	DELAY
	INC	A
	SJMP	$

DELAY:
	CLR	C
	; atendimento de overflow do timer 0
	SETB	ET0
	SETB	EA

	; configurando o timer 0
	MOV	TMOD, #00000001B	; temporizador de 16 bits, com controle por software
	MOV	TL0,  #00AFH		; 0,05 S = 50000 uS => 50 000 ciclos
	MOV	TH0,  #003CH
	SETB	TR0
	JNC	$			; delay de 0,05

	CLR	TR0			; reinicializa os registrador TMOD e TCON
	CLR	ET0
	CLR	EA
	RET

TIMER_0:				; subrotina para atendimento de overflow
	SETB	C
	RETI

	END

