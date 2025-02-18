; ./emulator/turing ./MT1/main.tm 30O_60L_2_5# -v

;-------------------------------

; Declara estados e variáveis

; #Q  = estados
; #S  = simbolos de entrada
; #G  = simbolos da fita
; #q0 = estado inicial
; #B  = simbolo vazio
; #F  = estado final
; #N  = numero de fitas

#Q = {init, initI, readI0, initIC, initI0, wrI, wrI0, wrI1, wrI2, wrI3, wrI4, wrI5, wrI6, wrI7, wrI8, wrI9, wrIO, wrIL, wrIX, wrID, wrIP, wrIC, readI, endI, initC, readC, readDecC, wrCL, wrCO, wrC1, readC0, wrC0, wrC01, subDecC, subCentC, addUnitC, endC, wrR, wrN, wrP, wr1, readR, clear, next, initT, readTN, readTP, readT0, readT1, subT1, addT1, initH, readH, unitH, decH, wrH1, addH1, endH, initD, endD, readD, readD1, wrD1, initE, readE, wrEP, wrEN, readR1, wrR1, readM, readM0, readM1, subM1, addM1, endM, endE, wrF, wrF2, wrF4, unitF, wrF1, decF, addF1, readF, initX, readX0, readX1, wrX1, wrX0, endX, initX1, initU, readU, wrU, wrU0, endU, end}
#S = {_,0,1,2,3,4,5,6,7,8,9,L,O,#}
#G = {_,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,C,P,D,F}
#B = _
#F = {end}
#N = 1

#q0 = init

;-------------------------------
; Trata a entrada para o formato C30O_C60L_P2_D5_#. os caracteres C, P e D ajudam a identificar o tipo de parametro e a computação necessária em cada caso

; primeiro, duplica todos os espaços no meio da entrada 

; escreve C na primeira posicao, primeiro comando
init * * l initIC
initIC _ C r initI

; move o cabeçote para a direita até encontrar _
initI * * r initI
initI _ # r readI0    
initI # # r wrIX         ; fim da entrada 

wrIX _ # l wrIX
wrIX # _ l wrID

; move o cabeçote para a direita até encontrar #
readI0 * *  r readI0
readI0 # _ r wrI

; atualiza caracter do final da entrada
wrI _ # l readI    

; escreve posição do proximo ID comando 
initI0 _ # r initI  

; le caracteres de entrada para reescrita
readI _ _ l readI
readI 0 _ r wrI0
readI 1 _ r wrI1
readI 2 _ r wrI2
readI 3 _ r wrI3
readI 4 _ r wrI4
readI 5 _ r wrI5
readI 6 _ r wrI6
readI 7 _ r wrI7
readI 8 _ r wrI8
readI 9 _ r wrI9
readI O _ r wrIO
readI L _ r wrIL
readI # _ r initI0  

; reescreve entrada
wrI _ # l readI
wrI0 _ 0 l readI
wrI1 _ 1 l readI
wrI2 _ 2 l readI
wrI3 _ 3 l readI
wrI4 _ 4 l readI
wrI5 _ 5 l readI
wrI6 _ 6 l readI
wrI7 _ 7 l readI
wrI8 _ 8 l readI
wrI9 _ 9 l readI
wrIO _ O l readI
wrIL _ L l readI

; escreve Identificadores 

wrID * * l wrID
wrID # D l wrIP

wrIP * * l wrIP
wrIP # P l wrIC

wrIC * * l wrIC
wrIC # C l endI

endI * * l endI
endI C C * initC

;-------------------------------
; #### coord.tm

; estado inicial, entrada, saida, direcao, estado novo

initC * * r initC
initC C # r initC ; # irá separar o resultado da entrada
initC _ _ l readC

readC L _ l wrCL
readC O _ l wrCO

;sinal
wrCL * * l wrCL
wrCL _ + r initC

wrCO * * l wrCO
wrCO _ - r initC


readC 0 0 l readDecC       ; Unidade 0, verifica dezena
readC 5 0 l subDecC        ; Subtrai 5 na unidade, subtrai 1 dezena

; Coordenada zerada
readDecC # # r readC0         
readC0 0 _ l wrC0

wrC0 * * l wrC0
wrC0 _ + l wrC01
wrC01 _ 0 r initC 

readC # # r endC

; Subtrai 10, já subtraiu 5
subDecC 1 0 l wrC1  ; 15
subDecC 4 3 l wrC1  ; 45 -> 30  
subDecC 7 6 l wrC1  ; 75 -> 60

subDecC 0 9 l subCentC  ; 105 -> 90
subDecC 3 2 l wrC1  ; 135 -> 120
subDecC 6 5 l wrC1  ; 165 -> 150

subCentC 1 0 l wrC1 ; subtrai centena

; Subtrai 20, adiciona 5
readDecC 3 1 r addUnitC     ; 30 -> 15
readDecC 6 4 r addUnitC     ; 60 -> 45
readDecC 9 7 r addUnitC     ; 90 -> 75

readDecC 2 0 r addUnitC     ; 120 -> 105
readDecC 5 3 r addUnitC     ; 150 -> 135
readDecC 8 6 r addUnitC     ; 180 -> 165

addUnitC 0 5 l wrC1
readDecC 0 0 r endC

wrC1 * * l wrC1
wrC1 _ 1 r initC

; prox funcao
endC _ 0 r endC
endC 0 0 r endC
endC C # r initC         ; segunda longitude

; #### FIM coord.tm

;-------------------------------
; EXEMPLO
; C15O_C150L_P1_D1# 
; 1111111111+1-C0000000000P1D1#
; Destino, Origem, C0, P1,D1
;-------------------------------


;escreve o resultado imediatamente antes da entrada, removendo os zeros desnecessarios

endC P P l wrR

; Atualiza posição do resultado
wrR _ # l readR   
wrR 0 # l readR    

;Procura proxima entrada diferente de 0 ou # para escrever
readR 0 0 l readR   
readR # 0 l readR   

readR - 0 r wrN 
readR + 0 r wrP
readR 1 0 r wr1

; Escreve resultado no lugar do #, move para esq e escreve #, pro prox result
wrN 0 0 r wrN
wrN # - l wrR

wrP 0 0 r wrP
wrP # + l wrR

wr1 0 0 r wr1
wr1 # 1 l wrR

; Após escrever resultado, limpa lixo à esq
readR _ _ r clear
clear 0 _ r clear
clear # _ r next      
clear 1 1 r next      

;usando next ao inves de initT

next * * r next
next P # l initT

;-------------------------------

; Calcula a diferença entre os fusos, operação à esquerda do P
; Destino - Origem

initT * * l initT

; Partida, inverte o sinal
initT - + l readTN
initT + - l readTP

readTN 1 1 l readTN
readTP 1 1 l readTP

; Sinais diferentes: adicao, substitui o sinal por 1 para concatenar valores. subtrai 1 do resultado
readTN + 1 l readT1
readTP - 1 l readT1

readT1 1 1 l readT1
readT1 _ _ r subT1
subT1 1 0 l readT0 

; Sinais iguais: subtracao.
readTN - 0 l readT0
readTP + 0 l readT0 

; readT0, cabeçote posicionado no 0, ex 110111.
; ao encontrar 1 a esq, remove 1 a dir

readT0 0 0 l readT0
readT0 1 0 r subT1
readT0 _ _ r clear  ;fim

subT1 0 0 r subT1

; resultado negativo, escreve oq sobrou removendo os zeros
subT1 - + l addT1
subT1 + - l addT1

addT1 0 1 l wrR    ; fim da subtração.  oq restou é o resultado 
; wrR irá escrever os 1 à esquerda da fita, ignorando os zeros no meio

next # # l initH    ; fim da função das coordenadas, escreve # no inicio da fita para separar o proximo resultado

initH * * l initH
initH _ + r readH


;-------------------------------

; Converte numeros decimais para unarios (horas)

readH * * r readH
readH _ _ l unitH

; subtrai unidade
unitH 1 0 l wrH1
unitH 2 1 l wrH1
unitH 3 2 l wrH1
unitH 4 3 l wrH1
unitH 5 4 l wrH1
unitH 6 5 l wrH1
unitH 7 6 l wrH1
unitH 8 7 l wrH1
unitH 9 8 l wrH1

unitH 0 0 l decH

decH 1 0 r addH1
decH 2 1 r addH1
addH1 0 9 l wrH1

wrH1 * * l wrH1
wrH1 _ 1 r readH

; escreve zeros para trazer o resultado parcial mais pra direita, junto com o restante da entrada
decH 0 0 r endH 
decH # 0 r endH

endH * * r endH
endH D D l wrR
endH # _ l endD

next D D l initD    ; inicia conversão da duração

initD * * l initD
initD _ D r readH

; Fita: [horario_partida] "+" [diferenca_fuso[sinal]] "D" [duracao_10] "_#"

; Após readH converter o valor de D, tem:
; Fita: [duracao] "D" [horario_partida] "+" [diferenca_fuso[sinal]]

;-------------------------------

; escreve a duração do voo a direita, logo depois da diferença de fuso. 
; Concatenando ambos, soma-se seus resultados

decH D _ r endH

; procura o resultado D a esquerda
endD 0 _ l endD
endD D D l readD1
endD * * l endD 

readD * * l readD   ;procura D à esquerda para escreve-lo a direita
readD D D l readD1

readD1 0 0 l readD1
readD1 1 0 r wrD1

wrD1 * * r wrD1
wrD1 _ 1 l readD

readD1 _ _ r clear
clear D _ r readE   ; arruma equação final, ordem de leitura da esquerda pra direita

;readE ignora o primeiro sinal (+) e escreve o sinal em seguida no seu lugar
readE 1 1 r readE
readE + # r initE

initE 1 1 r initE
initE # # r initE
initE + # l wrEP
initE - # l wrEN

wrEP 1 1 l wrEP
wrEP # + r initE

wrEN 1 1 l wrEN
wrEN # - r initE

initE _ _ l readR1

; subtrai 1 do final e adiciona no lugar de #

readR1 1 _ l wrR1
wrR1 1 1 l wrR1
wrR1 # 1 l readM    

; Fita: + [horario_partida] [sinal] [diferenca_fuso] [duracao]

; inicia operação matematica, procurando o sinal da operação
readM 1 1 l readM
readM + 1 r readM1  ; (+) substitui o + por 1 para concatenar valores e subtrai 1 ao final (dir)
readM - 0 r readM0  ; (-) subtrai 1 a dir, entao subtrai 1 a esq

readM1 1 1 r readM1
readM1 _ _ l subM1

readM0 0 0 r readM0
readM0 1 0 l subM1
readM0 _ _ l endE

subM1 1 0 r readM0  
subM1 0 0 l subM1
subM1 # 1 r endM    ; subtracao negativa. # representa a prox posicao de escrita

; negativo
subM1 _ - r addM1
subM1 - + r addM1
addM1 0 1 r endM
endM 0 # r readM0   ; marca posicao da prox escrita. fim da operacao de subtracao

; limpa zeros a esq
endE 0 _ l endE
endE 1 1 r endE

; fim. proximo modulo
endE _ F r wrF2  
endE # F r wrF2   
endE + 0 r wrF2    ; FIM. resultado zero



; Módulo de comparação. ; Verifica se o resultado esta entre 0 e 24. subtraindo o resultado por 24
; Fita: [resultado] "-24F" 

wrF2 _ 2 r wrF4
wrF4 _ 0 r wrF        ; Escreve 20 e substitui os 0 por 1 no final, totalizando 23.
wrF _ F l unitF 

; Converte numeros decimais para unarios (horas)
; Módulo com as mesmas transições da unitH, mas escreve à direita;

; subtrai unidade
unitF 1 0 r wrF1
unitF 2 1 r wrF1
unitF 3 2 r wrF1
unitF 4 3 r wrF1
unitF 5 4 r wrF1
unitF 6 5 r wrF1
unitF 7 6 r wrF1
unitF 8 7 r wrF1
unitF 9 8 r wrF1

unitF 0 0 l decF

decF 1 0 r addF1
decF 2 1 r addF1
addF1 0 9 r wrF1


wrF1 * * r wrF1
wrF1 _ 1 l readF
readF 1 1 l readF
readF F F l unitF

; Fita: [resultado] "-000" [1^24]     

decF 0 1 r decF 
decF F 1 l initX     

initX 1 1 l initX
initX F F l readX0

readX0 F F l readX0
readX0 1 0 r readX1
readX0 0 0 l readX0

readX1 F F r readX1
readX1 1 0 l readX0
readX1 0 0 r readX1

; < 24
readX0 _ _ r wrX1

wrX1 0 1 r wrX1
wrX1 F 0 r endX     ; F q separa a comparação

endX * 0 r endX
endX _ _ l initU

; = 24
readX1 _ _ l initX1

; > 24
initX1 0 _ l initX1
initX1 F _ l initX1

initX1 1 1 l initU
initX1 _ 0 * end

; < 0

readX0 - _ r wrX0   ;resultado negativo. escrever 1 a esq do prox 1
wrX0 0 _ r wrX0
wrX0 F _ r wrX0
wrX0 1 1 l wrX0
wrX0 _ 1 l initU


; Converte de unario para decimal: resultado final à esquerda

initU 0 _ l initU
initU 1 1 l initU
initU _ # r readU

readU # # r readU
readU 0 0 r readU
readU 1 # l wrU

wrU # # l wrU
;wrU 0 0 l wrU

wrU _ 1 r readU
wrU 0 1 r readU
wrU 1 2 r readU
wrU 2 3 r readU
wrU 3 4 r readU
wrU 4 5 r readU
wrU 5 6 r readU
wrU 6 7 r readU
wrU 7 8 r readU
wrU 8 9 r readU
wrU 9 0 l wrU0  

; escreve dezena
wrU0 _ 1 r readU 
wrU0 1 2 r readU ; escreve dezena

readU _ _ l endU
endU # _ l endU

endU * * * end  ; para no ultimo algarismo

end _ 0 * end   ; resultado nulo, escreve zero