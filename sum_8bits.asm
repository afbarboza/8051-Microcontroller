;  EXERCICIO AULA1-1	

	ORG 0		
	MOV 30H, #58H	; MOVE O DADO 58H PARA A POSICAO 0x30
	MOV 31H, #3CH	; MOVE O DADO 3CH PARA A POSICAO 0x31
	CLR A		; ZERA O ACUMULADOR A
	ADD A, 30H	; FAZ O ACUMULADOR A += CONTEUDO ARMAZENADO EM 0x30
	ADD A, 31H	; FAZ O ACUMULADOR A += CONTEUDO ARMAZENADO EM 0x31
	SJMP $		; FINALIZA O PROGRAMA
	END