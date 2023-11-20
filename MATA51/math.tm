; soma 2 unarios: 
; Entrada:  111+11
; Saída:    11111


; the finite set of states
#Q = {add, sub,end}

; the finite set of input symbols
#S = {1,+,-}

; the complete set of tape symbols
#G = {1,+,-,_}

; the start state
#q0 = add

; the blank symbol
#B = _

; the set of final states
#F = {end}

; the number of tapes
#N = 2

;-----------
add 1_ 11 rr add

add +_ +_ r* add
add -_ -_ rl sub


sub 11 1_ rl sub

add __ __ ** end
sub __ __ ** end

;numero negativo
sub 1_ 1- *r add



