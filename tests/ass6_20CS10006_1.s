	.file	"test.c"
	.comm	a,4,4
	.comm	b,4,4
	.section	.rodata
.LC0:
	.string	"The Sum of a = "
.LC1:
	.string	"and b = "
.LC2:
	.string	"is equal to: "
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
	subq	$108, %rsp

	movl	$5, %eax
	movl 	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movl	$10, %eax
	movl 	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	movl 	%eax, -40(%rbp)
	movl 	-28(%rbp), %eax
	movl 	-40(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -52(%rbp)
	movl	-52(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movq 	$.LC0, -64(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call	printStr
	movl	%eax, -68(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printInt
	movl	%eax, -76(%rbp)
	movq 	$.LC1, -80(%rbp)
	movl 	-80(%rbp), %eax
	movq 	-80(%rbp), %rdi
	call	printStr
	movl	%eax, -84(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call	printInt
	movl	%eax, -88(%rbp)
	movq 	$.LC2, -92(%rbp)
	movl 	-92(%rbp), %eax
	movq 	-92(%rbp), %rdi
	call	printStr
	movl	%eax, -96(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call	printInt
	movl	%eax, -100(%rbp)
	movl	$0, %eax
	movl 	%eax, -104(%rbp)
	movl	-104(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by 18CS10069"
	.section	.note.GNU-stack,"",@progbits
