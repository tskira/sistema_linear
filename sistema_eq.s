.section .data

titulo: .asciz "\n ### RESOLVER SISTEMA LINEAR ###\n"

formatoint: .asciz "\n%d\n"
naloc: .int 0
ptr_matrix: .int 0
tam_matrix: .int 12

.section .text
.globl main

main:
	pushl tam_matrix
	call _calcula_tamanho
	addl $4, %esp
	pushl %eax
	pushl $formatoint
	call printf
	jmp _fim

#
# Procedimento para calcular o tamanho da matrix
# @parametros:
# tamanho da matrix
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

_alocamatrix:

_printmatrix:


_fim:
	pushl $0
	call exit
