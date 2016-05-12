TARGET=shairport

#SRCS := shairport.c daemon.c rtsp.c mdns.c mdns_external.c mdns_tinysvcmdns.c common.c rtp.c metadata.c player.c alac.c audio.c audio_dummy.c audio_pipe.c tinysvcmdns.c
#DEPS := config.mk alac.h audio.h common.h daemon.h getopt_long.h mdns.h metadata.h player.h rtp.h rtsp.h tinysvcmdns.h

OBJS+=./daemon.o
OBJS+=./rtsp.o
OBJS+=./mdns.o
OBJS+=./mdns_external.o
OBJS+=./mdns_tinysvcmdns.o
OBJS+=./common.o
OBJS+=./crypto.o
OBJS+=./rtp.o
OBJS+=./metadata.o
OBJS+=./player.o
OBJS+=./alac.o
OBJS+=./audio.o
OBJS+=./audio_dummy.o
OBJS+=./audio_pipe.o
OBJS+=./tinysvcmdns.o
#OBJS+=./audio_alsa.o
OBJS+=./audio_ao.o

CFLAGS=
LIBS=

ifndef PREFIX
PREFIX=/usr/local
endif
CFLAGS+=-DCONFIG_HAVE_POLARSSL -std=gnu99 -Wall -O2 -fPIC -I$(HOME)/usr/local/include
LDFLAGS+=-L$(HOME)/usr/local/lib
CC=gcc
AR=ar
RANLIB=ranlib
ARFLAGS=rcu
STRIP=strip
LIBS+=polarssl pthread rt m


all: $(TARGET)

$(TARGET): $(TARGET).o
	@echo "LD $@"
	@$(CC) -I./ $(CFLAGS) ./$(TARGET).o $(OBJS) -L./lib $(LDFLAGS) $(addprefix -l,$(LIBS)) -o $@
	@echo "STRIP $@"
	@$(STRIP) $@
$(TARGET).o:$(OBJS)
	@echo "CFLAGS: ${CFLAGS}"
	@$(CC) -I./ $(CFLAGS) -c ./$(TARGET).c -o ./$(TARGET).o
install:
	@cp ./$(TARGET) ${PREFIX}/bin/
uninstall:
	@echo "rm '$(TARGET)' form '${PREFIX}/bin'"
	@rm -f ${PREFIX}/bin/$(TARGET)
touch:
	touch $(SRCS) 
clean:
	@echo "Clean ..."
	@rm -f ./$(TARGET)
	@rm -f ./lib/*.a
	@rm -f ./*.o
	@rm -f ./deps/lua-cjson/*.o
	@rm -f *~ */*~

.SECONDARY    :%.o 
# Compiling to object files.
%.o:%.c
	@echo "CC $<"
	@$(CC) $(CFLAGS) -I./ -c $< -o $@

.PHONY: test


