# Makefile for Entombed!

# by Bill Kendrick
# bill@newbreedsoftware.com
# http://www.newbreedsoftware.com/entombed/

# May 19, 2002 - June 29, 2007


# User-definable stuff:

BIN_PREFIX=/usr/local/bin/
DATA_PREFIX=


# Defaults for Linux:

TARGET=entombed
TARGET_DEF=LINUX
# SDL_CFLAGS := $(shell sdl-config --cflags)
# SDL_LDFLAGS := $(shell sdl-config --libs)
CC=gcc

# Sound-related definitions:

MIXER=-lSDL_mixer
IMAGE=-lSDL_image
NOSOUNDFLAG=__SOUND
SIZEFLAG=__NOHALFSIZE

# Stuff we pass to the compiler:

CFLAGS=-arch $(ARCH) -Wall -D$(SIZEFLAG) $(SDL_CFLAGS) \
	-DDATA_PREFIX=\"$(DATA_PREFIX)\" -D$(NOSOUNDFLAG) -D$(TARGET_DEF)
SDL_LIB=$(MIXER) $(IMAGE) $(SDL_LDFLAGS)


# Make commands:

all:	$(TARGET)

install:
	mkdir -p $(DATA_PREFIX)
	cp -r data/images $(DATA_PREFIX)
	cp -r data/music $(DATA_PREFIX)
	cp -r data/sounds $(DATA_PREFIX)
	chown -R root.root $(DATA_PREFIX)
	chmod -R a+rX,g-w,o-w $(DATA_PREFIX)
	cp entombed $(BIN_PREFIX)
	chown root.root $(BIN_PREFIX)/entombed
	chmod a+rx,g-w,o-w $(BIN_PREFIX)/entombed

install_halfsize:
	mkdir -p $(DATA_PREFIX)
	mkdir -p $(DATA_PREFIX)/images
	cp -r data/images_halfsize/* $(DATA_PREFIX)/images
	cp -r data/music $(DATA_PREFIX)
	cp -r data/sounds $(DATA_PREFIX)
	chown -R root.root $(DATA_PREFIX)
	chmod -R a+rX,g-w,o-w $(DATA_PREFIX)
	cp entombed $(BIN_PREFIX)
	chown root.root $(BIN_PREFIX)/entombed
	chmod a+rx,g-w,o-w $(BIN_PREFIX)/entombed


nosound:
	make $(TARGET) MIXER= NOSOUNDFLAG=NOSOUND

win32:
	make TARGET_DEF=WIN32 TARGET=entombed.exe \
		DATA_PREFIX=data/ IMAGE="-lSDL_image -lpng -lz"
	cp /usr/local/cross-tools/i386-mingw32/lib/SDL*.dll .
	chmod 644 SDL*.dll

halfsize:
	make SIZEFLAG=HALFSIZE

embedded:
	make TARGET_DEF=EMBEDDED MIXER= \
		DATA_PREFIX=/opt/QtPalmtop/share/entombed/ \
		SDL_LIB="/usr/local/arm/lib/libSDL_mixer.a /usr/local/arm/lib/libSDL.a -L/opt/Qtopia/sharp/lib -lpthread -lqpe -lqte" \
		CC=/usr/local/arm/bin/arm-linux-gcc
	/usr/local/arm/bin/arm-linux-strip ${TARGET}

emtest:
	make $(TARGET) TARGET_DEF=EMBEDDED DATA_PREFIX=e/

clean:
	-rm entombed entombed.exe
	-rm obj/*.o
	-rmdir obj
	-rm SDL*.dll


# Main executable:

$(TARGET):	obj/entombed.o
	$(CC) $(CFLAGS) obj/entombed.o src/msputils.m -o $(TARGET) $(SDL_LIB) -lm


# Main object:

obj/entombed.o:	src/entombed.c
	-mkdir obj
	$(CC) $(CFLAGS) src/entombed.c -c -o obj/entombed.o

