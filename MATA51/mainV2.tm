; ./emulator/turing ./MATA51/main.tm 75L_15O -v    
; Entrada: C15L_C15O_P1_D2_#
; Saída: 11-11111


; the finite set of states
#Q = {init, initC, unitC, decC, centC, endC, writeC, initT, reverse, num, one, sub, add, endT, posT, writeT, signal, initH, unitH, decH, endH, writeH, writeD, writeS, addD, addR, subR, unitD, unitD2, decD, end}

; the finite set of input symbols
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,H}

; the complete set of tape symbols
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,H}

; the start state
#q0 = init

; the blank symbol
#B = _

; the set of final states
#F = {end}

; the number of tapes
#N = 2

;<currStt0> <currSymbl> <newSymbl> <dir> <newStt>

init C_ __ r* initC  ; Inicia função das coordenadas 

;-------------------------------
; #### coord.tm

initC ** ** r* initC
initC __ __ l* unitC

; --- Após subtração, corrige ultimo digito (unidade)
unitC 5_ 01 l* decC    
unitC 0_ 0_ l* decC

unitC 01 51 *r unitC

decC 11 _1 rr init ; fim

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
decC __ __ ** init

; Leste(+) ou Oeste(-)?
unitC L_ _+ lr unitC
unitC O_ _- lr unitC

; #### FIM coord.tm
;-------------------------------

;-------------------------------
; #### Transição

; Ignora espaços em branco e zeros; procura por # (fim Coordenadas)
init 0* _* r* init
init _* _* r* init
init P_ PP ll endC ; # representa o fim das coordenadas e inicio da proxima entrada (horario de partida)

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
endT __ __ r* initH 


;-------------------------------

; Converte numeros decimais para unarios (horas)

; toUnary.tm

initH __ __ r* initH

initH 1_ 1_ r* initH

initH P_ _H r* initH
initH D_ _H r* initH

initH *H *H r* initH ; vai ate o final do numero
initH _H _H lr unitH


;unidade
unitH 0_ 0_ l* decH
unitH 1_ 01 lr decH
unitH 2_ 11 *r unitH
unitH 3_ 21 *r unitH
unitH 4_ 31 *r unitH
unitH 5_ 41 *r unitH
unitH 6_ 51 *r unitH
unitH 7_ 61 *r unitH
unitH 8_ 71 *r unitH
unitH 9_ 81 *r unitH


; subtrai 1 dezena
decH 0_ 9_ ** unitH
decH 1_ _1 rr decH
decH 2_ 11 rr decH
decH __ ** ** endH

endH __ __ r* endH
endH 0_ __ r* endH
endH D_ D_ ll writeH    ; identifica prox entrada

;-------------------------------

; Escreve resultado

writeH _1 1_ ll writeH
writeH _H __ r* initH

endH #_ __ ll writeD

writeD _* _* ll writeD
writeD 11 11 *l writeD
writeD 1H 1H rl writeD
writeD _- -_ rl writeS
writeD _+ +_ rl writeS

writeS _1 1_ rl writeS
writeS __ __ *r writeS

;-------------------------------

; soma a duração do voo e a diferença de fuso horario.
writeS _H __ *r addD
addD _1 1_ rr addD
addD __ __ l* addR

; soma final

;-------------------------------

;math.tm

addR 1_ _1 ll addR

addR +_ __ *r addR
addR _1 1_ rr addR

addR -_ __ lr subR
subR 11 __ lr subR
subR _1 -1 r* addR ; numero negativo

addR __ __ l* unitD
subR *_ *_ ** unitD


;-------------------------------

; convert to decimal

;unidade
unitD 1_ _1 l* unitD
unitD 10 _1 l* unitD
unitD 11 _2 l* unitD
unitD 12 _3 l* unitD
unitD 13 _4 l* unitD
unitD 14 _5 l* unitD
unitD 15 _6 l* unitD
unitD 16 _7 l* unitD
unitD 17 _8 l* unitD
unitD 18 _9 l* unitD
unitD 19 _0 *l decD

decD __ _1 lr unitD
decD _1 _2 lr unitD2

unitD _* _* ** end

; trata limite superior (>23)
unitD2 1_ _1 l* unitD2
unitD2 10 _1 l* unitD2
unitD2 11 _2 l* unitD2
unitD2 12 _3 l* unitD2
unitD2 13 _0 *l decD

decD _2 __ lr unitD
