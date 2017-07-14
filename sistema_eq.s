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
pede_dados: .asciz "\nEntre com a equacao do tipo Ax + By + Cz = D\n\tNo formato A B C D\n"

formatoint: .asciz "\n%d"
formatocopia: .asciz "\n%d -> %d\n"
pulalinha: .asciz "\n"
naloc: .int 0
ptr_matrix: .int 0
ptr_matrix_aux: .int 0
matrix_aux: .int 0
tam_matrix: .int 12
int_aux: .int 0

.section .text
.globl main

main:

	pushl $titulo
	call printf
	addl $4, %esp

	# Calculando o tamanho da matrix a ser alocada:

	pushl tam_matrix
	call _calcula_tamanho
	addl $4, %esp
	movl %eax, naloc

	# Alocando o vetor a ser utilizado como matrix
	# para armazenar os coeficientes do sistema:
	pushl naloc
	call _aloca_matrix
	addl $4, %esp
	movl %eax, ptr_matrix

	# criar matrix auxiliar
	pushl naloc
	call _aloca_matrix
	addl $4, %esp
	movl %eax, matrix_aux
	movl $matrix_aux, %eax
	movl %eax, ptr_matrix_aux #ponteiro para a matrix 

	# Inserir valores na matrix
	pushl ptr_matrix
 	call _le_dados
	addl $4, %esp

	# Exibe matrix
	pushl ptr_matrix
	call _print_matrix
	pushl $pulalinha
	call printf
	addl $8, %esp

	# copia matrix original na auxiliar
	pushl tam_matrix
	pushl ptr_matrix_aux
	pushl ptr_matrix
	call _copiar_matrix
	addl $12, %esp

	#imprimir matrix copiada de zoa
	pushl ptr_matrix_aux
	call _print_matrix
	pushl $pulalinha
	call printf
	addl $8, %esp



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
	movl tam_matrix, %ecx
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
	pushl $msg_copia_matrix
	call printf
	addl $4, %esp
	popl %ebp
	ret


_fim:
	pushl $0
	call exit
