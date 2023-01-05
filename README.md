# Tiny C


Tiny C is a compiler based on the rules of c(sub part of c language). it will compile code and generate assembly level code x86-64. 

## 1. Lexical Analysis:
Lexical Analysis is the first phase of the compiler also known as a scanner. It converts the High level input program into a sequence of Tokens. Lexical Analysis can be implemented with the Deterministic finite Automata. The output is a sequence of tokens that is sent to the parser for syntax analysis.
Flex is used for lexical analysis. 

** Flex:: Flex is a free and open-source software alternative to lex. It is a computer program that generates lexical analyzers **
