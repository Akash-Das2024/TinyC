	.file	"test.c"
	.text	
.L2: 
	.globl	main
	.type	main, @function
main: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$40, %rsp

	movl	$5, %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$10, %eax
	movl 	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movl 	%eax, -32(%rbp)
	jmp .L4
.L3: 
	movl	-32(%rbp), %eax
	cmpl	0(%rbp), %eax
	je .L2
	jmp .L5
.L4: 
	movl	-24(%rbp), %eax
	cmpl	0(%rbp), %eax
	je .L2
	jmp .L3
	jmp .L6
.L5: 
	jmp .L2
.L6: 
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by 18CS10069"
	.section	.note.GNU-stack,"",@progbits
