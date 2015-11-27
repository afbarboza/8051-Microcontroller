		ORG	0000H
		LJMP	MAIN

		ORG	000BH
		LJMP	ATENDE_MOTOR

;****************************************
; ITEM A) SUBROTINA DE ATENDIMENTO DO	*
;         TECLADO			*
;					*
; LE_TECLADO: teclado emite		*
; nivel logico 0 quando nao ha		*
; nenhuma tecla pressionada.		*
; O valor lido sai pelo acumulador.	*
;****************************************
LE_TECLADO:
		; GARANTE NIVEL LOGICO 1
		MOV	P1, #0FFH
		; ZERA A COLUNA DOS DIGITOS 0, 3 E 6
		CLR	P1.4
		JNB	P1.0, ZERO
		JNB	P1.1, TRES
		JNB	P1.2, SEIS
		MOV	P1, #0FFH
		; ZERA A COLUNA DOS DIGITOS 1, 4, 7 e 9
		CLR	P1.5
		JNB	P1.0, UM
		JNB	P1.1, QUATRO
		JNB	P1.2, SETE
		JNB	P1.3, NOVE
		MOV	P1, #0FFH
		; ZERA A COLUNA DOS DIGITOS 2, 5 E 8
		CLR	P1.6
		JNB	P1.0, DOIS
		JNB	P1.1, CINCO
		JNB	P1.2, OITO
		SJMP	LE_TECLADO

ZERO:		MOV	A, #0
		RET
UM:		MOV	A, #1
		RET
DOIS:		MOV	A, #2
		RET
TRES:		MOV	A, #3
		RET
QUATRO:		MOV	A, #4
		RET
CINCO:		MOV	A, #5
		RET
SEIS:		MOV	A, #6
		RET
SETE:		MOV	A, #7
		RET
OITO:		MOV	A, #8
		RET
NOVE:		MOV	A, #9
		RET

;****************************************************************
; ITEM_B) SUBROTINA DE ESCRITA NO LCD				*
; WRITE_LCD: ESCREVE MENSAGEM "FERRAMENTA POSICIONADA" NO LCD	*
;****************************************************************
WRITE_LCD:
		MOV	DPTR, #MSG
LOOP_WRITE:	CLR	A
		MOVC	A, @A+DPTR
		JZ	END_WRITE	; CASO JA TENHA TERMINADO DE ESCREVER NO LCD '\0'
		ACALL	WRITE_TEXT
		INC	DPTR
		SJMP	LOOP_WRITE
END_WRITE:	RET

;****************************************************************
; ITEM C) SUBROTINA DE ATENDIMENTO DO ENCODER.			*
;****************************************************************
ATENDE_MOTOR:	CLR	EA
		CLR	MOTOR
		SETB	INTERRUPCAO
		ACALL	WRITE_LCD
		SETB	MOTOR
		SETB	EA
		RETI

;****************************************************************
; ITEM D) PROGRAMA PRINCPAL COM CONFIGURACOES NECESSARIAS	*
;****************PROGRAMA    PRINCIPAL***************************
MAIN:		MOV	P2, #00H
		MOV	P3, #00H
		ACALL	CLR_LCD
		CLR	INTERRUPCAO
		ACALL	LE_TECLADO
		MOV	MSD, A
		ACALL	LE_TECLADO
		MOV	LSD, A
		ACALL	CONV		; CALCULA O VALOR DIGITADO (DIGITO + E DIGO - MENOS SIGNIFICATIVOS)
		SETB	EA
		MOV	TMOD, #00000110B; CONTADOR 0, NO MODO 1, COM CONTROLE POR SOFTWARE
		; REALIZA O CALCULO PARA GERAR O OVERFLOW NO TIMER 0
		; ESSE OVERFLOW REPRESENTA QUE A FERRAMENTA JA FOI POSICIONADA
		MOV	A, #0FFH
		MOV	R0, NPULSOS
		CLR	C
		SUBB	A, R0		; TL0 = 255 - VALOR_LIDO_DO_TECLADO
		MOV	TH0, A
		MOV	TL0, A
		SETB	TR0		; DISPARA O T0
		JNB	INTERRUPCAO, $	; AGUARDA FERRAMENTA SER POSICIONADA
		SJMP	MAIN

;****************************************************************
; CONV: CONVERTE OS DIGITOS LIDOS EM DECIMAL.			*
; VALOR = (DIGITO_MAIS_SIGN. * 10) + DIGTO_MENOS_SIGN		*
;****************************************************************
CONV:		MOV	A, MSD
		MOV	B, #0AH
		MUL	AB
		MOV	R0, LSD
		ADD	A, R0
		MOV	NPULSOS, A
		RET
;****************************************************************
; INIT_LCD: SUBROTINA DE INICIALIZACAO DOS LCDS			*
;****************************************************************
INIT_LCD:
		CLR	RW
		SETB	ENAB
		CLR	RS
		MOV	DATA_, #38H
		CLR	ENAB
		LCALL	WAIT_LCD
		;******************
		SETB	ENAB
		CLR	RS
		MOV	DATA_, #0EH	; LIGA O LCD E O CURSOR
		CLR	ENAB
		LCALL	WAIT_LCD
		;******************
		SETB	ENAB
		CLR	RS
		MOV	DATA_, #06H
		LCALL	WAIT_LCD
		RET

;****************************************************************
; CLR_LCD: SUB-ROTINA PARA LIMPAR A TELA DO LCD			*
;****************************************************************
CLR_LCD:	CLR	RW
		SETB	ENAB
		CLR	RS
		MOV	DATA_, #01H
		CLR	ENAB
		LCALL	WAIT_LCD
		RET
;****************************************************************
; POS_LCD: POSICIONA O CURSOR LCD				*
;****************************************************************
POS_LCD:
		CLR	RW
		SETB	ENAB
		CLR	RS
		ADD	A, #080H
		MOV	DATA_, A
		CLR	ENAB
		LCALL	WAIT_LCD
		RET

;****************************************************************
; WRITE_TEXT: ESCREVE NO LCD. CARACTER ENTRA PELO ACC		*
;****************************************************************
WRITE_TEXT:	CLR	RW
		SETB	ENAB
		SETB	RS		; MODO DADOS
		MOV	DATA_, A
		CLR	ENAB
		LCALL	WAIT_LCD
		RET

;****************************************************************
; WAIT_LCD: SUBROTINA QUE ESPERA O LCD EXECUTAR UM COMANDO	*
;****************************************************************
WAIT_LCD:
		SETB	RW
		SETB	ENAB
		CLR	RS
		MOV	DATA_, #0FFH
		JB	DB7, $
		CLR	ENAB
		CLR	RW
		RET

;===AREA DE DEFINICAO DE VARIAVEIS UTILIZADAS NO DECORRER DO PROGRAMA===

;*** ENDERECOS PARA ARMAZENAMENTO DE DIGITOS LIDOS DO TECLADO ***
LSD		EQU	30H
MSD		EQU	31H
;****************************************************************
NPULSOS		EQU	32H		; ARMAZENA O NUMERO DE PULSOS TOTAL, I.E., O VALOR LIDO DO TECLADO
LIMITE_PULSOS	EQU	33H		; ARMAZENA A DIFIRENCA 255 - NPULSOS, PARA GERAR A INTERRUPCAO DO CONTADOR 0
;****************************************************************
MOTOR		EQU	P3.5		; BIT QUE CONTROLA O MOTOR
;****************************************************************
INTERRUPCAO	EQU	20H.0		; EH SETADO NO ATENDIMENTO A INTERRUPCAO, PARA POSTERIOR CHECAGEM NA MAIN
;****************************************************************
ENAB		EQU	P3.0		; ENABLE DO LCD
RW		EQU	P3.1		; RW DO LCD
RS		EQU	P3.2		; RS DO LCD

DATA_		EQU	P2
DB0		EQU	P2.0
DB1		EQU	P2.1
DB2		EQU	P2.2
DB3		EQU	P2.3
DB4		EQU	P2.4
DB5		EQU	P2.5
DB6		EQU	P2.6
DB7		EQU	P2.7
;****************************************************************
MSG:		DB	'FERRAMENTA POSICIONADA', 0
		END