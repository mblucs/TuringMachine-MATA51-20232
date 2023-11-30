; ./emulator/turing ./MT1/main.tm 30O_60L_2_5# -v
; ./emulator/turing ./MT1/main.tm C30O_C60L_P2_D5_# -v


#Q = {init, initI, readI0, initIC, initI0, wrI, wrI1, wrI2, wrI3, wrI4, wrI5, wrI6, wrI7, wrI8, wrI9, wrIO, wrIL, wrIX, wrID, wrIP, wrIC, readI, endI, end}
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D}
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,F,X}
#B = _
#F = {end}
#N = 1

#q0 = init

; ---------------

; duplica os espaços para conseguir escrever os IDs

; escreve C na primeira posicao, primeiro comando
init * * l initIC
initIC _ C r initI

; move o cabeçote para a direita até encontrar _
initI * * r initI
initI _ # r readI0    
initI # # r wrIX         ; fim da entrada 

wrIX _ # l wrIX
wrIX # _ l wrID

; move o cabeçote para a direita até encontrar #
readI0 * *  r readI0
readI0 # _ r wrI

; atualiza caracter do final da entrada
wrI _ # l readI    

; escreve posição do proximo ID comando 
initI0 _ # r initI  


; le caracteres de entrada para reescrita
readI _ _ l readI
readI 1 _ r wrI1
readI 2 _ r wrI2
readI 3 _ r wrI3
readI 4 _ r wrI4
readI 5 _ r wrI5
readI 6 _ r wrI6
readI 7 _ r wrI7
readI 8 _ r wrI8
readI 9 _ r wrI9
readI O _ r wrIO
readI L _ r wrIL
readI # _ r initI0  

; reescreve entrada
wrI _ # l readI
wrI1 _ 1 l readI
wrI2 _ 2 l readI
wrI3 _ 3 l readI
wrI4 _ 4 l readI
wrI5 _ 5 l readI
wrI6 _ 6 l readI
wrI7 _ 7 l readI
wrI8 _ 8 l readI
wrI9 _ 9 l readI
wrIO _ O l readI
wrIL _ L l readI

; escreve Identificadores 

wrID * * l wrID
wrID # D l wrIP

wrIP * * l wrIP
wrIP # P l wrIC

wrIC * * l wrIC
wrIC # C l endI

endI * * l endI
endI C C * end

; ---------------