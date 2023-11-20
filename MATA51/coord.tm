; Converte coordenadas para horas (unario). cada 15º representam 1h
; Entrada: 75L  |  15O
; Saída: +11111  |  -1


; the finite set of states
#Q = {q0, unit, end, dec, cent}

; the finite set of input symbols
#S = {0,1,2,3,4,5,6,7,8,9,L,O, _}

; the complete set of tape symbols
#G = {0,1,2,3,4,5,6,7,8,9,_, L,O, +,-}

; the start state
#q0 = q0

; the blank symbol
#B = _

; the set of final states
#F = {end}

; the number of tapes
#N = 2

;<currStt0> <currSymbl> <newSymbl> <dir> <newStt>

q0 ** ** r* q0
q0 __ __ l* unit

; --- Após subtração, corrige ultimo digito (unidade)
unit 5_ 01 l* dec    
unit 0_ 0_ l* dec

unit 01 51 *r unit


dec 11 _1 r* end ; fim

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
cent 11 _1 rr q0
dec __ __ ** end
;end 0* _* rr end

; Leste(+) ou Oeste(-)?
unit L_ L+ lr unit
unit O_ O- lr unit

