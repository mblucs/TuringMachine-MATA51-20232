; ./emulator/turing ./MATA51/main.tm 75L_15O -v    
; Entrada: C15L_C15O_P1_D2
; Saída: +11_P1_D2


; the finite set of states
#Q = {cont, unit, dec, cent, next, endC, writeC, init, signal, num, one, sub, add, endT}

; the finite set of input symbols
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D}

; the complete set of tape symbols
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D}

; the start state
#q0 = next

; the blank symbol
#B = _

; the set of final states
#F = {endT}

; the number of tapes
#N = 2

;<currStt0> <currSymbl> <newSymbl> <dir> <newStt>

next C_ __ r* cont  ; Inicia função das coordenadas 

;-------------------------------
; #### coord.tm

cont ** ** r* cont
cont __ __ l* unit

; --- Após subtração, corrige ultimo digito (unidade)
unit 5_ 01 l* dec    
unit 0_ 0_ l* dec

unit 01 51 *r unit

dec 11 _1 rr next ; fim

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
dec __ __ ** next

; Leste(+) ou Oeste(-)?
unit L_ _+ lr unit
unit O_ _- lr unit

; #### FIM coord.tm
;-------------------------------

;-------------------------------
; #### Transição

; Ignora espaços em branco e zeros; procura por # (fim Coordenadas)
next 0* _* r* next
next _* _* r* next
next P_ PP ll endC ; # representa o fim das coordenadas e inicio da proxima entrada (horario de partida)

; volta pro inicio da fita para escrever resultado
endC _* _* ll endC
endC __ __ ** writeC    

writeC __ __ *r writeC  ; Começa a escrever
writeC _+ +_ rr writeC  
writeC _- -_ rr writeC  
writeC _1 1_ rr writeC  
writeC _P __ lr init    ; Retoma inicio da fita para começar proxima função

init *_ *_ ll init
init __ __ rr signal    
;-------------------------------


;-------------------------------
; Calcula a diferença de fuso horário

; #### dif_time.tm

;captura sinal no horario da cidade de origem

signal +_ -- r* num
signal -_ ++ r* num


; Percorre até o final do NUMERO
num 1* 1* r* num

; Adição: preenche o espaço com 1 e retira do final
num -- 11 r* one 
num ++ 11 r* one

one 11 11 r* one
one _1 _1 l* sub

sub 11 __ ll sub

; Subtração. adiciona os numero do destino na f2, e depois subtrai f1 por f2
num -+ __ rr add  
num +- __ rr add

add 1_ _1 rr add

add __ __ ll sub
sub _1 _1 l* sub

sub 1_ 1_ r* endT


; Subtração excedeu o valor original. troca o sinal.

sub -1 +1 r* add
sub +1 -1 r* add

add _1 1_ rr add

; #### FIM dif_time.tm
;-------------------------------

; TRANSIÇÃO
; Remove espaços em branco, e substitui o D pelo sinal (define a direção do voo + ou-)




; Converte numeros decimais para unarios (horas)


;-------------------------------
; #### hora de partida (P)

; #### Converter pra unario


; #### FIM 
;-------------------------------


;-------------------------------
; #### duração do voo

; #### FIM 
;-------------------------------

