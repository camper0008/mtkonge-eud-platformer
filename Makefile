
TARGET = game

CC = gcc
LD = gcc

CFLAGS = -xc -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Werror
LFLAGS = -lm

# ISO C apparently requires translation units to not be empty,
# this is apparently also true for header files
# and therefore it will complain about include guards
CFLAGS += -Wno-empty-translation-unit

# clangd in llvm version 10.0.0-4ubuntu1 complains unconditionally
# that functions marked 'static inline' and declared in header files
# are unused
CFLAGS += -Wno-unused-function

# for development build with gcc
CFLAGS += -g

# add Lua5.3
CFLAGS += $(shell pkg-config --cflags lua5.3)
LFLAGS += $(shell pkg-config --libs lua5.3)

# add SDL2
CFLAGS += $(shell pkg-config --cflags sdl2 SDL2_ttf)
LFLAGS += $(shell pkg-config --libs sdl2 SDL2_ttf)

CFILES = $(shell find core -name *.c)
OFILES = $(patsubst %.c, %.o, $(CFILES))
HFILES = $(wildcard find core -name *.h)

all: compile_flags.txt $(TARGET)

$(TARGET): $(OFILES)
	$(LD) $^ -o $@ $(LFLAGS)

%.o: %.c $(HFILES)
	$(CC) -o $@ -c $(CFLAGS) $<

compile_flags.txt:
	echo "$(CFLAGS)" | sed 's/\s\+/\n/g' > compile_flags.txt

.PHONY: clean

clean:
	$(RM) $(OFILES) $(TARGET)