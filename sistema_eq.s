#
#	TRAMPO 1 DE PIHS
#	PROFESSOR: RONALDAO
#	ALUNOS: THIAGO KIRA
#  			CHEROSO MARINGA
#
# 	"Na escuridao o teu olhar me iluminava
# 	 E minha estrela guia era o teu riso"
#

.section .data

titulo: .asciz "\n ### A RUA E NOIS ###\n"

formatoint: .asciz "\n%d\n"
naloc: .int 0
ptr_matrix: .int 0
tam_matrix: .int 12

.section .text
.globl main

main:
								# Calculando o tamanho da matrix a ser alocada:
								#
	pushl tam_matrix			#	passa o primeiro parametro de _cacula_tamanho
	call _calcula_tamanho 		# 	chama a funcao
	addl $4, %esp				#	limpa a pilha
	movl %eax, naloc			#	coloca o valor calculado na variavel naloc

								# Alocando o vetor a ser utilizado como matrix
								# para armazenar os coeficientes do sistema:
								#
	pushl naloc					# passa o primeiro parametro
	call _aloca_matrix			# chama a funcao
	addl $4, %esp				# limpa a pilha
	movl %eax, ptr_matrix		# salva o espaco alocado no ponteiro ptr_matrix

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

_print_matrix:


_fim:
	pushl $0
	call exit
