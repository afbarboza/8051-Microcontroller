		ORG	0000H
		LJMP	MAIN

		ORG	0003H
		LJMP	EOC_HANDLER	; trata o sinal de fim de conversao

		ORG	000BH
		LJMP	OV_HANDLER	; trata o overflow no timer 0

;***************************************
; PULSE_SC: PULSA O SINAL DE INICIO 	*
; DE CONVERSAO POR, PELO MENOS, 50 mS	*
;***************************************
PULSE_SC:
		SETB	P3.6
		; START: Wait loop, time: 50 ms
		; Clock: 12000.0 kHz (12 / MC)
		; Used registers: R7, R6, R5
		MOV	R5, #004h
		MOV	R6, #0A0h
		MOV	R7, #025h
		NOP
		DJNZ	R7, $
		DJNZ	R6, $-5
		DJNZ	R5, $-9
		MOV	R7, #021h
		DJNZ	R7, $
		; Rest: 0
		; END: Wait loop
		CLR	P3.6
		RET

EOC_HANDLER:
		CLR	EA		; desabilitando interrupcoes
		MOV	ACC, P1		; le o dado analogico
		ACALL	CONV		; converte e salva em memoria
		SETB	EA		; reabilitando interrupcoes novamente
		RETI

OV_HANDLER:
		CLR	EA
		CLR	TR0
		LCALL	SHOW_DATA	; mostra os valores no display
		MOV	TH0, #0FFH	; recarrega o timer0
		MOV	TL0, #9BH
		SETB	TR0		; reinicia contagem
		SETB	EA
		ACALL	PULSE_SC	; da pulso pra reiniciar a contagem
		RETI

SHOW_DATA:	MOV	DPTR, #TAB
		; SHOW DIGIT 1
		MOV	A, DIGIT1
		MOVC	A, @A+DPTR
		SETB	P3.7
		MOV	P2, A
		; SHOW DIGIT 2
		MOV	A, DIGIT0
		MOVC	A, @A+DPTR
		CLR	P3.7
		MOV	P2, A
		RET

;***************************************
; CONV: converte o valor no acumulador	*
; (00h <= acc <= FFh) para valores a 	*
; serem exibidos nos displays.		*
; (00 <= valor_convertido <= 15)	*
;***************************************
CONV:
		CJNE	A, #0A0H, TEST
TEST:		JC	LT_0xA0
		SJMP	GTE_0xA0
LT_0xA0:	MOV	R0, #00H
		SJMP	LS_DIGIT
GTE_0xA0:	MOV	R0, #01H
		CLR	C
		SUBB	A, #0A0H
LS_DIGIT:	MOV	DIGIT1, R0
		CJNE	A, #10H, TST1
TST1:		JC	LT_0x10
		CJNE	A, #20H, TST2
TST2:		JC	LT_0x20
		CJNE	A, #30H, TST3
TST3:		JC	LT_0x30
		CJNE	A, #40H, TST4
TST4:		JC	LT_0x40
		CJNE	A, #50H, TST5
TST5:		JC	LT_0x50
		CJNE	A, #60H, TST6
TST6:		JC	LT_0x60
		CJNE	A, #70H, TST7
TST7:		JC	LT_0x70
		CJNE	A, #80H, TST8
TST8:		JC	LT_0x80
		CJNE	A, #90H, TST9
TST9:		JC	LT_0x90
		SJMP	LTE_0x9F

LT_0x10:	MOV	DIGIT0, #00H
		SJMP	END_CONV
LT_0x20:	MOV	DIGIT0, #01H
		SJMP	END_CONV
LT_0x30:	MOV	DIGIT0, #02H
		SJMP	END_CONV
LT_0x40:	MOV	DIGIT0, #03H
		SJMP	END_CONV
LT_0x50:	MOV	DIGIT0, #04H
		SJMP	END_CONV
LT_0x60:	MOV	DIGIT0, #05H
		SJMP	END_CONV
LT_0x70:	MOV	DIGIT0, #06H
		SJMP	END_CONV
LT_0x80:	MOV	DIGIT0, #07H
		SJMP	END_CONV
LT_0x90:	MOV	DIGIT0, #08H
		SJMP	END_CONV
LTE_0x9F:	MOV	DIGIT0, #09H
END_CONV:	RET

MAIN:
		SETB	EA			; habilita o uso de interrupcoes
		SETB	EX0			; habilita a fonte de interrupcao externa 0
		SETB	ET0			; habilita a interrupcao do timer 0
		MOV	TMOD, #01H		; tc0 como temporizador no modo 1 (controle por software)
		MOV	TH0, #0FFH
		MOV	TL0, #9BH
		MOV	P2, #00H
		MOV	P1, #00H
		ACALL	PULSE_SC
		SETB	TR0
		SJMP	$

DIGIT1		EQU	31H
DIGIT0		EQU	30H
TAB:		DB	7EH, 30H, 6DH, 79H, 33H, 5BH, 5FH, 70H, 7FH, 7BH, 77H, 1FH, 4EH, 3DH, 4FH, 47H
		END