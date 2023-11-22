; ./emulator/turing ./MATA51/main.tm 75L_15O -v    
; Entrada: C15L_C15O_P1_D2
; Saída: +11_P1_D2


; the finite set of states
#Q = {initC, unitC, decC, centC, next, endC, writeC, initT, reverse, num, one, sub, add, endT, posT, writeT, signal, initP, end}

; the finite set of input symbols
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D}

; the complete set of tape symbols
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D}

; the start state
#q0 = next

; the blank symbol
#B = _

; the set of final states
#F = {end}

; the number of tapes
#N = 2

;<currStt0> <currSymbl> <newSymbl> <dir> <newStt>

next C_ __ r* initC  ; Inicia função das coordenadas 

;-------------------------------
; #### coord.tm

initC ** ** r* initC
initC __ __ l* unitC

; --- Após subtração, corrige ultimo digito (unidade)
unitC 5_ 01 l* decC    
unitC 0_ 0_ l* decC

unitC 01 51 *r unitC

decC 11 _1 rr next ; fim

decC 3_ 11 r* unitC   ;30
decC 6_ 41 r* unitC   ;60
decC 9_ 71 r* unitC   ;90
decC 2_ 01 r* unitC   ;120
decC 5_ 31 r* unitC   ;150
decC 8_ 61 r* unitC   ;180

decC 41 31 rr unitC   ;45
decC 71 61 rr unitC   ;75
decC 01 91 l* centC   ;105
decC 31 21 rr unitC   ;135
decC 61 51 rr unitC   ;165

; centena
centC 11 _1 rr initC
decC __ __ ** next

; Leste(+) ou Oeste(-)?
unitC L_ _+ lr unitC
unitC O_ _- lr unitC

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
writeC _P __ lr initT    ; Retoma inicio da fita para começar proxima função

;-------------------------------


;-------------------------------
; Calcula a diferença de fuso horário

; #### dif_time.tm

initT *_ *_ ll initT
initT __ __ rr reverse    

; Armazena sinal reverso
reverse +_ -- r* num
reverse -_ ++ r* num


; Percorre até o final do NUMERO
num 1* 1* r* num

; Adição: adiciona 1 no espaço e subtrai no final
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

; Resultado negativo. Inverte o sinal

sub -1 +1 r* add
sub +1 -1 r* add

add _1 1_ rr add

sub 1_ 1_ ** endT

; #### FIM dif_time.tm
;-------------------------------

; TRANSIÇÃO
; Remove espaços em branco, e substitui o D pelo sinal (define a direção do voo + ou-)

; Armazena resultado para reescrever
endT 1_ _1 lr endT
endT +_ _+ lr endT
endT -_ _- lr endT
endT __ __ rr initP  

initP __ __ r*  initP
initP P_ _P rr init

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

