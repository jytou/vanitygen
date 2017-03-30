#SYSTEM=-D__SOLARIS__
#SYSTEM=-D__WIN32__
#SYSTEM=-D__MACOS__

SSE=-DUSE_SSE

default: all

all: vanity_scrypt.c
	gcc -O3 $(SYSTEM) $(SSE) vanity_scrypt.c -o vanitygen -lpthread

clean:
	rm -f vanitygen
