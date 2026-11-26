.RECIPEPREFIX := >
CC = gcc
CFLAGS = -std=gnu11 -g -O0 -Wall -Wextra

.PHONY: all asan clean

all: build/records

build/records: src/records.c
>mkdir -p build
>$(CC) $(CFLAGS) $< -o $@

asan: src/records.c
>mkdir -p build
>$(CC) $(CFLAGS) -fsanitize=address -fno-omit-frame-pointer $< -o build/records-asan

clean:
>rm -rf build
