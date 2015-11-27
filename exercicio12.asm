	ORG	00H
	MOV	A, #00H		; limpando o acumulador
	MOV	R0, #0AH	; armazena o valor do contador do loop
	MOV	DPTR, #00D0H	; aponta para a regiao da tabela, na memoria do programa
	MOV	R5, #00H	; armazena a quantidade de impares
	MOV	R6, #00H	; armazena a quantidade de pares
LOOP:
	MOV	R1, A
	MOVC	A, @A+DPTR	; le o valor da tabela
	JB	A.0, ODD	; se o lsb for 1, o conteudo do acc eh impar
	SJMP	EVEN

EVEN:				; se for par, escreva na porta p1
	INC	R6
	ACALL	SND_P1
	SJMP	END_IF

ODD:				; se for impar, escreva na porta p2
	INC	R5
	ACALL	SND_P2
	SJMP	END_IF

END_IF:
	MOV	A, R1
	ADD	A, #001H	; incrementa o a em 1, para ler o proximo dado da tabela
	DJNZ	R0, LOOP	; se r0 != 0, prossiga no loop, senao encerra programa

	; armazenando o total de impares
	MOV	DPTR, #230H
	MOV	A, R5
	MOVX	@DPTR, A

	; armazenando o total de pares
	MOV	DPTR, #2031H
	MOV	A, R6
	MOVX	@DPTR, A
	
	SJMP	$
;******************************************************************************************
SND_P1:
	MOV	TMOD, #20H	; timer1, no modo 2, com controle por software
	MOV	TH1, #250	; TH1 carregado com 250
	MOV	TL1, #250
	MOV	PCON, #128	; SMOD = 1, pois K = 2 (eu adotei)
	SETB	TR1		; ligando o timer
	MOV	SCON, #40H	; modo 1: 1 start bit, 8 bits dados, um stop bit, BPS variavel
	MOV	SBUF, A		; transmite o conteudo do acumulador
	JNB	TI, $		; aguarda o termino da transmissao
	CLR	TI		; prepara uma nova transmissao
	MOV	P1, A		; transmite o dado para a porta p1
	RET

;******************************************************************************************

SND_P2:
	MOV	TMOD, #20H	; timer1, no modo 2, com controle por software
	MOV	TH1, #244	; TH1 carregado com 244
	MOV	TL1, #244
	MOV	PCON, #128	; SMOD = 1, pois K = 2 (eu adotei)
	SETB	TR1		; ligando o timer
	MOV	SCON, #40H	; modo1: 1 start bit, 8 bits dados, um stop bit, BPS variavel
	MOV	SBUF, A		; transmite o conteudo do acumulador
	JNB	TI, $		; aguardando termino da transmissao serial
	CLR	TI		; prepara uma nova transmissao
	MOV	P2, A		; transmite o dado para a porta p2
	RET

	; escrevendo na memoria de programa (na posicao 100)
	ORG	00D0H
	DB	01H
	DB	02H
	DB	03H
	DB	04H
	DB	05H
	DB	06H
	DB	07H
	DB	08H
	DB	09H
	DB	0AH
	END