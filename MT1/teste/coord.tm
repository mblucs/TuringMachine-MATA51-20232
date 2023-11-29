
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

#Q = {initC, readC, readDecC, wrCL, wrCO, wrC1, subDecC, subCentC, addUnitC, endC, end}
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
initC _ _ l readC

readC L _ l wrCL
readC O _ l wrCO

;sinal
wrCL * * l wrCL
wrCL C C l wrCL
wrCL _ + r initC

wrCO * * l wrCO
wrCO C C l wrCO
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

; #### FIM coord.tm
;-------------------------------