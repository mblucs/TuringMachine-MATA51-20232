; converte de decimal pra unario

; the finite set of states
#Q = {q0, unit, dec, end}

; the finite set of input symbols
#S = {0,1,2,3,4,5,6,7,8,9}

; the complete set of tape symbols
#G = {0,1,2,3,4,5,6,7,8,9,_}

; the start state
#q0 = q0

; the blank symbol
#B = _

; the set of final states
#F = {end}

; the number of tapes
#N = 2

;<currStt0> <currSymbl> <newSymbl> <dir> <newStt>

; Percorre até o final do numero
q0 ** ** r* q0
q0 __ __ l* unit

;unidade
unit 1_ 01 lr dec
unit 2_ 11 *r unit
unit 3_ 21 *r unit
unit 4_ 31 *r unit
unit 5_ 41 *r unit
unit 6_ 51 *r unit
unit 7_ 61 *r unit
unit 8_ 71 *r unit
unit 9_ 81 *r unit
unit 0_ 0_ l* dec

dec __ ** ** end

; subtrai 1 dezena
dec 1_ _1 rr dec
dec 0_ 9_ ** unit
dec 2_ 11 rr dec


