; ./emulator/turing ./MT1/main.tm C30O_C60L_P2_D5_# -v

;-------------------------------

; Declara estados e variáveis

; #Q  = estados
; #S  = simbolos de entrada
; #G  = simbolos da fita
; #q0 = estado inicial
; #B  = simbolo vazio
; #F  = estado final
; #N  = numero de fitas

#Q = {initC, readC, readDecC, wrCL, wrCO, wrC1, subDecC, subCentC, addUnitC, endC, wrR, wrN, wrP, wr1, readR, clear, next, initT, readTN, readTP, readT0, readT1, subT1, addT1, initH, readH, unitH, decH, wrH1, addH1, decH, endH, initD, endD, readD, readD1, wrD1, initE, wrEP, wrEN, readR1, wrR1, readM, readM0, readM1, subM1, endE, end}
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D}
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,F}
#B = _
#F = {end}
#N = 1

#q0 = initC
;-------------------------------

;-------------------------------
; #### coord.tm


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
endC C 0 r initC         ; segunda longitude

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
clear D # r initE   ; arruma equação final, ordem de leitura da esquerda pra direita

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
readM + 1 l readM1  ; (+) substitui o + por 1 para concatenar valores e subtrai 1 ao inicio 
readM - 0 r readM0  ; (-) subtrai 1 a dir, subtrai 1 a esq


readM1 1 1 l readM1
readM1 + + r subM1

subM1 1 0 r readM0  
subM1 0 0 l subM1

readM0 0 0 r readM0
readM0 1 0 l subM1
readM0 _ _ l endE


; limpa zeros a esq
endE 0 _ l endE
endE _ _ r end


; > ./MT1/exemplos/main.txt

