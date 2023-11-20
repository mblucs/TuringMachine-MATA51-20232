; recebe os horários na cidade de origem e destino e retorna a diferença de fuso horários; 
; -Origem +Destino
; notação: simbolo de menos (-) n suportado. usando 'n' no lugar

; Entrada:  +11n1
; Saída:    n11n1 = n111

; Entrada: n11+1
; Saída:   +11+1 = +111

; Entrada: n11n1
; Saída:   +11n1 = +1

; Entrada: +11+1
; Saída:   n11+1 = n1

; the finite set of states
#Q = {signal, num, end, borrow, sub, add}

; the finite set of input symbols
#S = {1,+,n}

; the complete set of tape symbols
#G = {1,+,n,_}

; the start state
#q0 = signal

; the blank symbol
#B = _

; the set of final states
#F = {end}

; the number of tapes
#N = 2

;<current state> <current symbol> <new symbol> <direction> <new state>

;captura sinal no horario da cidade de origem

signal +_ nn r* num
signal n_ ++ r* num


; Percorre até o final do NUMERO
num 1* 1* r* num

; Adição: preenche o espaço com 1 e retira do final
num nn 11 r* borrow 
num ++ 11 r* borrow

borrow 11 11 r* borrow
borrow _1 _1 l* sub

sub 11 __ ll sub

; Subtração. adiciona os numero do destino na f2, e depois subtrai f1 por f2
num n+ __ rr add  
num +n __ rr add

add 1_ _1 rr add

add __ __ ll sub
sub _1 _1 l* sub

sub 1_ 1_ r* end


; Subtração excedeu o valor original. troca o sinal.

sub n1 +1 r* add
sub +1 n1 r* add

add _1 1_ rr add

