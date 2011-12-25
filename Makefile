all: iqiq iqunpack

iqiq: iqiq.c
	gcc -Wall iqiq.c -o iqiq -lwbxml2

iqunpack: libwhefs
	gcc -Wall iqunpack.c -o iqunpack -lwhefs -I./libwhefs-20111103/include/wh -I./libwhefs-20111103/include/ -I./libwhefs-20111103/src/

libwhefs: 
	make -C libwhefs-20111103 all
	ln -s libwhefs-20111103/src/libwhefs.so .

