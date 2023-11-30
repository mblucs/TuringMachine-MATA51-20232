; ./emulator/turing ./MT1/main.tm 30O_60L_2_5# -v
; ./emulator/turing ./MT1/main.tm C30O_C60L_P2_D5_# -v


#Q = {init, initI, initI0, wrI, wrI1, wrIL, wrIX, wrID, wrIP, wrIC, readI, readIX, endI, end}
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D}
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,F,X}
#B = _
#F = {end}
#N = 1

#q0 = init

; -----------

; duplica os espaços para conseguir escrever os IDs

init * * r init
init _ # r initI    ; prox espaço de ID comando

; final da fita
initI * *  r initI
initI # _ r wrI

;wrI armazena o proximo Id comando
wrI _ # l readI

;; le entrada
readI _ _ l readI
readI 1 _ r wrI1
readI # _ r initI0

initI0 _ # r init

; escreve entrada
wrI _ # l readI
wrI1 _ 1 l readI

; escreve Identificadores 
init # # l wrID

wrID * * l wrID
wrID # D l wrIP

wrIP * * l wrIP
wrIP # P l wrIC


wrIC * * l wrIC
wrIC # C l end

endI * * l endI
endI _ C * end