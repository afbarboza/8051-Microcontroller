	ORG	00H
	SJMP	MAIN

	ORG	0003H
	SJMP	INT_0

	ORG	0013H
	SJMP	INT_1

MAIN:
	SETB	EA		; habilitando todas as interrupcoes

	; configurando a interrupcao externa 0
	SETB	EX0
	SETB	IT0

	; configurando a interrupcao externa 1
	SETB	EX1
	SETB	IT1

	; evitar vazamentos - prioridade de atendendimento para PX1
	SETB	PX1

	MOV	P1, #00H
	ACALL	FILL
	SJMP	$

FILL:
	CLR	P1.0		; desativa drenagem
	SETB	P1.1		; enche o reservatorio
	RET

INT_0:				; externa0 - liquido sendo drenado
	CLR	P1.0		; desativa drenagem
	SETB	P1.1		; enche o reservatorio
	RETI

INT_1:				; externa1 - liquido sendo transbordado
	SETB	P1.0		; ativa drenagem
	CLR	P1.1		; desativa enchimento de liquido
	RETI

	END
