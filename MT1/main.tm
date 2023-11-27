
; ./emulator/turing ./MATA51/unitTest/1coord.tm 75L -v    

; Recebe um comando no formato C[num][dir]
    ; C:        representa o comando, "Coordenada"
    ; [num]:    numero da coordenada, em decimal; multiplo de 15
    ; [dir]:    direção da coordenada; "L" (Leste) ou "O" (Oeste)

; Retorna a hora em relação a GMT0. Cada 15º representam 1h. Assim, 15ºL = GMT+5

; Exemplo:
    ; Entrada: C75L
    ; Saída: +11111

; Resultado apresentado na fita 2

;-------------------------------

; Declara estados e variáveis

; #Q  = estados
; #S  = simbolos de entrada
; #G  = simbolos da fita
; #q0 = estado inicial
; #B  = simbolo vazio
; #F  = estado final
; #N  = numero de fitas

#Q = {initC, readC, readDecC, wrCL, wrCO, wrC1, subDecC, subCentC, addUnitC, endC, wrR, wrN, wrP, wr1, readR, clear, next, initT, readTN, readTP, readT0, readT1, subT1, addT1, endT, initP, end}
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,H}
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,H,F}
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

; Sinais iguas: adicao, substitui o sinal por 1 para concatenar valores. subtrai 1 do resultado
readTN - 1 l readT1
readTP + 1 l readT1

readT1 1 1 l readT1
readT1 _ _ r subT1
subT1 1 0 l readT0 ;teste 

; Sinais diferentes: subtracao.
readTN + 0 l readT0
readTP - 0 l readT0 

; readT0, cabeçote posicionado no 0, ex 110111.
; remove 1 a esq e 1 a dir, sucessivamente

readT0 0 0 l readT0
readT0 1 0 r subT1
readT0 _ _ r clear  ;fim

subT1 0 0 r subT1

; resultado negativo, escreve oq sobrou removendo os zeros
subT1 - + l addT1
subT1 + - l addT1

addT1 0 1 l wrR    ; fim da subtração.  oq restou é o resultado 
; escreve # a esq (wrR)
;endT 0 0 l readR

endT * * r endT
endT # # r initP
next # # r initP


; > ./MT1/exemplos/main.txt