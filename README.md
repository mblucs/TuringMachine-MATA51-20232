# MATA51-20232
Projeto final de teoria da computação 

[Emulador](https://github.com/StardustDL/turing-machine-emulator.git)


## Executar a máquina 
```
$ ./emulator/turing ./MATA51/MT1/main.tm <entrada> <flags>
$ ./emulator/turing ./MATA51/MT2/main.tm <entrada> <flags>
```
MT1 é uma máquina de uma fita;
MT2 é uma máquina de duas fitas;

Flags possíveis:

- `-v/--verbose` Details about error in parser and execution states in emulator.
- `-a/--auto` Use the metadata inferred from transfer edges when parsing.
- `-d/--debug` Pause the emulator when a breakpoint hits.


## Funções de transição
```
$ ./delta <arquivo.tm> <arquivo.txt>
```
Registra todas as transações &delta; da máquina <arquivo.tm> em <arquivo.txt>

&delta;(q_0, x) = (q_1, y, d) 