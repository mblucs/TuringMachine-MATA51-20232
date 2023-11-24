
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

#Q = {init, initC, unitC, decC, centC, endC, writeC, initT, reverse, num, one, sub, add, endT, posT, writeT, signal, initH, unitH, decH, endH, writeH, writeD, writeO, addD, addR, subR, initF, unitF, decF, endF, day, nday, initD, unitD, unitD2, decD, endD, end}
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,H}
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,H,F}
#B = _
#F = {end}
#N = 2

#q0 = initC
;-------------------------------

;-------------------------------
; #### coord.tm

initC ** ** r* initC
initC __ __ l* unitC

; --- Após subtração, corrige ultimo digito (unidade)
unitC 5_ 01 l* decC    
unitC 0_ 0_ l* decC

unitC 01 51 *r unitC

decC 11 _1 rr init ; fim

decC 3_ 11 r* unitC   ;30
decC 6_ 41 r* unitC   ;60
decC 9_ 71 r* unitC   ;90
decC 2_ 01 r* unitC   ;120
decC 5_ 31 r* unitC   ;150
decC 8_ 61 r* unitC   ;180

decC 41 31 rr unitC   ;45
decC 71 61 rr unitC   ;75
decC 01 91 l* centC   ;105
decC 31 21 rr unitC   ;135
decC 61 51 rr unitC   ;165

; centena
centC 11 _1 rr initC
decC __ __ ** init

; Leste(+) ou Oeste(-)?
unitC L_ _+ lr unitC
unitC O_ _- lr unitC

; #### FIM coord.tm
;-------------------------------