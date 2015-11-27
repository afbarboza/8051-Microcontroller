		ORG	00H
		MOV	P2, #00H
		CLR	SENHA_CERTA
		ACALL	VARRE_TECLA
		MOV	R0, A
		ACALL	VARRE_TECLA
		MOV	R1, A
		ACALL	VARRE_TECLA
		MOV	R2, A
		ACALL	VARRE_TECLA
		MOV	R3, A
		ACALL	TST1
		ACALL	TST2
		JNB	SENHA_CERTA, FUNC3
		SJMP	$

;************************************************
; TST_1: checa se a senha digitada eh 4AD3H	*
;************************************************
TST1:
		MOV	A, R0
		CJNE	A, #'4', END_TST1
		MOV	A, R1
		CJNE	A, #'A', END_TST1
		MOV	A, R2
		CJNE	A, #'D', END_TST1
		MOV	A, R3
		CJNE	A, #'3', END_TST1
		SETB	SENHA_CERTA
		ACALL	FUNC1
END_TST1:	RET

;************************************************
; TST_2: checa se a senha digitada eh CABEH	*
;************************************************
TST2:
		MOV	A, R0
		CJNE	A, #'C', END_TST2
		MOV	A, R1
		CJNE	A, #'A', END_TST2
		MOV	A, R2
		CJNE	A, #'B', END_TST2
		MOV	A, R3
		CJNE	A, #'E', END_TST2
		ACALL	FUNC2
		SETB	SENHA_CERTA
END_TST2:	RET

;************************************************
; FUNC1: acende o led 1 e preenche a ram  ext.	*
; com a parte menos significativa do endereco.	*
;************************************************
FUNC1:
		SETB	P3.2
		MOV	DPTR, #00H
TST_LOOP1:	MOV	A, DP0L			; TESTA SE JA ATINGIU A ULTIMA POSICAO DE MEMORIA RAM EXTERNA (0xFFFF)
		CJNE	A, #0FFH, FLOOP1
		MOV	A, DP0H
		CJNE	A, #0FFH, FLOOP1
		SJMP	END_LOOP1
FLOOP1:		MOV	A, DP0L			; PREENCHE COM A PARTE MENOS SIGNIFICATIVA DO ENDERECO
		MOVX	@DPTR, A
		INC	DPTR
		SJMP	TST_LOOP1
END_LOOP1:	MOV	DPTR, #0FFFFH
		MOV	A, #0FFH
		MOVX	@DPTR, A
		RET
;************************************************
; FUNC1: acende o led 2 e zera a ram  ext.	*
;************************************************
FUNC2:
		SETB	P3.4
TST_LOOP2:	MOV	A, DP0L			; TESTA SE JA ATINGIU A ULTIMA POSICAO DE MEMORIA RAM EXTERNA (0xFFFF)
		CJNE	A, #0FFH, FLOOP2
		MOV	A, DP0H
		CJNE	A, #0FFH, FLOOP2
		SJMP	END_LOOP2
FLOOP2:		MOV	A, #00H			; PREENCHE A RAM EXTERNA COM ZEROS
		MOVX	@DPTR, A
		INC	DPTR
		SJMP	TST_LOOP2
END_LOOP2:	MOV	DPTR, #0FFFFH
		MOV	A, #00H
		MOVX	@DPTR, A
		RET
;************************************************
; FUNC3: preenche a ram externa com zeros	*
; e pisca os leds de maneira alternada.		*
; Impede a entrada de outras senhas.		*
;************************************************
FUNC3:
		MOV	DPTR, #00H
TST_LOOP3:	MOV	A, DP0L			; TESTA SE JA ATINGIU A ULTIMA POSICAO DE MEMORIA RAM EXTERNA (0xFFFF)
		CJNE	A, #0FFH, FLOOP3
		MOV	A, DP0H
		CJNE	A, #0FFH, FLOOP3
		SJMP	END_LOOP3
FLOOP3:		MOV	A, #0FFH		; PREENCHE RAM EXTERNA COM FFH
		MOVX	@DPTR, A
		INC	DPTR
		SJMP	TST_LOOP3
END_LOOP3:	MOV	DPTR, #0FFFFH
		MOV	A, #0FFH
		MOVX	@DPTR, A
CPL_LOOP:	; START: Wait loop, time: 50 ms
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
		CPL	P3.2
		CPL	P3.4
		SJMP	CPL_LOOP

;************************************************
; VARRE_TECLA: subrotina que varre o teclado	*
; ate que um valor seja digitado (!= 0xFF)	*
; O valor lido eh armazenado no acumulador	*
;************************************************
VARRE_TECLA:
		MOV	P1, #0FFH
LOOP1:		CLR	P1.4
		JNB	P1.0, ZERO
		JNB	P1.1, QUATRO
		JNB	P1.2, OITO
		JNB	P1.3, CCC
		MOV	P1, #0FFH
LOOP2:		CLR	P1.5
		JNB	P1.0, UM
		JNB	P1.1, CINCO
		JNB	P1.2, NOVE
		JNB	P1.3, DDD
		MOV	P1, #0FFH
LOOP3:		CLR	P1.6
		JNB	P1.0, DOIS
		JNB	P1.1, SEIS
		JNB	P1.2, AAA
		JNB	P1.3, EEE
		MOV	P1, #0FFH
LOOP4:		CLR	P1.7
		JNB	P1.0, TRES
		JNB	P1.1, SETE
		JNB	P1.2, BBB
		JNB	P1.3, FFF
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

SENHA_CERTA	EQU	20H.0
		END