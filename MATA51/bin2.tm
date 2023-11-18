; the finite set of states
#Q = { q0, div, add, back, q1}

; the finite set of input symbols
#S = {0,1,2,3,4,5,6,7,8,9}

; the complete set of tape symbols
#G = {0,1,2,3,4,5,6,7,8,9,_}

; the start state
#q0 = q0

; the blank symbol
#B = _

; the set of final states
#F = {q1}

; the number of tapes 
#N = 2

;<current state> <current symbol> <new symbol> <direction> <new state>

; percorre ate o fim
q0 *_ *_ rr q0
q0 __ __ ll div

;divide /2
div 0_ 00 ** div
div 2_ 10 ** div
div 4_ 20 ** div
div 6_ 30 ** div
div 8_ 40 ** div

div 1_ 01 ** div
div 3_ 11 ** div

;
div 1* ;fita 2 preenchida

;fim da divisao, go back
div _* _* rl back
back ** ** r* back
