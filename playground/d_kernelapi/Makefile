all: main

main: main.d c_lib.i
	dmd main.d c_lib.i

c_lib.i: c_lib.c
	gcc -E c_lib.c > c_lib.i

clean:
	rm -f c_lib.i main
