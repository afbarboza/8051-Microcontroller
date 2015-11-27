	ORG	00H
	SJMP	MAIN

	ORG	0003H
	SJMP	INT_0

	ORG	0013H
	SJMP	INT_1

MAIN:
	; configurando as interrupcoes
	SETB	EA

	SETB	IT0
	SETB	EX0

	SETB	IT1
	SETB	EX1

	; repete o processo três vezes
	ACALL	ENGINE
	ACALL	ENGINE
	ACALL	ENGINE

	SJMP	$

INT_0:
	CLR	EA		; evita a interrupcao da interrupcao
	CLR	P2.6		; desliga o motor
	SETB	P1.2		; acionando o aquecimento do forno
	ACALL	DELAY
	CLR	P1.2		; desliga o aquecimento
	CLR	P2.7		; invertendo o sentido do motor
	SETB	P2.6		; ligando o motor
	SETB	EA
	RETI

INT_1:
	CLR	EA		; evita a interrupcao da interrupcao
	CLR	P2.6		; desliga o motor
	SETB	P1.0		; aciona o resfriamento
	ACALL	DELAY
	CLR	P1.0		; desaciona o resfriamento
	SETB	EA
	RETI

ENGINE:
	SETB	P2.7		; desce o recipiente
	SETB	P2.6		; liga o motor
	RET

DELAY:
	; START: Wait loop, time: 500 ms
	; Clock: 12000.0 kHz (12 / MC)
	; Used registers: R0, R1, R2
	MOV	R2, #004h
	MOV	R1, #0FAh
	MOV	R0, #0F8h
	NOP
	DJNZ	R0, $
	DJNZ	R1, $-5
	DJNZ	R2, $-9
	; Rest: -13.0 us
	; END: Wait loop
	RET

	END
