; Recebe 2 coordenadas no formato e retorna os fusos horários

; ./emulator/turing ./MATA51/main.tm 75L_15O -v    
; Entrada: C75L_C15O
; Saída: +11111  |  -1


; Entrada: 75L  |  15O


; the finite set of states
#Q = {Coord, cont, unit, dec, cent, end, init, writeF1}

; the finite set of input symbols
#S = {C,0,1,2,3,4,5,6,7,8,9,L,O,_,#}

; the complete set of tape symbols
#G = {C,0,1,2,3,4,5,6,7,8,9,_,L,O,+,-, #}

; the start state
#q0 = Coord

; the blank symbol
#B = _

; the set of final states
#F = {end}

; the number of tapes
#N = 2

;<currStt0> <currSymbl> <newSymbl> <dir> <newStt>

Coord C_ __ r* cont

;-------------------------------
; #### coord.tm

cont ** ** r* cont
cont __ __ l* unit

; --- Após subtração, corrige ultimo digito (unidade)
unit 5_ 01 l* dec    
unit 0_ 0_ l* dec

unit 01 51 *r unit

dec 11 _1 rr Coord ; fim

dec 3_ 11 r* unit   ;30
dec 6_ 41 r* unit   ;60
dec 9_ 71 r* unit   ;90
dec 2_ 01 r* unit   ;120
dec 5_ 31 r* unit   ;150
dec 8_ 61 r* unit   ;180

dec 41 31 rr unit   ;45
dec 71 61 rr unit   ;75
dec 01 91 l* cent   ;105
dec 31 21 rr unit   ;135
dec 61 51 rr unit   ;165

; centena
cent 11 _1 rr cont
dec __ __ ** Coord

; Leste(+) ou Oeste(-)?
unit L_ _+ lr unit
unit O_ _- lr unit

Coord 0* _* r* Coord
Coord _* _* r* Coord
Coord #_ __ rl init

; #### FIM coord.tm
;-------------------------------

;-------------------------------
; #### Transição

; volta pro inicio da fita
init ** ** ll init
init __ __ rr writeF1

; copia resultado da fita 2 na 1 fita

writeF1 _+ +_ rr writeF1  
writeF1 _- -_ rr writeF1  
writeF1 _1 1_ rr writeF1  
writeF1 __ __ ** end

;-------------------------------


