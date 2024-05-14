.eqv char $s7
.eqv digito $s6
.eqv index_lb $t0
.eqv index_sw $t1 
.eqv multiplicador $t2
.eqv num $t3 
.eqv buffer $s0 
.data

	fileName: .asciiz "lista.txt"
	          .align 2
	inputBuffer: .space 400 
		.align 2
	message: .asciiz "Números ordenados: "
.text 
    li index_lb, 0
    li index_sw, 0
start: 
    li     num, 0
    li     multiplicador, 1
open_file: 
	li $v0, 13 #open file 
	la $a0, fileName 
	li $a1, 0
	li $a2, 0
	syscall 
	move buffer, $v0 
read_file: 
	li $v0, 14 #read file 
	move $a0, $s0
	la $a1, inputBuffer 
	li $a2, 400
	syscall 
	move buffer, $v0
conversor: 
	lb char, inputBuffer(index_lb)
	add index_lb, index_lb, 1
	beq char, 0, store
	beq char, '-', sinal
	beq char, ',', store
	sub digito, char, 0x30
	mul num, num, 10
	add num, num, digito
	j conversor
sinal: 
	li multiplicador, -1
	j  conversor
store: 
	mul num, num, multiplicador
	sw num, inputBuffer(index_sw)
	add index_sw, index_sw, 4
	beq char, 0, main
	j start
main:
	la $s7, inputBuffer #endereço do array com os número inteiros convertidos 
	li $s0, 0	#contador 1 para o primeiro loop (loop)
	li $s6, 99	#qtd números da lista - 1 (n-1)
	li $s1, 0 	#contador 2 para o segundo loop (increment) 
	li $t3, 0	#contador para printar os números
	li $t4, 100	#quantidade de números a serem printados 
	li $v0, 4	#print string 
	la $a0, message
	syscall
sort:
	sll $t7, $s1, 2	#multiplica s1 por 2 e coloca em t7
	add $t7, $s7, $t7 #adiciona o endereço de inputBuffer para t7
	lw $t0, 0($t7)  #load inputBuffer[j]
	lw $t1, 4($t7) 	#load inputBuffer[j+1]
	slt $t2, $t0, $t1 #if t0 < t1 
	bne $t2, $zero, incrementar
	sw $t1, 0($t7) 	#trocando posição do mair pelo menor
	sw $t0, 4($t7)
incrementar:
	addi $s1, $s1, 1 #incrementando s1
	sub $s5, $s6, $s0 #subtraindo s6-s0 e armazenando em s5
	bne  $s1, $s5, sort	#se s1 (contador do segundo loop) não for igual, volte para o loop 
	addi $s0, $s0, 1 #se não for, adicione 1 ao s0
	li $s1, 0 #resetar s1 para 0 
	bne  $s0, $s6, sort # se s0 não for igual ao número total que deve ser percorrido (100) então  volta para o loop 
printar:
	beq $t3, $t4, exit #se t3 = t4 encerre o programa 
	lw $t5, 0($s7) 	#load de inputBuffer
	li $v0, 1	#printando o número
	move $a0, $t5
	syscall
	li $a0, 32	#print espaço em branco 
	li $v0, 11     #print charactere
	syscall
	addi $s7, $s7, 4 #incrementando os números ( 1 número = 4 bytes) 
	addi $t3, $t3, 1 #contador dos números
	j printar
exit: 
	li $v0, 10
	syscall 

	
