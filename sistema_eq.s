#
#	TRAMPO 1 DE PIHS
#	PROFESSOR: RONALDAO
#	ALUNOS: THIAGO KIRA
#  			CHEROSO MARINGA
#
#	TESTE
#
# 	"Na escuridao o teu olhar me iluminava
# 	 E minha estrela guia era o teu riso"
#

.section .data

titulo: .asciz "\n ### A RUA E NOIS ###\n"
msg_exibe_matrix: .asciz "\n ### PRINTANDO MATRIX ### \n"
msg_end_malloc: .asciz "\n ### ENDERECO ALOCADO: %d ### \n"
msg_copia_matrix: .asciz "\n ### MATRIX COPIADA ### \n"
msg_mostra_dets: .asciz "\n ### det: %d, dx: %d, dy: %d, dz: %d\n"
pede_dados: .asciz "\nEntre com a equacao do tipo Ax + By + Cz = D\n\tNo formato A B C D\n"

formatoint: .asciz "\n%d"
formatocopia: .asciz "\n%d -> %d\n"
teste: .asciz "\nENTRO\n"
pulalinha: .asciz "\n"

.section .text
.globl main

main:
	pushl %ebp
	movl %esp, %ebp
	subl $72, %esp # reservando espaco para variaveis locais

	########################## INICIALIZANDO VAR LOCAL ###########################
	movl $12, -4(%ebp) # tam_matrix
	movl $0, -8(%ebp) # det
	movl $0, -12(%ebp) # dx
	movl $0, -16(%ebp) # dy
	movl $0, -20(%ebp) # dz


	pushl $titulo
	call printf
	addl $4, %esp

	# Calculando o tamanho da matrix a ser alocada:

	pushl -4(%ebp)
	call _calcula_tamanho
	addl $4, %esp
	movl %eax, -24(%ebp)

	# Alocando o vetor a ser utilizado como matrix
	# para armazenar os coeficientes do sistema:

	########################## ALOCAR MATRIZ ###########################

	pushl $48
	call _aloca_matrix
	addl $4, %esp
	movl %eax, -28(%ebp)

	########################## LE DADOS ###########################

	# Inserir valores na matrix
	pushl -28(%ebp)
	call _le_dados
	addl $4, %esp

	########################## ALOCAR MATRIZ AUX 1 ###########################

	# criar matrix auxiliar
	pushl $48
	call _aloca_matrix
	addl $4, %esp
	movl %eax, -32(%ebp)

	# copia matrix original na auxiliar
	pushl -4(%ebp)
	pushl -32(%ebp)
	pushl -28(%ebp)
	call _copiar_matrix
	addl $12, %esp

	########################## CALCULAR DET ###########################

	pushl -32(%ebp)
	call _detSarrus
	addl $4, %esp
	movl %eax, -8(%ebp)

	########################## REINICIA MATIX AUX ###########################

	# copia matrix original na auxiliar
	pushl -4(%ebp)
	pushl -32(%ebp)
	pushl -28(%ebp)
	call _copiar_matrix
	addl $12, %esp

	########################## INVERTE COLUNA X ###########################
	pushl -32(%ebp)
	pushl $0
	call _inverte_coluna
	addl $8, %esp

	########################## CALCULA DX ###########################
	pushl -32(%ebp)
	call _detSarrus
	addl $4, %esp
	movl %eax, -12(%ebp)

	pushl -20(%ebp)
	pushl -16(%ebp)
	pushl -12(%ebp)
	pushl -8(%ebp)
	pushl $msg_mostra_dets
	call printf
	addl $20, %esp

	jmp _fim

#
# Procedimento para calcular o tamanho do vetor a ser alocado
# Para mudar o tamanho alterar o tamanho da variavel tam_matrix
#
# @parametros:
# tamanho da matrix
#
# @return:
# retorna o tamanho * 4
#
_calcula_tamanho:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	movl $4, %ebx
	mull %ebx
	popl %ebp
	ret

#
# Procedimento para alocar a matrix
#
# @param:
# tamanho a ser alocado
#
# @returns:
# retorna o endereco do espaco alocado
#
_aloca_matrix:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
	pushl %ecx
	call malloc
	addl $4, %esp
	popl %ebp
	ret

_le_dados:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %edi
	pushl $pede_dados
	call printf
	addl $4, %esp
	movl $12, %ecx
	jmp _coloca_na_matrix

_coloca_na_matrix:
	pushl %ecx
	pushl %edi
	pushl $formatoint
	call scanf
	addl $8, %esp
	addl $4, %edi
	popl %ecx
	loop _coloca_na_matrix
	popl %ebp
	ret

#
# Procedimento para imprimir a matrix
#
# @param:
# ptr_matrix
#
_print_matrix:
	pushl %ebp
	movl %esp, %ebp
	pushl $msg_exibe_matrix
	call printf
	addl $4, %esp
	movl $12, %ecx
	movl 8(%ebp), %edi
	jmp _exibe_valores

_exibe_valores:
	pushl %ecx
	movl (%edi), %eax
	pushl %eax
	pushl $formatoint
	call printf
	addl $4, %edi
	addl $8, %esp
	popl %ecx
	loop _exibe_valores
	popl %ebp
	ret

#
# Funcao para copiar matrix em outra
#
# @param:
# matrixorigem
# matrixdestino
# tamanho da matrix
#
# @returns
#
_copiar_matrix:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %esi
	movl 12(%ebp), %edi
	movl $12, %ecx
	jmp _ciclo_copia

_ciclo_copia:
	pushl %ecx
	movl (%esi), %eax
	movl %eax, (%edi)
	addl $4, %edi
	addl $4, %esi
	popl %ecx
	loop _ciclo_copia
	popl %ebp
	ret

_inverte_coluna:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ebx
	movl 12(%ebp), %edi
	subl $16, %esp


	addl $12, %edi
	movl (%edi), %eax
	movl %eax, -4(%ebp)

	addl $16, %edi
	movl (%edi), %eax
	movl %eax, -8(%ebp)

	addl $16, %edi
	movl (%edi),%eax
	movl %eax, -12(%ebp)

	movl 12(%ebp), %edi

	movl $4, %eax
	mull %ebx
	addl %eax, %edi
	movl -4(%ebp), %eax
	movl %eax, (%edi)

	addl $16, %edi
	movl -8(%ebp), %ebx
	movl %ebx, (%edi)

	addl $16, %edi
	movl -12(%ebp), %ebx
	movl %ebx, (%edi)

	addl $16, %esp
	popl %ebp
	ret


_detSarrus:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %edi
	subl $88, %esp

	movl (%edi), %eax
	movl %eax, -4(%ebp)  	#coloca o primeito valor da matriz no a11
	addl $20, %edi		#avanca 20 para pegar o proximo valor a multiplicar
	movl (%edi), %eax
	movl %eax, -20(%ebp)
	movl -4(%ebp), %eax
	movl -20(%ebp), %ebx
	imull %ebx
	movl %eax, -64(%ebp)	#resultado da multiplicacao esta em diag1
	addl $20, %edi
	movl (%edi), %eax
	movl %eax, -36(%ebp)
	movl -64(%ebp), %ebx
	imull %ebx
	movl %eax, -40(%ebp)

	movl 8(%ebp), %edi
	addl $4, %edi
	movl (%edi), %eax
	movl %eax, -8(%ebp)
	addl $20, %edi
	movl (%edi), %eax
	movl %eax, -24(%ebp)
	movl -8(%ebp), %eax
	movl -24(%ebp), %ebx
	imull %ebx
	movl %eax, -68(%ebp) 	#resultado da multiplicacao esta em diag2
	addl $8, %edi
	movl (%edi), %eax
	movl %eax, -28(%ebp)
	movl -28(%ebp), %eax
	movl -68(%ebp), %ebx
	imull %ebx
	movl %eax, -44(%ebp)

	movl 8(%ebp), %edi
	addl $8, %edi
	movl (%edi), %eax
	movl %eax, -12(%ebp)
	addl $8, %edi
	movl (%edi), %eax
	movl %eax, -16(%ebp)
	movl -12(%ebp), %eax
	movl -16(%ebp), %ebx
	imull %ebx
	movl %eax, -72(%ebp)	#resultado da multiplicacao esta em diag3
	addl $20, %edi
	movl (%edi), %eax
	movl %eax, -32(%ebp)
	movl -32(%ebp), %eax
	movl -72(%ebp), %ebx
	imull %ebx
	movl %eax, -48(%ebp)

	movl -40(%ebp), %eax
	addl -44(%ebp), %eax
	addl -48(%ebp), %eax
	movl %eax, -40(%ebp)

	#segunda Parte
	movl 8(%ebp), %edi
	addl $8, %edi
	movl (%edi), %eax
	movl %eax, -12(%ebp)
	addl $12, %edi
	movl (%edi), %eax
	movl %eax, -20(%ebp)
	movl -12(%ebp), %eax
	movl -20(%ebp), %ebx
	imull %ebx
	movl %eax, -76(%ebp)	#resultado da multiplicacao esta em diag4
	addl $12, %edi
	movl (%edi), %eax
	movl %eax, -28(%ebp)
	movl -28(%ebp), %eax
	movl -76(%ebp), %ebx
	imull %ebx
	movl %eax, -52(%ebp)


	movl 8(%ebp), %edi
	movl %edi, -4(%ebp)		#coloca o primeito valor da matriz no a11
	movl (%edi), %eax
	movl %eax, -4(%ebp)
	addl $24, %edi		#avanca 24 para pegar o proximo valor a multiplicar
	movl (%edi), %eax
	movl %eax, -24(%ebp)
	movl -4(%ebp), %eax
	movl -24(%ebp), %ebx
	imull %ebx
	movl %eax, -80(%ebp) 	#resultado da multiplicacao esta em diag5
	addl $12, %edi
	movl (%edi), %eax
	movl %eax, -32(%ebp)
	movl -32(%ebp), %eax
	movl -80(%ebp), %ebx
	imull %ebx
	movl %eax, -56(%ebp)

	movl 8(%ebp), %edi
	addl $4, %edi
	movl (%edi), %eax
	movl %eax, -8(%ebp)
	addl $12, %edi
	movl (%edi), %eax
	movl %eax, -16(%ebp)
	movl -8(%ebp), %eax
	movl -16(%ebp), %ebx
	imull %ebx
	movl %eax, -84(%ebp) 	#resultado da multiplicacao esta em diag6
	addl $24, %edi

	movl (%edi), %eax
	movl %eax, -36(%ebp)
	movl -36(%ebp), %eax
	movl -84(%ebp), %ebx
	imull %ebx
	movl %eax, -60(%ebp)

	movl -52(%ebp), %eax
	addl -56(%ebp), %eax
	addl -60(%ebp), %eax
	movl %eax, -52(%ebp)

	movl -40(%ebp), %eax
	subl -52(%ebp), %eax

	addl $88, %esp
	popl %ebp
	ret

_fim:
	addl $72, %esp
	pushl $0
	call exit
