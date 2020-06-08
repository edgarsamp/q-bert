#################################################################################
#										#
#										#
#	Antonio Vinicius de Moura Rodrigues	- 19/0084502			#
#	     Edgar Sampaio de Barros		- 16/0005213			#
#										#
#										#
#################################################################################

.data
.include "balao.s"
.include "qbert_q.s"
.include "qbert_e.s"
.include "qbert_a.s"
.include "qbert_d.s"

.include "tampao.s"
.include "level1_final.s"
.include "level1.s"

.include "tampao2.s"
.include "level2_ganhou.s"
.include "level2.s"

.include "menu.s"
.include "help.s"
.include "credits.s"



qbert_tabu1: .word 0xFF002398, 0xFF0042c8, 0xFF0042e8, 0xFF0061f8, 0xFF006218, 0xFF006238, 0xFF008128, 0xFF008148, 0xFF008168, 0xFF008188, 0xFF00a058, 0xFF00a078, 0xFF00a098, 0xFF00a0b8, 0xFF00a0d8, 0xFF00bf88, 0xFF00bfa8, 0xFF00bfc8, 0xFF00bfe8, 0xFF00c008, 0xFF00c028, 0xFF00deb8, 0xFF00ded8, 0xFF00def8, 0xFF00df18, 0xFF00df38, 0xFF00df58, 0xFF00df78
tabuleiro1:  .word 0xff002d90, 0xff004cc0, 0xff004ce0, 0xff006bf0, 0xff006c10, 0xff006c30, 0xff008b20, 0xff008b40, 0xff008b60, 0xff008b80, 0xff00aa50, 0xff00aa70, 0xff00aa90, 0xff00aab0, 0xff00aad0, 0xff00c980, 0xff00c9a0, 0xff00c9c0, 0xff00c9e0, 0xff00ca00, 0xff00ca20, 0xff00e8b0, 0xff00e8d0, 0xff00e8f0, 0xff00e910, 0xff00e930, 0xff00e950, 0xff00e970
tampas1: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
pulo1: 	    .word 79, 140, 73, 140, 75, 140

num_notas1: .word 3
qbert_pos1: .word 1, 1, 1,  # linha, posicao na linha, indice
pos_temp1:  .word 0xFF002398, 1
qnt_pint1:  .word 0
let1:	   .word 100

qbert_tabu2: .word 0xFF002398, 0xFF0042c8, 0xFF0042e8, 0xFF0061f8, 0xFF006218, 0xFF006238, 0xFF008128, 0xFF008148, 0xFF008168, 0xFF008188, 0xFF00a058, 0xFF00a078, 0xFF00a098, 0xFF00a0b8, 0xFF00a0d8, 0xFF00bf88, 0xFF00bfa8, 0xFF00bfc8, 0xFF00bfe8, 0xFF00c008, 0xFF00c028, 0xFF00deb8, 0xFF00ded8, 0xFF00def8, 0xFF00df18, 0xFF00df38, 0xFF00df58, 0xFF00df78
tabuleiro2:  .word 0xff002d90, 0xff004cc0, 0xff004ce0, 0xff006bf0, 0xff006c10, 0xff006c30, 0xff008b20, 0xff008b40, 0xff008b60, 0xff008b80, 0xff00aa50, 0xff00aa70, 0xff00aa90, 0xff00aab0, 0xff00aad0, 0xff00c980, 0xff00c9a0, 0xff00c9c0, 0xff00c9e0, 0xff00ca00, 0xff00ca20, 0xff00e8b0, 0xff00e8d0, 0xff00e8f0, 0xff00e910, 0xff00e930, 0xff00e950, 0xff00e970
tampas2:	    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
pulo2: 	    .word 79, 140, 73, 140, 75, 140

num_notas2: .word 3
qbert_pos2: .word 1, 1, 1,  # linha, posicao na linha, indice
pos_temp2:  .word 0xFF002398, 1
qnt_pint2:  .word 0
let2:	   .word 100


pos_opcao: .word 0xFF009ec8, 0xff00b908, 0xff00d348, 0xff00ed88
#0xFF00097e, 0x00000968, 0x00000954, 0x0000093f

opcao: .word 0

######### Fase 1 #######

.macro fase_1 ()
	li a1, 0xFF000000	# endereco inicial
	printIMG(level1) 	#imprime fundo
	
	li a1, 0xFF002398	
	printIMG(qbert_d)	# imprime qbert
	
################
	#Le teclado
	la tp,KDInterrupt	
 	csrrw zero,5,tp 	
 	csrrsi zero,0,1 	
	li tp,0x100
 	csrrw zero,4,tp		

 	li t5,0xFF200000	
	li t0,0x02		
	sw t0,0(t5)   		
  
	li s0,0			
CONTA:	addi s0,s0,1 		
	j CONTA			

KDInterrupt:	csrrci zero,0,1 	# clear o bit de habilita��o de interrup��o global em ustatus (reg 0)

le_tecla1:  	
		li a1, 0xFF000000		#360*16 = 5760, pula 15 linhas
		printIMG(level1)
		
joga1:		
		lw t2,4(t5)  			# le a tecla
		
	#Toca o som do pulo
	la s0, num_notas1	# define o endere�o do n�mero de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,pulo1		# define o endere�o das notas
	li t0,0			# zera o contador de notas
	li a2,68		# define o instrumento
	li a3,127		# define o volume
	
	
	loop_pulo_som1:	
	beq t0,s1, compara_tecla1		# contador chegou no final? ent�o  v� para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a dura��o da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endere�o da pr�xima nota
	addi t0,t0,1		# incrementa o contador de notas
	j loop_pulo_som1		# volta ao loop
	
	###
compara_tecla1:
#
		
		addi t6, zero, 113		# t6 = Q
 	 	beq t2, t6, tecla_q1		# Se apertou Q
  		
  		addi t6, zero, 101		# t6 = E
  		beq t2, t6, tecla_e1		# Se apertou E
  		
  		addi t6, zero, 97		# t6 = A
  		beq t2, t6, tecla_a1		# Se apertou A
  	
 		addi t6, zero, 100		# t6 = D
  		beq t2, t6, tecla_d1		# Se apertou D

leteclafora1:
		csrrsi zero,0,0x10 	# seta o bit de habilita��o de interrup��o em ustatus 
		uret			# retorna PC=uepc		
		
tecla_q1:
	la t0, let1
	sw t6, 0(t0)

	la t0, qbert_pos1	# salva a posicao temporaria do qbert
	lw t1, 8(t0)		# Salva o indice em t1
	addi t3, t1, 0
	addi t1, t1, -1
	addi t2, zero, 4	# t2 = 4
	mul t1, t1, t2		# Salva em t1 o resgistrador da posicao
	la t0, qbert_tabu1	#
	add t0, t0, t1		# Move 
	lw t1, 0(t0)
	la t0, pos_temp1
	sw t1, 0(t0)
	sw t3, 4(t0)
	
	la t0, qbert_pos1	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	sub t4, t1, t3		# t4 = indice - linhaq
	addi t4, t4, -1		# t4-1
	addi t1, zero, 4
	mul t4, t4, t1		# t4*4
	
	la t0, qbert_tabu1
	add t0, t0, t4
	
	lw a1, 0(t0)

	la t0, qbert_pos1	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	sub t1, t1, t3		# atualiza o indice
	addi t2, t2, -1		# atualiza a posicao da linha
	addi t3, t3, -1		# atualiza a linha
	
	j check1

tecla_e1:
	la t0, let1
	sw t6, 0(t0)

	la t0, qbert_pos1	# salva a posicao temporaria do qbert
	lw t1, 8(t0)		# Salva o indice em t1
	addi t3, t1, 0
	addi t1, t1, -1
	addi t2, zero, 4	# t2 = 4
	mul t1, t1, t2		# Salva em t1 o resgistrador da posicao
	la t0, qbert_tabu1	#
	add t0, t0, t1		# Move 
	lw t1, 0(t0)
	la t0, pos_temp1
	sw t1, 0(t0)
	sw t3, 4(t0)
	
	la t0, qbert_pos1	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	sub t4, t1, t3		# t4 = indice - linha
	addi t4, t4, 0		# t4-1
	addi t1, zero, 4
	mul t4, t4, t1		# t4*4
	
	la t0, qbert_tabu1
	add t0, t0, t4
	
	lw a1, 0(t0)
	
	la t0, qbert_pos1	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	sub t1, t1, t3		
	addi t1, t1, 1		# atualiza o indice
	addi t2, t2, 0		# atualiza a posicao da linha
	addi t3, t3, -1		# atualiza a linha
	
	j check1
	
	#atualiza no vetor
	sw t1, 8(t0) 		
	sw t2, 4(t0) 		
	sw t3, 0(t0)		
	
	j leteclafora1

tecla_a1:
	la t0, let1
	sw t6, 0(t0)

	la t0, qbert_pos1	# salva a posicao temporaria do qbert
	lw t1, 8(t0)		# Salva o indice em t1
	addi t3, t1, 0
	addi t1, t1, -1
	addi t2, zero, 4	# t2 = 4
	mul t1, t1, t2		# Salva em t1 o resgistrador da posicao
	la t0, qbert_tabu1	#
	add t0, t0, t1		# Move 
	lw t1, 0(t0)
	la t0, pos_temp1
	sw t1, 0(t0)
	sw t3, 4(t0)
	
	la t0, qbert_pos1	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	add t4, t1, t3		# t4 = indice + linha
	addi t4, t4, -1		# t4-1
	addi t1, zero, 4
	mul t4, t4, t1		# t4*4
	
	la t0, qbert_tabu1
	add t0, t0, t4
	
	lw a1, 0(t0)
	
	la t0, qbert_pos1	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	add t1, t1, t3		# atualiza o indice
	addi t2, t2, 0		# atualiza a posicao da linha
	addi t3, t3, 1		# atualiza a linha
	
	j check1
	
tecla_d1:
	la t0, let1
	sw t6, 0(t0)

	la t0, qbert_pos1	# salva a posicao temporaria do qbert
	lw t1, 8(t0)		# Salva o indice em t1
	addi t3, t1, 0
	addi t1, t1, -1
	addi t2, zero, 4	# t2 = 4
	mul t1, t1, t2		# Salva em t1 o resgistrador da posicao
	la t0, qbert_tabu1	#
	add t0, t0, t1		# Move 
	lw t1, 0(t0)
	la t0, pos_temp1
	sw t1, 0(t0)
	sw t3, 4(t0)
	
	la t0, qbert_pos1	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	add t4, t1, t3		# t4 = indice - linha
	addi t1, zero, 4
	mul t4, t4, t1		# t4*4
	
	la t0, qbert_tabu1
	add t0, t0, t4
	
	lw a1, 0(t0)
	
	la t0, qbert_pos1	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	add t1, t1, t3		# atualiza o indice
	add t1, t1, 1
	addi t2, t2, 1		# atualiza a posicao da linha
	addi t3, t3, 1		# atualiza a linha
	
	j check1

morreu1: la t0, pos_temp1
	lw a1, 0(t0)
	printIMG(balao)
	
	j leteclafora1
	
check1:  
	blt t3, t2, morreu1		# Se a linha < pos.linha
	addi t4, zero, 1
	blt t2, t4, morreu1	# Se pos.linha < 1
	blt t3, zero, morreu1	# Se linha < 0 
	addi t4, zero, 7
	blt t4, t3, morreu1		# Se 7 < linha 
	
	#atualiza no vetor	
	sw t1, 8(t0) 
	sw t2, 4(t0) 
	sw t3, 0(t0)
	

	la t3, tampas1
	li t4, 28
	
loop1:	beq t4, zero,imp_qb1
	lw t0, 0(t3)
	addi t3, t3, 4
	addi t4, t4, -1
	beq t0, zero, loop1
	add a1, t0, zero
	printIMG(tampao)
	j loop1
	

	
imp_qb1:	
	la t0, let1
	lw t2, 0(t0)
	
	la t0, qbert_pos1
	lw t1, 8(t0)
	addi t1, t1, -1
	addi t0, zero, 4
	mul t1, t1, t0
	la t0, qbert_tabu1
	add t0, t0, t1
	lw a1, 0(t0)
	
	addi t6, zero, 113		# t6 = Q
 	beq t2, t6, q_pos1		# Se apertou Q
  		
  	addi t6, zero, 101		# t6 = E
  	beq t2, t6, e_pos1		# Se apertou E
  		
  	addi t6, zero, 97		# t6 = A
  	beq t2, t6, a_pos1		# Se apertou A
  	
 	addi t6, zero, 100		# t6 = D
  	beq t2, t6, d_pos1		# Se apertou D
	
q_pos1:	printIMG(qbert_q)
	j att_tampa1

e_pos1:	printIMG(qbert_e)
	j att_tampa1

a_pos1:	printIMG(qbert_a)
	j att_tampa1

d_pos1:	printIMG(qbert_d)
	j att_tampa1
	
att_tampa1:
	la t0, qbert_pos1
	lw t1, 8(t0)		# t1 = qbert_pos.indice
	addi t1, t1, -1
	addi t2, zero, 4	# t2 = 4
	mul t1, t1, t2		# t1 = 4*t1
	la t0, tabuleiro1
	add t0, t0, t1
	lw t2, 0(t0)
	la t0, tampas1
	add t0, t0, t1
	sw t2, 0(t0)

	la t3, tampas1
	li t4, 28
	li t1, 0
	
loop21:	beq t4, zero, fora_loop21
	lw t0, 0(t3)
	addi t3, t3, 4
	addi t4, t4, -1
	blt t0, zero, loop21
	addi t1, t1, 1
	j loop21
	
fora_loop21:

	addi t3, zero, 0
	beq t1, t3, ganhou1
	j leteclafora1
	
ganhou1:
	li a1, 0xFF000000		#360*16 = 5760, pula 15 linhas
	printIMG(level1_final)
	
.end_macro

#### fase 2 ###

.macro fase_2 ()
	li a1, 0xFF000000	# endereco inicial
	printIMG(level2) 	#imprime fundo
	
	li a1, 0xFF002398	
	printIMG(qbert_d)	# imprime qbert
	
################
	#Le teclado
	la tp,KDInterrupt2	
 	csrrw zero,5,tp 	
 	csrrsi zero,0,1 	
	li tp,0x100
 	csrrw zero,4,tp		

 	li t5,0xFF200000	
	li t0,0x02		
	sw t0,0(t5)   		
  
	li s0,0			
CONTA2:	addi s0,s0,1 		
	j CONTA2			

KDInterrupt2:	csrrci zero,0,1 	# clear o bit de habilita��o de interrup��o global em ustatus (reg 0)

le_tecla2:  	
		li a1, 0xFF000000		#360*16 = 5760, pula 15 linhas
		printIMG(level2)
		
joga2:		
		lw t2,4(t5)  			# le a tecla
		
	#Toca o som do pulo
	la s0, num_notas2	# define o endere�o do n�mero de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,pulo2		# define o endere�o das notas
	li t0,0			# zera o contador de notas
	li a2,68		# define o instrumento
	li a3,127		# define o volume
	
	
	loop_pulo_som2:	
	beq t0,s1, compara_tecla2		# contador chegou no final? ent�o  v� para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a dura��o da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endere�o da pr�xima nota
	addi t0,t0,1		# incrementa o contador de notas
	j loop_pulo_som2		# volta ao loop
	
	###
compara_tecla2:
#
		
		addi t6, zero, 113		# t6 = Q
 	 	beq t2, t6, tecla_q2		# Se apertou Q
  		
  		addi t6, zero, 101		# t6 = E
  		beq t2, t6, tecla_e2		# Se apertou E
  		
  		addi t6, zero, 97		# t6 = A
  		beq t2, t6, tecla_a2		# Se apertou A
  	
 		addi t6, zero, 100		# t6 = D
  		beq t2, t6, tecla_d2		# Se apertou D

leteclafora2:
		csrrsi zero,0,0x10 	# seta o bit de habilita��o de interrup��o em ustatus 
		uret			# retorna PC=uepc		
		
tecla_q2:
	la t0, let2
	sw t6, 0(t0)

	la t0, qbert_pos2	# salva a posicao temporaria do qbert
	lw t1, 8(t0)		# Salva o indice em t1
	addi t3, t1, 0
	addi t1, t1, -1
	addi t2, zero, 4	# t2 = 4
	mul t1, t1, t2		# Salva em t1 o resgistrador da posicao
	la t0, qbert_tabu2	#
	add t0, t0, t1		# Move 
	lw t1, 0(t0)
	la t0, pos_temp2
	sw t1, 0(t0)
	sw t3, 4(t0)
	
	la t0, qbert_pos2	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	sub t4, t1, t3		# t4 = indice - linhaq
	addi t4, t4, -1		# t4-1
	addi t1, zero, 4
	mul t4, t4, t1		# t4*4
	
	la t0, qbert_tabu2
	add t0, t0, t4
	
	lw a1, 0(t0)

	la t0, qbert_pos2	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	sub t1, t1, t3		# atualiza o indice
	addi t2, t2, -1		# atualiza a posicao da linha
	addi t3, t3, -1		# atualiza a linha
	
	j check2

tecla_e2:
	la t0, let2
	sw t6, 0(t0)

	la t0, qbert_pos2	# salva a posicao temporaria do qbert
	lw t1, 8(t0)		# Salva o indice em t1
	addi t3, t1, 0
	addi t1, t1, -1
	addi t2, zero, 4	# t2 = 4
	mul t1, t1, t2		# Salva em t1 o resgistrador da posicao
	la t0, qbert_tabu2	#
	add t0, t0, t1		# Move 
	lw t1, 0(t0)
	la t0, pos_temp2
	sw t1, 0(t0)
	sw t3, 4(t0)
	
	la t0, qbert_pos2	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	sub t4, t1, t3		# t4 = indice - linha
	addi t4, t4, 0		# t4-1
	addi t1, zero, 4
	mul t4, t4, t1		# t4*4
	
	la t0, qbert_tabu2
	add t0, t0, t4
	
	lw a1, 0(t0)
	
	la t0, qbert_pos2	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	sub t1, t1, t3		
	addi t1, t1, 1		# atualiza o indice
	addi t2, t2, 0		# atualiza a posicao da linha
	addi t3, t3, -1		# atualiza a linha
	
	j check2
	
	#atualiza no vetor
	sw t1, 8(t0) 		
	sw t2, 4(t0) 		
	sw t3, 0(t0)		
	
	j leteclafora2

tecla_a2:
	la t0, let2
	sw t6, 0(t0)

	la t0, qbert_pos2	# salva a posicao temporaria do qbert
	lw t1, 8(t0)		# Salva o indice em t1
	addi t3, t1, 0
	addi t1, t1, -1
	addi t2, zero, 4	# t2 = 4
	mul t1, t1, t2		# Salva em t1 o resgistrador da posicao
	la t0, qbert_tabu2	#
	add t0, t0, t1		# Move 
	lw t1, 0(t0)
	la t0, pos_temp2
	sw t1, 0(t0)
	sw t3, 4(t0)
	
	la t0, qbert_pos2	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	add t4, t1, t3		# t4 = indice + linha
	addi t4, t4, -1		# t4-1
	addi t1, zero, 4
	mul t4, t4, t1		# t4*4
	
	la t0, qbert_tabu2
	add t0, t0, t4
	
	lw a1, 0(t0)
	
	la t0, qbert_pos2	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	add t1, t1, t3		# atualiza o indice
	addi t2, t2, 0		# atualiza a posicao da linha
	addi t3, t3, 1		# atualiza a linha
	
	j check2
	
tecla_d2:
	la t0, let2
	sw t6, 0(t0)

	la t0, qbert_pos2	# salva a posicao temporaria do qbert
	lw t1, 8(t0)		# Salva o indice em t1
	addi t3, t1, 0
	addi t1, t1, -1
	addi t2, zero, 4	# t2 = 4
	mul t1, t1, t2		# Salva em t1 o resgistrador da posicao
	la t0, qbert_tabu2	#
	add t0, t0, t1		# Move 
	lw t1, 0(t0)
	la t0, pos_temp2
	sw t1, 0(t0)
	sw t3, 4(t0)
	
	la t0, qbert_pos2	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	add t4, t1, t3		# t4 = indice - linha
	addi t1, zero, 4
	mul t4, t4, t1		# t4*4
	
	la t0, qbert_tabu2
	add t0, t0, t4
	
	lw a1, 0(t0)
	
	la t0, qbert_pos2	# linha em que o jogador esta
	lw t1, 8(t0) 		# salva em t1 o indice
	lw t2, 4(t0) 		# salva em t2 a posicao da linha
	lw t3, 0(t0)		# salva em t3 a linha
	
	add t1, t1, t3		# atualiza o indice
	add t1, t1, 1
	addi t2, t2, 1		# atualiza a posicao da linha
	addi t3, t3, 1		# atualiza a linha
	
	j check2

morreu2: la t0, pos_temp2
	lw a1, 0(t0)
	printIMG(balao)
	
	j leteclafora2
	
check2:  
	blt t3, t2, morreu2		# Se a linha < pos.linha
	addi t4, zero, 1
	blt t2, t4, morreu2	# Se pos.linha < 1
	blt t3, zero, morreu2	# Se linha < 0 
	addi t4, zero, 7
	blt t4, t3, morreu2		# Se 7 < linha 
	
	#atualiza no vetor	
	sw t1, 8(t0) 
	sw t2, 4(t0) 
	sw t3, 0(t0)
	

	la t3, tampas2
	li t4, 28
	
loop2:	beq t4, zero,imp_qb2
	lw t0, 0(t3)
	addi t3, t3, 4
	addi t4, t4, -1
	beq t0, zero, loop2
	add a1, t0, zero
	printIMG(tampao2)
	j loop2
	

	
imp_qb2:	
	la t0, let2
	lw t2, 0(t0)
	
	la t0, qbert_pos2
	lw t1, 8(t0)
	addi t1, t1, -1
	addi t0, zero, 4
	mul t1, t1, t0
	la t0, qbert_tabu2
	add t0, t0, t1
	lw a1, 0(t0)
	
	addi t6, zero, 113		# t6 = Q
 	beq t2, t6, q_pos2		# Se apertou Q
  		
  	addi t6, zero, 101		# t6 = E
  	beq t2, t6, e_pos2		# Se apertou E
  		
  	addi t6, zero, 97		# t6 = A
  	beq t2, t6, a_pos2		# Se apertou A
  	
 	addi t6, zero, 100		# t6 = D
  	beq t2, t6, d_pos2		# Se apertou D
	
q_pos2:	printIMG(qbert_q)
	j att_tampa2

e_pos2:	printIMG(qbert_e)
	j att_tampa2

a_pos2:	printIMG(qbert_a)
	j att_tampa2

d_pos2:	printIMG(qbert_d)
	j att_tampa2
	
att_tampa2:
	la t0, qbert_pos2
	lw t1, 8(t0)		# t1 = qbert_pos.indice
	addi t1, t1, -1
	addi t2, zero, 4	# t2 = 4
	mul t1, t1, t2		# t1 = 4*t1
	la t0, tabuleiro2
	add t0, t0, t1
	lw t2, 0(t0)
	la t0, tampas2
	add t0, t0, t1
	sw t2, 0(t0)

	la t3, tampas2
	li t4, 28
	li t1, 0
	
loop22:	beq t4, zero, fora_loop22
	lw t0, 0(t3)
	addi t3, t3, 4
	addi t4, t4, -1
	blt t0, zero, loop22
	addi t1, t1, 1
	j loop22
	
fora_loop22:
	addi t3, zero, 0
	beq t1, t3, ganhou2
	j leteclafora2
	
ganhou2:
	li a1, 0xFF000000		#360*16 = 5760, pula 15 linhas
	printIMG(level2_ganhou)
	
fim1:	li a7,10				# syscall de exit
	ecall
	
.end_macro

####


.macro printIMG(%img)
	la a0, %img	# qual img vai imprimir
	lw a2, 4(a0) 	# altura
	lw a3, 0(a0) 	# largura
	srli a3, a3, 2	# largura // 4 == largura >> 2
	addi a0, a0, 8	# vetor de bytes origem 
	print_linhas:
		blez a2, print_fim	# enquanto a2 > 0
		mv t0, a1		# endereço do inicio linha atual
		mv t1, a3		# t1 = largura
		print_colunas:
			blez t1, print_out	# enquanto t1 > 0
			lw t2, 0(a0)	# le uma word do vetor
			sw t2, 0(t0)	# Salva no display a word lida do vetor 
			addi a0, a0, 4
			addi t0, t0, 4
			addi t1, t1, -1 	# t1 --
			j print_colunas
		print_out:
		addi a1, a1, 320
		addi a2, a2, -1 	# a2--
		j print_linhas
	print_fim:
.end_macro

.text


	li a1, 0xFF000000	# endereco inicial
	printIMG(menu) 	#imprime fundo
	
	li a1, 0xFF009EC8	
	printIMG(qbert_d)	# imprime qbert
	
	#Le teclado
	la tp,KDInterrupt2	
 	csrrw zero,5,tp 	
 	csrrsi zero,0,1 	
	li tp,0x100
 	csrrw zero,4,tp		

 	li t5,0xFF200000	
	li t0,0x02		
	sw t0,0(t5)   		
  
	li s0,0			
CONTA2:	addi s0,s0,1 		
	j CONTA2			

KDInterrupt2:	csrrci zero,0,1 	# clear o bit de habilita��o de interrup��o global em ustatus (reg 0)
	
	lw t2,4(t5)  			# le a tecla

	
	addi t6, zero, 113		# t6 = Q
 	beq t2, t6, q_menu		# Se apertou Q

  	addi t6, zero, 97		# t6 = A
  	beq t2, t6, a_menu		# Se apertou A
  
  	addi t6, zero, 10		# t6 = A
  	beq t2, t6, enter_menu		# Se apertou A

leteclafora2:
		csrrsi zero,0,0x10 	# seta o bit de habilita��o de interrup��o em ustatus 
		uret			# retorna PC=uepc
		
q_menu:
	li a1, 0xFF000000	# endereco inicial
	printIMG(menu) 	#imprime fundo
	
	la t0, opcao
	lw t1, 0(t0)
	addi t1, t1, -1
	sw t1, 0(t0)
	li t4, 4
	mul t1, t1, t4
	la t0, pos_opcao
	add t0, t0, t1
	lw a1, 0(t0)
	printIMG(qbert_d)
	
	j leteclafora2

a_menu:	
	li a1, 0xFF000000	# endereco inicial
	printIMG(menu) 	#imprime fundo
	
	
	la t0, opcao
	lw t1, 0(t0)
	addi t1, t1, 1
	sw t1, 0(t0)
	li t4, 4
	mul t1, t1, t4
	la t0, pos_opcao
	add t0, t0, t1
	lw a1, 0(t0)
	printIMG(qbert_d)
	
	j leteclafora2
	
enter_menu:
	la t0, opcao
	lw t1, 0(t0)
	
	addi t6, zero, 0	
  	beq t1, t6, jogo
  
  	addi t6, zero, 1	
  	beq t1, t6, help_tela
  	
  	addi t6, zero, 2	
  	beq t1, t6, credit_tela
  	
  	addi t6, zero, 3	
  	beq t1, t6,fim	
	
jogo:
	fase_1()
	
	addi a0, zero, 1700
	li a7, 32			# Espera 1.7 segundos
	ecall
	
	fase_2()
	j leteclafora2

help_tela:
	li a1, 0xFF000000	# endereco inicial
	printIMG(help) 	#imprime fundo
	
	j leteclafora2

credit_tela:
	li a1, 0xFF000000	# endereco inicial
	printIMG(credits) 	#imprime fundo
	
	j leteclafora2

fim:	li a7,10				# syscall de exit
	ecall
