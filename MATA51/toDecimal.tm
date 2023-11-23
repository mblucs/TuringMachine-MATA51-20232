; converte de decimal pra unario
; Entrada: 111
; Saída: 3

; the finite set of states
#Q = {q0, unit, dec, unit2, dec2, initDay, unitSub, end}

; the finite set of input symbols
#S = {0,1,2,3,4,5,6,7,8,9,-}

; the complete set of tape symbols
#G = {0,1,2,3,4,5,6,7,8,9,-,_}

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
unit 1_ _1 l* unit
unit 10 _1 l* unit
unit 11 _2 l* unit
unit 12 _3 l* unit
unit 13 _4 l* unit
unit 14 _5 l* unit
unit 15 _6 l* unit
unit 16 _7 l* unit
unit 17 _8 l* unit
unit 18 _9 l* unit
unit 19 _0 *l dec

dec __ _1 lr unit
dec _1 _2 lr unit2

unit _* _* ** end

; trata limite superior (>23)
unit2 1_ _1 l* unit2
unit2 10 _1 l* unit2
unit2 11 _2 l* unit2
unit2 12 _3 l* unit2
unit2 13 _0 *l dec2

dec2 _2 __ lr unit

