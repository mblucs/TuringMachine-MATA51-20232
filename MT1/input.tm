; ./emulator/turing ./MT1/main.tm 30O_60L_2_5# -v
; ./emulator/turing ./MT1/main.tm C30O_C60L_P2_D5_# -v


#Q = {init, initI, readI0, initIC, initI0, wrI, wrI1, wrIL, wrIX, wrID, wrIP, wrIC, readI, readIX, endI, end}
#S = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D}
#G = {_,C,0,1,2,3,4,5,6,7,8,9,L,O,+,-,#,P,D,F,X}
#B = _
#F = {end}
#N = 1

#q0 = init

; -----------

; duplica os espaços para conseguir escrever os IDs

; escreve C na primeira posicao, primeiro comando
init * * l initIC
initIC _ C r initI

; move o cabeçote para a direita até encontrar _
initI * * r initI
initI _ # r readI0    
initI # # l wrID         ; fim da entrada 

; move o cabeçote para a direita até encontrar #
readI0 * *  r readI0
readI0 # _ r wrI

; atualiza final da entrada
wrI _ # l readI    

; escreve posição do proximo ID comando 
initI0 _ # r initI  


; le caracteres de entrada para reescrita
readI _ _ l readI
readI 1 _ r wrI1
readI # _ r initI0  

; reescreve entrada
wrI _ # l readI
wrI1 _ 1 l readI

; escreve Identificadores 

wrID * * l wrID
wrID # D l wrIP

wrIP * * l wrIP
wrIP # P l wrIC

wrIC * * l wrIC
wrIC # C l endI

endI * * l endI
endI C C * end