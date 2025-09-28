FC=gfortran
CC=gcc
FFLAGS=-O3 -Wall -Wextra -std=f2008
SRC = resistores.f90
OBJ = $(SRC:.f90=.o)

OBJ_LINK = $(OBJ)

all: resistores.exe

resistores.exe: $(OBJ_LINK)
	$(FC) $(FFLAGS) -o $@ $^

%.o: %.f90
	$(FC) $(FFLAGS) -c -o $@ $<

clean:
	del *.o
	del resistores.exe