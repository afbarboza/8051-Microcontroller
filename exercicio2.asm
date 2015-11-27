	ORG	0
	SJMP	MAIN

	ORG	000BH
	SJMP	TIMER_0

MAIN:
	CLR	P1.7
	; habilitando a interrupcao de overflow do tc 0
	SETB	ET0
	SETB	EA

	; configurar o timer 0 no modo 0
	MOV	TMOD, #00000000B

	; 13 bits setados = 8191 e 2560uS/2 = 1280, logo 8191-1280 = 6911 = 0x1AFF 
	MOV	TL0, #00FFH
	MOV	TH0, #001AH

	SETB	TR0
	SJMP	$

TIMER_0:
	CLR	EA
	CPL	P1.7
	CLR	TR0
	MOV	TL0, #00FFH
	MOV	TH0, #001AH
	SETB	TR0
	SETB	EA
	RETI

	END

