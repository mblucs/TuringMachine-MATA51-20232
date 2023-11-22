; Recebe 2 coordenadas no formato e retorna os fusos horários

; ./emulator/turing ./MATA51/2coord.tm C15L_C15O_# -v    
; Entrada: C15L_C15O_#
; Saída: -11


; Entrada: 75L  |  15O


; the finite set of states
#Q = {cont, unit, dec, cent, next, endC, writeC,TimeZone, signal, num, borrow, sub, add, end}

; the finite set of input symbols
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P}

; the complete set of tape symbols
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P}

; the start state
#q0 = next

; the blank symbol
#B = _

; the set of final states
#F = {end}

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
next P_ P_ ll endC ; # representa o fim das coordenadas e inicio da proxima entrada (horario de partida)

; volta pro inicio da fita para escrever resultado
endC _* _* ll endC
endC __ __ ** writeC    

writeC __ __ rr writeC ; Começa a escrever
writeC _+ +_ rr writeC  
writeC _- -_ rr writeC  
writeC _1 1_ rr writeC  
writeC P_ P_ rr TimeZone ; proxima função

;-------------------------------



;-------------------------------
; #### dif_time.tm



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

