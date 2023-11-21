; Recebe 2 coordenadas no formato e retorna os fusos horários

; ./emulator/turing ./MATA51/main.tm 75L_15O -v    
; Entrada: C75L_C15O
; Saída: +11111  |  -1


; Entrada: 75L  |  15O


; the finite set of states
#Q = {Coord, cont, unit, dec, cent, endCoord, initF1, initF2, TimeZone, signal, num, borrow, sub, add, end}

; the finite set of input symbols
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#}

; the complete set of tape symbols
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#}

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
Coord #_ C_ rl initF2

; #### FIM coord.tm
;-------------------------------

;-------------------------------
; #### Transição

; volta pro inicio da fita
initF2 ** ** *l initF2
initF2 __ __ l* initF2      ; terminou de escrever na fita, procura qual a função a executar
initF2 C_ __ *r endCoord   ; escreve resultado das coordenadas


; copia resultado da fita 2 na 1 fita - resultado das coordenadas

endCoord _+ +_ rr endCoord  
endCoord _- -_ rr endCoord  
endCoord _1 1_ rr endCoord  
endCoord __ __ ** TimeZone

;-------------------------------



;-------------------------------
; #### dif_time.tm

TimeZone __ __ ll initF1
initF1 ** ** l* initF1
initF1 __ __ r* signal     

;captura sinal no horario da cidade de origem

signal +_ -- r* num
signal -_ ++ r* num


; Percorre até o final do NUMERO
num 1* 1* r* num

; Adição: preenche o espaço com 1 e retira do final
num -- 11 r* borrow 
num ++ 11 r* borrow

borrow 11 11 r* borrow
borrow _1 _1 l* sub

sub 11 __ ll sub

; Subtração. adiciona os numero do destino na f2, e depois subtrai f1 por f2
num -+ __ rr add  
num +- __ rr add

add 1_ _1 rr add

add __ __ ll sub
sub _1 _1 l* sub

sub 1_ 1_ r* end


; Subtração excedeu o valor original. troca o sinal.

sub -1 +1 r* add
sub +1 -1 r* add

add _1 1_ rr add



; #### FIM dif_time.tm
;-------------------------------


;-------------------------------
; #### hora de saida

; #### FIM 
;-------------------------------


;-------------------------------
; #### duração do voo

; #### FIM 
;-------------------------------

