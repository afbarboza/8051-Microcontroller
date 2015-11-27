	ORG	00H
	SJMP	MAIN

	ORG	0003H
	SJMP	INT_0		; interrupcao externa 0

	ORG	000BH
	SJMP	TIMER_0		; overflow to timer 0

	ORG	0013H
	SJMP	INT_1		; interrupcao externa 1

MAIN:
	SETB	EA

	; configurando a interrupcao externa 0
	SETB	EX0
	SETB	IT0

	; configurando a interrupcao de overflow do timer 0
	SETB	ET0

	; configurando a interrupcao externa 1
	SETB	EX1
	SETB	IT1

	; definindo a prioridade de atendimento da interrupcao externa 0
	SETB	PX0

	SJMP	$

INT_0:
	CLR	EA		; evita interrupcao da interrupcao
	MOV	DPTR, #4000H	; DPTR aponta para a posicao 4000H
	MOVX	A, @DPTR	; move para acc o valor contido em 4000H

	MOV	DPTR, #4200H	; DPTR aponta para a posicao 4200H
	MOVX	@DPTR, A	; o valor de 4000h eh copiado para a posicao 4200h

	SETB	EA		; re-habilita as interrupcoes
	RETI

TIMER_0:
	CLR	EA		; evita interrupcao da interrupcao
	MOV	DPTR, #4000H	; DPTR aponta para a posicao 4000h

	MOV	A, P2		; move o conteudo da porta p1 para o acumulador
	MOVX	@DPTR, A	; o conteudo do acumulador eh transferido para o endereco 4000h

	SETB	EA		; re-habilita as interrupcoes
	RETI

INT_1:
	CLR	EA
	MOV	DPTR, #4200H
	MOVX	A, @DPTR
	MOV	P1, A
	SETB	EA
	RETI
	END
