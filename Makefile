CC         = gcc
CFLAGS     = -std=c23 -O3 -Wall -pedantic -Wstrict-prototypes
C_HEADER   = /usr/include/openblas/

#DLL_BLAS   = /usr/lib64/openblas-default/libopenblas.so
DLL_BLAS   = /usr/lib64/openblas-pthreads/libopenblas.so

SRC        = example_openblas.c
TARGET     = example_openblas

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -I $(C_HEADER) -o $(TARGET) $(SRC) $(DLL_BLAS)

# Housekeeping
.PHONY: clean
clean:
	rm -f $(TARGET) *.o
