; ./emulator/turing ./MATA51/main.tm C90L_C150O_P2_D4_#   

; Entrada: C90L_C30L_P8_D1_#
; Saída: 3

; Entrada: C90L_C30L_P3_D1_#
; Saída: 22

; Entrada: C75O_C15L_P15_D8_# 
; Saída: 5


; Entrada: C90L_C150O_P2_D4_#
; Saída: 6


;-------------------------------

#Q = {init, initC, unitC, decC, centC, endC, writeC, initT, reverse, num, one, sub, add, endT, posT, writeT, signal, initH, unitH, decH, endH, writeH, writeD, writeO, addD, addR, subR, initF, unitF, decF, endF, day, nday, initD, unitD, unitD2, decD, endD, end}
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,H}
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,H,F}
#q0 = init
#B = _
#F = {end}
#N = 2


;-------------------------------

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

; Escreve resultado da operação

writeH _1 1_ ll writeH
writeH _H __ r* initH

endH #_ __ ll writeD

writeD _* _* ll writeD
writeD 11 11 *l writeD
writeD _H _H l* writeD
writeD 1H 1H rl writeD
writeD _- -_ rl writeO
writeD _+ +_ rl writeO

writeO _1 1_ rl writeO
writeO __ __ *r writeO

;-------------------------------

; soma a duração do voo e a diferença de fuso horario.
writeO _H __ *r addD
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

addR __ _# ** initF
subR *_ *# r* initF


;-------------------------------

; Apresenta resultado final
;-------------------------------

; escreve 24 para comparar com resultado final

initF _# #2 r* initF
initF _2 24 r* initF
initF _4 4F r* initF

initF _F F_ l* unitH ; converte 24 horas para unario

endH F_ __ l* endF    ; alinha cabeçote no final
endF __ __ l* endF
endF #_ __ ll day

; 'day' verifica se o resultado está dentro das 24h do dia

day 11 10 ll day
day _1 _1 rr initD      ; (< 24), fim. apresenta resultado na fita 1

day 1_ 1_ rr day    ; (> 24), subtrai os 24 do resultado final na fita 1
day 10 _0 rr day
day __ __ ll initD

; negativo; apaga fita 1 e escreve oq sobrou da fita 2
day -1 _- r* day    ; identifica sinal negativo

day 1- _- r* day    ; apaga numero da fita 1
day _- 1_ rl nday    ; escreve resultado da fita 2 na fita 1

nday _1 1_ rl nday
nday __ __ l* initD

;-------------------------------
; convert to decimal

initD 10 1_ rr initD
initD __ __ l* unitD

initD _0 __ ll initD
initD 1_ 1_ ** unitD

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
decD _1 _2 lr unitD

unitD _* _* ** endD
unitD __ 0_ ** endD


; Escreve resultado final na fita 1
endD _0 0_ ll endD 
endD _1 1_ ll endD
endD _2 2_ ll endD
endD _3 3_ ll endD
endD _4 4_ ll endD
endD _5 5_ ll endD
endD _6 6_ ll endD
endD _7 7_ ll endD
endD _8 8_ ll endD
endD _9 9_ ll endD

endD __ __ rr end