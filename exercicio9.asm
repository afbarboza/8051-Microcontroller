	ORG	000H
	SJMP	MAIN

	ORG	003H
	SJMP	INT_0

	ORG	00BH
	SJMP	TIMER_0

	ORG	013H
	SJMP	INT_1


	ORG	01BH
	SJMP	TIMER_1


MAIN:
	SETB	EA

	SETB	EX0			; habilitando a interrupcao externa 0
	SETB	IT0			; sensivel a borda de descida

	SETB	EX1			; habilitando a interrupcao externa 1
	SETB	IT1			; sensivel a borda de descida

	SETB	ET0			; habilita a interrupcao do timer 0

	SETB	ET1			; habilita a interrupcao do timer 1

	SETB	PX0			; definindo a prioridade da interrupcao externa 0
	SETB	PT0			; definindo a prioridade da interrupcao do timer 0

	MOV	TMOD, #00010001B	; setando OS T/C

	MOV	TH0, #00D8H		; D8EFH = 55535
	MOV	TL0, #00EFH

	MOV	TH1, #0015H		; 159FH = 5535
	MOV	TL1, #009FH

	SETB	TR0			; ligando o timer 0
	SETB	TR1			; ligando o timer 1

	SJMP	$

INT_0:					; registradores usados = r0 e r1
	CLR	EA

	MOV	DPTR, #5000H		; DPTR aponta para o endereco 0x5000

	MOVX	A, @DPTR		; acc = conteudo(5000H)
	MOV	R0, P1			; r0 = conteudo(p1)

	XCH	A, R0			; troca o conteudo de aCC com o de R0

	MOVX	@DPTR, A		; conteudo(5000H) = acc
	MOV	P1, R0			; conteudo(p1) = r0
	SETB	EA
	RETI

TIMER_0:
	CLR	EA			; desabilita a interrupcao
	CLR	TR0			; desliga o timer 0
	MOV	TH0, #00D8H		; recarrega o timer0 com D8EFH = 55535
	MOV	TL0, #00EFH
	MOV	DPTR, #5200H		; DPTR aponta para a posicao 5200H externa
	MOV	R0, #07FH		; r0 aponta para a posicao 7fh interna
	MOV	A, @R0			; acc <- conteudo (7fh interna)
	MOVX	@DPTR, A		; conteudo(5200 externa) <- acc
	SETB	TR0			; liga o timer 0 novamente
	SETB	EA			; habilita as interrupcoes novamente
	RETI

INT_1:
	CLR	EA
	MOV	DPTR, #5000H		; dptr aponta para 5000H externa
	MOV	R0, #7FH		; r0 aponta para 7fh interna
	MOVX	A, @DPTR		; acc <- conteudo(5000h externa)
	MOV	@R0, A			; conteudo(7fh interno) <- acc
	SETB	EA
	RETI

TIMER_1:
	CLR	EA			; desabilita as interrupcoes
	CLR	TR1			; desliga o timer1
	MOV	TH1, #0015H		; recarrega o timer1 com 159FH = 5535
	MOV	TL1, #009FH
	MOV	DPTR, #5200H		; DPTR aponta para o endereco 5200 externa
	MOVX	A, @DPTR		; acc <- conteudo(5200h externa)
	MOV	DPTR, #5000H		; DPTR aponta para o endereco 5000 externa
	MOVX	@DPTR, A		; conteudo(5000h externa) <- acc
	SETB	TR0			; liga novamente o timer
	SETB	EA			; habilita novamente as interrupcoes
	RETI

	END
