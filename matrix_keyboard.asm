		ORG	00H
MAIN:		ACALL	TST_ABRE
		ACALL	TST_FECHA
		SJMP	MAIN

;*******************************************************
; TST_ABRE: ESSA FUNCAO DISPARA O SISTEMA DE CONTROLE	*
; ESPERANDO ATE QUE A SENHA CORRETA SEJA DIGITADA.	*
; SE ALGUMA SENHA ERRADA DE ABERTURA FOR DIGITADA,	*
; DISPARA O SISTEMA DE ALARME				*
;*******************************************************
TST_ABRE:
		ACALL	VARRE_TECLA
		CJNE	A, #0CH, SET_ALARM1
		ACALL	VARRE_TECLA
		CJNE	A, #04H, SET_ALARM1
		ACALL	VARRE_TECLA
		CJNE	A, #02H, SET_ALARM1
		ACALL	VARRE_TECLA
		CJNE	A, #0FH, SET_ALARM1
		ACALL	ABRE
		SJMP	END_ABRE
SET_ALARM1:	ACALL	ALARM
		SJMP	TST_ABRE
END_ABRE:	RET


;*******************************************************
; TST_FECHA: ESSA FUNCAO DISPARA O SISTEMA DE FECHADURA	*
; ESPERANDO ATE QUE A SENHA CORRETA SEJA DIGITADA.	*
; SE ALGUMA SENHA ERRADA DE FECHADURA FOR DIGITADA,	*
; DISPARA O SISTEMA DE ALARME.				*
;*******************************************************
TST_FECHA:
		ACALL	VARRE_TECLA
		CJNE	A, #0FH, SET_ALARM2
		ACALL	VARRE_TECLA
		CJNE	A, #02H, SET_ALARM2
		ACALL	VARRE_TECLA
		CJNE	A, #04H, SET_ALARM2
		ACALL	VARRE_TECLA
		CJNE	A, #0CH, SET_ALARM2
		ACALL	FECHA
		SJMP	END_FECHA
SET_ALARM2:	ACALL	ALARM
		SJMP	TST_FECHA
END_FECHA:	RET

;*******************************************************
; ABRE: ESTA SUBROTINA ABRE A FECHADURA			*
;*******************************************************
ABRE:
		CLR	P1.1		; limpa o bit de fechadura
		SETB	P1.0		; seta o bit de abertura
		RET

;*******************************************************
; FECHA: ESTA SUBROTINA FECHA A FECHADURA		*
;*******************************************************
FECHA:
		CLR	P1.0		; limpa o  bit de abertura
		SETB	P1.1		; seta o bit de fechadura
		RET

;*******************************************************
; ALARM: ESTA FUNCAO MANTEM O ALARME LIGADO, 		*
; AGUARDANDO ATE QUE A SENHA CORETA SEJA DIGITADA.	*
; A CADA SENHA DIGITADA INCORRETAMENTE			*
; ELE AGUARDA 1s E DISPARA O ALARME DE NOVO		*
;*******************************************************
ALARM:
		SETB	P3.7		; aciona o alarme
		ACALL	VARRE_TECLA
		MOV	R0, ACC
		ACALL	VARRE_TECLA
		MOV	R1, ACC
		ACALL	VARRE_TECLA
		MOV	R2, ACC
		ACALL	VARRE_TECLA
		MOV	R3, ACC

		CJNE	R0, #03H, KEEP_ALARM
		CJNE	R1, #06H, KEEP_ALARM
		CJNE	R2, #09H, KEEP_ALARM
		CJNE	R3, #0CH, KEEP_ALARM
		SJMP	CLR_ALARM

KEEP_ALARM:	CLR	P3.7
		; desativa por 1s o alarme, e entao aciona novamente
		; START: Wait loop, time: 1 s
		; Clock: 12000.0 kHz (12 / MC)
		; Used registers: R7, R6, R5, R4
		MOV	R4, #003h
		MOV	R5, #0D2h
		MOV	R6, #024h
		MOV	R7, #014h
		NOP
		DJNZ	R7, $
		DJNZ	R6, $-5
		DJNZ	R5, $-9
		DJNZ	R4, $-13
		MOV	R7, #059h
		DJNZ	R7, $
		NOP
		; Rest: 0
		; END: Wait loop
		SETB	P3.7
		SJMP	ALARM
CLR_ALARM:	CLR	P3.7
		RET

;************************************************
; VARRE_TECLA: subrotina que varre o teclado	*
; ate que um valor seja digitado (!= 0xFF)	*
; O valor lido eh armazenado no acumulador	*
;************************************************
VARRE_TECLA:
		MOV	P2, #0FFH
LOOP1:		CLR	P2.4
		JNB	P2.0, ZERO
		JNB	P2.1, QUATRO
		JNB	P2.2, OITO
		JNB	P2.3, CCC
		MOV	P2, #0FFH
LOOP2:		CLR	P2.5
		JNB	P2.0, UM
		JNB	P2.1, CINCO
		JNB	P2.2, NOVE
		JNB	P2.3, DDD
		MOV	P2, #0FFH
LOOP3:		CLR	P2.6
		JNB	P2.0, DOIS
		JNB	P2.1, SEIS
		JNB	P2.2, AAA
		JNB	P2.3, EEE
		MOV	P2, #0FFH
LOOP4:		CLR	P2.7
		JNB	P2.0, TRES
		JNB	P2.1, SETE
		JNB	P2.2, BBB
		JNB	P2.3, FFF
		MOV	A, #0FFH
		SJMP	VARRE_TECLA

ZERO:		MOV	A, #00H
		RET
UM:		MOV	A, #01H
		RET
DOIS:		MOV	A, #02H
		RET
TRES:		MOV	A, #03H
		RET
QUATRO:		MOV	A, #04H
		RET
CINCO:		MOV	A, #05H
		RET
SEIS:		MOV	A, #06H
		RET
SETE:		MOV	A, #07H
		RET
OITO:		MOV	A, #08H
		RET
NOVE:		MOV	A, #09H
		RET
AAA:		MOV	A, #0AH
		RET
BBB:		MOV	A, #0BH
		RET
CCC:		MOV	A, #0CH
		RET
DDD:		MOV	A, #0DH
		RET
EEE:		MOV	A, #0FH
		RET
FFF:		MOV	A, #0FH
		RET
		END