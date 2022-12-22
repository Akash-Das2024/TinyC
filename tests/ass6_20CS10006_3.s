	.file	"test.c"
	.text	
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
	subq	$68, %rsp

	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$0, %eax
	movl 	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movl 	%eax, -32(%rbp)
.L2: 
	movl	$11, %eax
	movl 	%eax, -40(%rbp)
	movl	-24(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl .L3
	jmp .L4
.L3: 
	movl 	-32(%rbp), %eax
	movl 	-24(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movl	-24(%rbp), %eax
	movl 	%eax, -52(%rbp)
	addl 	$1, -24(%rbp)
	jmp .L2
.L4: 
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	printInt
	movl	%eax, -60(%rbp)
	movl	$0, %eax
	movl 	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by 18CS10069"
	.section	.note.GNU-stack,"",@progbits
