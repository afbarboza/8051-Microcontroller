	ORG	0000H
	SJMP	MAIN
;***************************************************************************************
	ORG	0003H
	SJMP	INT1_
;***************************************************************************************
	ORG	001BH
	SJMP	TIMER1
;***************************************************************************************
MAIN:
	; habilitando as interrupcoes necessarias
	SETB	EA			; habilita todas as interrupcoes
	SETB	IE.2			; habilita a interrupcao externa 1 (ex1)
	SETB	IE.3			; habilita a interrupcao to timer 1 (et1)

	; configurando TMOD
	MOV	TMOD, #01010000B	; 0 por software, 1 para contador, no modo 01

INIT:
	MOV	A, #00H
	ACALL	PULSES_2
	SJMP	$
;***************************************************************************************
INT1_:					; sub rotina de atendimento da interrupcao externa 1
	CLR	EA			; evita interrupcao da interrupcao
	CLR	P1.2			; apaga o led verde
	CLR	P1.1			; apaga o led amarelo
	CLR	P1.0			; apaga o led vermelho
	SETB	EA			; habilita novamente as interrupcoes
	ACALL	PULSES_2		; reinicializa o contador para ate 2000 pulsos
	SETB	TR0			; liga novamente o contador
	RETI
;***************************************************************************************
TIMER1:					;sub rotina de atendimento da interrupcao do timer 1

TEST1:					; compara se o acumulador eh 0
	CJNE	A, #00H, TEST2
	SETB	P1.2			; acendendo o led verde
	INC	A			; o acumulador passa a valer 1
	ACALL	PULSES_4		; reinicia o contador para contar 4000 pulsos
	SJMP	END_TIMER		; retorna ao programa principal

TEST2:					; compara se o acumulador eh 1
	CJNE	A, #01H, TEST3
	SETB	P1.1			; acendendo o led amarelo
	INC	A			; acaumulador passa a valer 2
	ACALL	PULSES_6
	SJMP	END_TIMER
TEST3:					; compara se o acumulador eh 2
	SETB	P1.0
	MOV	A, #00H
	CLR	TR0
	
END_TIMER:
	RETI

;***************************************************************************************

PULSES_2:				; inicializa o timer1 com 63535
	CLR	TR1			; desliga o timer 1
	; timer1 conta dois mil pulsos: 65535 - 2000 = 63535 (= 0xF82FH)
	MOV	TL1, #002FH
	MOV	TH1, #00F8H
	SETB	TR1			; liga o timer 1
	RET

;***************************************************************************************

PULSES_4:				; inicializa o timer1 com 61535
	CLR	TR1			; desliga o timer 1
	; timer1 conta quatro mil pulsos: 65535 - 4000 = 61535 (= 0xF05F)
	MOV	TL1, #005FH
	MOV	TH1, #00F0H
	SETB	TR1			; liga o timer 1
	RET

;***************************************************************************************

PULSES_6:				; inicializa o timer1 com 59535
	CLR	TR1			; desliga o timer 1
	; timer1 conta seis mil pulsos: 65535 - 6000 = 59535 (= 0xE88F)
	MOV	TL1, #008FH
	MOV	TH1, #00E8H
	SETB	TR1			; liga o timer 1
	RET

	END