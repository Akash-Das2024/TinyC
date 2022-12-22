	.file	"test.c"
	.section	.rodata
.LC0:
	.string	"Enter a number upto which you want to evaluate Fibonacci number: "
.LC1:
	.string	"\n"
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
	subq	$132, %rsp

	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$1, %eax
	movl 	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movq 	$.LC0, -56(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call	printStr
	movl	%eax, -60(%rbp)
	leaq	-48(%rbp), %rax
	movq 	%rax, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	readInt
	movl	%eax, -72(%rbp)
	movl	$2, %eax
	movl 	%eax, -76(%rbp)
	movl	-76(%rbp), %eax
	movl 	%eax, -44(%rbp)
.L2: 
	movl	-44(%rbp), %eax
	cmpl	-48(%rbp), %eax
	jl .L4
	jmp .L5
.L3: 
	movl	$1, %eax
	movl 	%eax, -84(%rbp)
	movl 	-44(%rbp), %eax
	movl 	-84(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -88(%rbp)
	movl	-88(%rbp), %eax
	movl 	%eax, -44(%rbp)
	jmp .L2
.L4: 
	movl 	-24(%rbp), %eax
	movl 	-32(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -96(%rbp)
	movl	-96(%rbp), %eax
	movl 	%eax, -40(%rbp)
	movl	-32(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	-40(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call	printInt
	movl	%eax, -116(%rbp)
	movq 	$.LC1, -120(%rbp)
	movl 	-120(%rbp), %eax
	movq 	-120(%rbp), %rdi
	call	printStr
	movl	%eax, -124(%rbp)
	jmp .L3
.L5: 
	movl	$0, %eax
	movl 	%eax, -128(%rbp)
	movl	-128(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by 18CS10069"
	.section	.note.GNU-stack,"",@progbits
