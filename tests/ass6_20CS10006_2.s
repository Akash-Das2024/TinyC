	.file	"test.c"
	.section	.rodata
.LC0:
	.string	"Enter two number\n"
.LC1:
	.string	"GCD: "
	.text	
	.globl	GCD
	.type	GCD, @function
GCD: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$52, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
.L2: 
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jne .L3
	jmp .L7
.L3: 
	movl	-20(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jge .L4
	jmp .L5
	jmp .L6
.L4: 
	movl 	-20(%rbp), %eax
	movl 	-16(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl 	%eax, -20(%rbp)
	jmp .L2
.L5: 
	movl 	-16(%rbp), %eax
	movl 	-20(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movl 	%eax, -16(%rbp)
.L6: 
	jmp .L2
.L7: 
	movl	-16(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	GCD, .-GCD
	.globl	main
	.type	main, @function
main: 
.LFB1:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$96, %rsp

	movq 	$.LC0, -36(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	printStr
	movl	%eax, -40(%rbp)
	leaq	-24(%rbp), %rax
	movq 	%rax, -48(%rbp)
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdi
	call	readInt
	movl	%eax, -52(%rbp)
	leaq	-28(%rbp), %rax
	movq 	%rax, -56(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call	readInt
	movl	%eax, -60(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rsi
	call	GCD
	movl	%eax, -72(%rbp)
	movl	-72(%rbp), %eax
	movl 	%eax, -64(%rbp)
	movq 	$.LC1, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call	printStr
	movl	%eax, -80(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call	printInt
	movl	%eax, -88(%rbp)
	movl	$0, %eax
	movl 	%eax, -92(%rbp)
	movl	-92(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident		"Compiled by 18CS10069"
	.section	.note.GNU-stack,"",@progbits
