; ./emulator/turing ./MATA51/unitTest/1coord.tm +11+1 -v    

; Recebe uma sequência de [fuso][fuso]
    ; [fuso]: [sin][num]
        ; [sin]: '+' ou 'n' ('n' representa negativo '-')
        ; [num]: número em unário

; Retorna o resultado da subtração do segundo fuso pelo primeiro.
; Representa a diferença de fuso horário entre as duas cidades.

; Exemplos:
    ; Entrada:  +11n1
    ; Saída:    n11n1 = n111

    ; Entrada: n11+1
    ; Saída:   +11+1 = +111

    ; Entrada: n11n1
    ; Saída:   +11n1 = +1

    ; Entrada: +11+1
    ; Saída:   n11+1 = n1

;-------------------------------

#Q = {signal, num, end, borrow, sub, add}
#S = {1,+,n}
#G = {1,+,n,_}
#B = _
#F = {end}
#N = 2

#q0 = signal
;-------------------------------


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

