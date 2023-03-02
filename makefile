#####################################################
# make -- run complete project tinyC library and test
# make test
# make clean and cleantest
# make flex
# make bison
# make tinyC
# make library
# make clean
# make cleantest
######################################################

run: tinyC library test

tinyC: lex.yy.o ass6_20CS10006.tab.o translator target_translator
	g++ lex.yy.o ass6_20CS10006.tab.o ass6_20CS10006_translator.o \
	ass6_20CS10006_target_translator.o -lfl -o tinyC

lex.yy.o:flex
	g++ -c lex.yy.c

ass6_20CS10006.tab.o:
	g++ -c ass6_20CS10006.tab.c

translator:
	g++ -c ass6_20CS10006_translator.cxx

target_translator:
	g++ -c ass6_20CS10006_target_translator.cxx

flex: bison
	flex ass6_20CS10006.l

bison:
	bison -dtv ass6_20CS10006.y -W

library:
	gcc -c ass2_20CS10006.c
	ar -rcs libass2_20CS10006.a ass2_20CS10006.o

test:
	./tinyC 1 > ass6_20CS10006_quads1.out
	g++ -c ass6_20CS10006_1.s
	g++ ass6_20CS10006_1.o -o out_1 -L. -lass2_20CS10006 -no-pie

	./tinyC 2 > ass6_20CS10006_quads2.out
	g++ -c ass6_20CS10006_2.s
	g++ ass6_20CS10006_2.o -o out_2 -L. -lass2_20CS10006 -no-pie

	./tinyC 3 > ass6_20CS10006_quads3.out
	g++ -c ass6_20CS10006_3.s
	g++ ass6_20CS10006_3.o -o out_3 -L. -lass2_20CS10006 -no-pie

	./tinyC 4 > ass6_20CS10006_quads4.out
	g++ -c ass6_20CS10006_4.s
	g++ ass6_20CS10006_4.o -o out_4 -L. -lass2_20CS10006 -no-pie

	./tinyC 5 > ass6_20CS10006_quads5.out
	g++ -c ass6_20CS10006_5.s
	g++ ass6_20CS10006_5.o -o out_5 -L. -lass2_20CS10006 -no-pie

cleantest:
	rm out_1\
	   out_2\
	   out_3\
	   out_4\
	   out_5\
	   ass6_20CS10006_quads1.out\
	   ass6_20CS10006_quads2.out\
	   ass6_20CS10006_quads3.out\
	   ass6_20CS10006_quads4.out\
	   ass6_20CS10006_quads5.out\
	   ass6_20CS10006_1.o\
	   ass6_20CS10006_2.o\
	   ass6_20CS10006_3.o\
	   ass6_20CS10006_4.o\
	   ass6_20CS10006_5.o\
	   ass6_20CS10006_1.s\
	   ass6_20CS10006_2.s\
	   ass6_20CS10006_3.s\
	   ass6_20CS10006_4.s\
	   ass6_20CS10006_5.s
clean:
	rm lex.yy.c\
	   ass6_20CS10006.tab.c\
	   ass6_20CS10006.tab.h\
	   lex.yy.o\
	   ass6_20CS10006.tab.o\
	   ass6_20CS10006.output\
	   ass6_20CS10006_translator.o\
	   ass6_20CS10006_target_translator.o\
	   ass6_20CS10006_translator.h.gch\
	   tinyC\
	   libass2_20CS10006.a\
	   ass2_20CS10006.o