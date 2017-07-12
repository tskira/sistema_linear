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
pede_dados: .asciz "\nEntre com a equacao do tipo Ax + By + Cz = D\n\tNo formato A B C D\n"

formatoint: .asciz "\n%d"
pulalinha: .asciz "\n"
naloc: .int 0
ptr_matrix: .int 0
tam_matrix: .int 12

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

	# Inserir valores na matrix
 	call _le_dados

	# Exibe matrix
	pushl tam_matrix
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
	pushl $pede_dados
	call printf
	addl $4, %esp
	movl ptr_matrix, %edi
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
# tamanho da matrix
#
_print_matrix:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
	movl ptr_matrix, %edi
	jmp _exibe_valores

_exibe_valores:
	pushl %ecx
	pushl (%edi)
	pushl $formatoint
	call printf
	addl $4, %edi
	addl $8, %esp
	popl %ecx
	loop _exibe_valores
	popl %ebp
	ret

_fim:
	pushl $0
	call exit
