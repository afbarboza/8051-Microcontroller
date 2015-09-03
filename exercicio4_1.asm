;*******************************
;Nome: Alex Barboza
;No USP: 7986480
;Data: 03/09/2015
;*******************************

	ORG	00H
	SJMP	MAIN

	ORG	0003H
	SJMP	INT0_HANDLER

	ORG	000BH
	SJMP	T0_HANDLER

	ORG	0013H
	SJMP	INT1_HANDLER
;****************************************************************************************
MAIN:
	; configurando todas as interrupcoes
	SETB	IE.0			; habilita a interrupcao externa 0
	SETB	IE.1			; habilita a interrupcao do overflow do timer 0
	SETB	IE.2			; habilita a interrupcao externa 1

	SETB	IT0			; IT0 eh sensivel a descida de borda/nivel baixo
	SETB	IT1			; IT1 eh sensivel a descida de borda/nivel baixo

	SETB	EA			; habilita todas as interrupcoes
	SETB	C			; inicializa o carry, para 2 KHZ, no caso de overflow
	ACALL	SET_WAVE_2KHZ		; inicializa com onda de 2 khz
	SJMP	$
;****************************************************************************************
INT0_HANDLER:
	CLR	EA
	CLR	C
	CPL	P1.0
	ACALL	SET_WAVE_1KHZ
	SETB	EA
	RETI
;****************************************************************************************
T0_HANDLER:
	CLR	EA
	CPL	P1.0
	JC	carry_1
	JNC	carry_0

carry_1:
	ACALL	SET_WAVE_2KHZ
	SJMP	end_if

carry_0:
	ACALL	SET_WAVE_1KHZ
	SJMP	end_if
end_if:
	SETB	EA
	RETI
;****************************************************************************************
INT1_HANDLER:
	CLR	EA
	SETB	C
	CPL	P1.0
	ACALL	SET_WAVE_2KHZ
	SETB	EA
	RETI
;****************************************************************************************
SET_WAVE_2KHZ:
	CLR	TR0			; desliga o timer
	MOV	TL0, #000BH		; reinicializa a partir de 65035
	MOV	TH0, #00FEH
	SETB	TR0
	RET
;****************************************************************************************
SET_WAVE_1KHZ:
	CLR	TR0
	MOV	TL0, #0017H
	MOV	TH0, #00FCH
	SETB	TR0
	RET

	END