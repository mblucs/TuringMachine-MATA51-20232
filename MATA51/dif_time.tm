; recebe os horários na cidade de origem e destino e retorna a diferença de fuso horários; 
; Entrada: 11-, 111+
; Saída: 11111

; the finite set of states
#Q = {0,1}

; the finite set of input symbols
#S = {0,1}

; the complete set of tape symbols
#G = {0,1,_}

; the start state
#q0 = 0

; the blank symbol
#B = _

; the set of final states
#F = {1}

; the number of tapes
#N = 2

;<current state> <current symbol> <new symbol> <direction> <new state>
